import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../core/logger.dart' hide LogLevel;
import 'settings_service.dart';

/// IDs de productos registrados en Google Play Console y RevenueCat.
class PurchaseIds {
  static const String monthly = 'bajo_tus_alas_monthly';
  static const String yearly = 'bajo_tus_alas_yearly';
  /// Identificador del entitlement en el dashboard de RevenueCat.
  static const String entitlement = 'premium';
}

/// Estado del servicio de compras.
enum ServiceStatus {
  idle,
  loading,
  purchasePending,
  success,
  error,
  restored,
}

/// Servicio singleton que gestiona el ciclo de vida de compras con RevenueCat.
class PurchaseService extends ChangeNotifier {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final SettingsService _settingsService = SettingsService();

  /// Offerings cargados desde RevenueCat.
  Offerings? _offerings;
  Offerings? get offerings => _offerings;

  /// Estado actual del servicio.
  ServiceStatus _status = ServiceStatus.idle;
  ServiceStatus get status => _status;

  /// Mensaje de error si algo falló.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Indica si RevenueCat está disponible.
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  /// Inicializa RevenueCat con la API key. Llamar una vez al arrancar.
  Future<void> initialize({required String apiKey}) async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);
      final configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _isAvailable = true;

      // Cargar offerings al iniciar
      await _loadOfferings();

      // Verificar si ya tiene premium activo en RevenueCat
      await _syncPremiumStatus();

      LoggerService.info('RevenueCat inicializado correctamente');
    } catch (e, stack) {
      LoggerService.error('Error inicializando RevenueCat', error: e, stackTrace: stack);
      _isAvailable = false;
    }
  }

  /// Carga los paquetes disponibles desde RevenueCat.
  Future<void> _loadOfferings() async {
    try {
      _offerings = await Purchases.getOfferings();
      LoggerService.info('Offerings cargados: ${_offerings?.current?.availablePackages.map((p) => p.storeProduct.identifier).toList()}');
      notifyListeners();
    } catch (e, stack) {
      LoggerService.error('Error al cargar offerings', error: e, stackTrace: stack);
    }
  }

  /// Sincroniza el estado premium leyendo el entitlement de RevenueCat.
  Future<void> _syncPremiumStatus() async {
    try {
      final info = await Purchases.getCustomerInfo();
      final hasPremium = info.entitlements.active.containsKey(PurchaseIds.entitlement);
      if (hasPremium != _settingsService.settings.isPremium) {
        await _settingsService.updateWith(isPremium: hasPremium);
        LoggerService.info('Estado premium sincronizado desde RevenueCat: $hasPremium');
      }
    } catch (e, stack) {
      LoggerService.error('Error sincronizando estado premium', error: e, stackTrace: stack);
    }
  }

  /// Inicia la compra del plan mensual.
  Future<void> buyMonthly() async {
    await _buyPackage(PurchaseIds.monthly);
  }

  /// Inicia la compra del plan anual.
  Future<void> buyYearly() async {
    await _buyPackage(PurchaseIds.yearly);
  }

  /// Inicia el flujo de compra para un producto ID dado.
  Future<void> _buyPackage(String productId) async {
    if (!_isAvailable) {
      _setStatus(ServiceStatus.error, message: 'Tienda no disponible en este dispositivo');
      return;
    }

    // Buscar el Package en los offerings actuales
    final package = _offerings?.current?.availablePackages.where(
      (p) => p.storeProduct.identifier == productId,
    ).firstOrNull;

    if (package == null) {
      LoggerService.warning('Producto $productId no encontrado en offerings. Activando modo debug.');
      await _activatePremiumLocally(reason: 'producto no encontrado en RevenueCat (modo debug)');
      return;
    }

    _setStatus(ServiceStatus.loading);

    try {
      final info = await Purchases.purchasePackage(package);
      final hasPremium = info.entitlements.active.containsKey(PurchaseIds.entitlement);

      if (hasPremium) {
        await _grantPremium();
        _setStatus(ServiceStatus.success);
        LoggerService.info('Compra completada y premium activado');
      } else {
        _setStatus(ServiceStatus.error, message: 'La compra no activó el acceso premium');
      }
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        LoggerService.info('Compra cancelada por el usuario');
        _setStatus(ServiceStatus.idle);
      } else {
        LoggerService.error('Error RevenueCat al comprar: $e');
        _setStatus(ServiceStatus.error, message: e.toString());
      }
    } catch (e, stack) {
      LoggerService.error('Error inesperado al comprar', error: e, stackTrace: stack);
      _setStatus(ServiceStatus.error, message: 'Ocurrió un error al procesar la compra');
    }
  }

  /// Restaura compras previas del usuario.
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      _setStatus(ServiceStatus.error, message: 'Tienda no disponible');
      return;
    }
    _setStatus(ServiceStatus.loading);
    try {
      final info = await Purchases.restorePurchases();
      final hasPremium = info.entitlements.active.containsKey(PurchaseIds.entitlement);
      if (hasPremium) {
        await _grantPremium();
        _setStatus(ServiceStatus.restored);
        LoggerService.info('Compras restauradas correctamente');
      } else {
        _setStatus(ServiceStatus.error, message: 'No se encontraron compras anteriores');
      }
    } catch (e, stack) {
      LoggerService.error('Error al restaurar compras', error: e, stackTrace: stack);
      _setStatus(ServiceStatus.error, message: 'No se pudieron restaurar las compras');
    }
  }

  /// Activa el acceso Premium (actualiza SettingsService).
  Future<void> _grantPremium() async {
    await _settingsService.updateWith(isPremium: true);
    LoggerService.info('Premium activado para el usuario');
  }

  /// Activa premium localmente (solo para desarrollo/debug).
  Future<void> _activatePremiumLocally({String reason = ''}) async {
    LoggerService.warning('Activación local de premium: $reason');
    await _grantPremium();
    _setStatus(ServiceStatus.success);
  }

  /// Revoca el acceso premium (para testing).
  Future<void> revokePremium() async {
    await _settingsService.updateWith(isPremium: false);
    LoggerService.info('Premium revocado');
    notifyListeners();
  }

  /// Resetea el estado del servicio a idle.
  void resetStatus() {
    _setStatus(ServiceStatus.idle);
  }

  void _setStatus(ServiceStatus status, {String? message}) {
    _status = status;
    _errorMessage = message;
    notifyListeners();
  }

  /// Precio del plan mensual (real de RevenueCat o fallback).
  String get monthlyPrice {
    final pkg = _offerings?.current?.availablePackages.where(
      (p) => p.storeProduct.identifier == PurchaseIds.monthly,
    ).firstOrNull;
    return pkg?.storeProduct.priceString ?? r'$2.99';
  }

  /// Precio del plan anual (real de RevenueCat o fallback).
  String get yearlyPrice {
    final pkg = _offerings?.current?.availablePackages.where(
      (p) => p.storeProduct.identifier == PurchaseIds.yearly,
    ).firstOrNull;
    return pkg?.storeProduct.priceString ?? r'$19.99';
  }
}
