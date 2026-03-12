import 'package:flutter_test/flutter_test.dart';
import 'package:refugio_de_paz/services/purchase_service.dart';

void main() {
  group('PurchaseService', () {
    test('es un singleton', () {
      final a = PurchaseService();
      final b = PurchaseService();
      expect(identical(a, b), isTrue);
    });

    test('productIds contiene los IDs correctos', () {
      expect(PurchaseIds.all, contains(PurchaseIds.monthly));
      expect(PurchaseIds.all, contains(PurchaseIds.yearly));
      expect(PurchaseIds.monthly, 'bajo_tus_alas_monthly');
      expect(PurchaseIds.yearly, 'bajo_tus_alas_yearly');
    });

    test('precio mensual de fallback tiene formato correcto', () {
      final service = PurchaseService();
      // Sin productos cargados (no hay Play Store en tests), usa fallback
      expect(service.monthlyPrice, r'$2.99');
      expect(service.yearlyPrice, r'$19.99');
    });

    test('status inicial es idle', () {
      final service = PurchaseService();
      expect(service.status, PurchaseStatus.idle);
    });

    test('resetStatus vuelve a idle', () {
      final service = PurchaseService();
      service.resetStatus();
      expect(service.status, PurchaseStatus.idle);
    });

    test('productos inician vacíos', () {
      final service = PurchaseService();
      // Sin inicializar, la lista de productos está vacía
      expect(service.products, isEmpty);
    });
  });
}
