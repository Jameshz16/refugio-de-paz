import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/purchase_service.dart';
import '../theme.dart';

class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({super.key});

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen> {
  final _purchaseService = PurchaseService();

  @override
  void initState() {
    super.initState();
    _purchaseService.addListener(_onPurchaseUpdate);
    // Reiniciamos el estado por si quedó algún error anterior
    _purchaseService.resetStatus();
  }

  @override
  void dispose() {
    _purchaseService.removeListener(_onPurchaseUpdate);
    super.dispose();
  }

  void _onPurchaseUpdate() {
    if (!mounted) return;

    final status = _purchaseService.status;

    if (status == ServiceStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Gracias por tu apoyo! Disfruta de Bajo Tus Alas Premium ✨'),
          backgroundColor: context.cozy.accent,
          duration: const Duration(seconds: 3),
        ),
      );
      _purchaseService.resetStatus();
      Navigator.of(context).pop();
    } else if (status == ServiceStatus.restored) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Compras restauradas! Bienvenido de vuelta Premium ✨'),
          backgroundColor: context.cozy.accent,
          duration: const Duration(seconds: 3),
        ),
      );
      _purchaseService.resetStatus();
      Navigator.of(context).pop();
    } else if (status == ServiceStatus.error) {
      final msg = _purchaseService.errorMessage ?? 'Ocurrió un error inesperado.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $msg'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
      _purchaseService.resetStatus();
    }

    setState(() {});
  }

  bool get _isLoading =>
      _purchaseService.status == ServiceStatus.loading ||
      _purchaseService.status == ServiceStatus.purchasePending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cozy.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: context.cozy.surface,
            iconTheme: IconThemeData(color: context.cozy.textDark),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.cozy.accent.withOpacity(0.4),
                      context.cozy.pastel.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Icon(Icons.workspace_premium_rounded, size: 72, color: context.cozy.accent),
                      const SizedBox(height: 8),
                      Text(
                        'Bajo Tus Alas',
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: context.cozy.textDark,
                        ),
                      ),
                      Text(
                        'Premium',
                        style: GoogleFonts.dancingScript(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: context.cozy.pastel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Encuentra tu refugio de paz total.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.cozy.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Apoya el desarrollo de la aplicación y desbloquea todas las herramientas para tu bienestar espiritual y emocional.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.cozy.textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Benefits List
                  _buildBenefit(
                    icon: Icons.palette_rounded,
                    title: 'Temas Visuales Exclusivos',
                    description:
                        'Personaliza tu refugio con paletas de color diseñadas para transmitir paz.',
                  ),
                  _buildBenefit(
                    icon: Icons.auto_stories_rounded,
                    title: 'Diario Espiritual Ilimitado',
                    description:
                        'Guarda todas tus reflexiones sin límites y lee tu historial completo.',
                  ),
                  _buildBenefit(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Oraciones con IA Profundas',
                    description:
                        'Recibe consuelo guiado más profundo y personalizado a tus emociones.',
                  ),
                  _buildBenefit(
                    icon: Icons.notifications_active_rounded,
                    title: 'Planes Devocionales',
                    description: 'Próximamente: accede a planes de lectura de 30 días.',
                  ),

                  const SizedBox(height: 40),

                  // Plans
                  _buildPlanCard(
                    id: PurchaseIds.monthly,
                    title: 'Plan Mensual',
                    price: _purchaseService.monthlyPrice,
                    period: '/ mes',
                    description: 'Empieza tu camino de paz.',
                  ),
                  const SizedBox(height: 16),
                  _buildPlanCard(
                    id: PurchaseIds.yearly,
                    title: 'Plan Anual',
                    price: _purchaseService.yearlyPrice,
                    period: '/ año',
                    description: 'Ahorra un 40% y asegura tu refugio.',
                    isPopular: true,
                  ),

                  const SizedBox(height: 32),

                  if (_isLoading)
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: context.cozy.accent),
                          const SizedBox(height: 12),
                          Text(
                            _purchaseService.status == ServiceStatus.purchasePending
                                ? 'Procesando tu compra...'
                                : 'Conectando con la tienda...',
                            style: TextStyle(color: context.cozy.textLight, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Text(
                      'Puedes cancelar en cualquier momento desde\nGoogle Play → Suscripciones.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: context.cozy.textLight, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    // Restore Purchases button
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _purchaseService.restorePurchases(),
                        icon: Icon(Icons.restore_rounded, color: context.cozy.textLight, size: 18),
                        label: Text(
                          'Restaurar compras anteriores',
                          style: TextStyle(color: context.cozy.textLight, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.cozy.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.cozy.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(icon, color: context.cozy.accent, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.cozy.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.cozy.textLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required String period,
    required String description,
    bool isPopular = false,
  }) {
    final onTap = _isLoading
        ? null
        : () {
            if (id == PurchaseIds.monthly) {
              _purchaseService.buyMonthly();
            } else {
              _purchaseService.buyYearly();
            }
          };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPopular ? context.cozy.accent.withOpacity(0.1) : context.cozy.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPopular ? context.cozy.accent : context.cozy.primary.withOpacity(0.3),
            width: isPopular ? 2 : 1,
          ),
          boxShadow: [
            if (isPopular)
              BoxShadow(
                color: context.cozy.accent.withOpacity(0.12),
                blurRadius: 15,
                offset: const Offset(0, 6),
              )
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.cozy.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.lexend(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: context.cozy.accent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        period,
                        style: TextStyle(fontSize: 14, color: context.cozy.textLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: context.cozy.textLight),
                ),
              ],
            ),
            if (isPopular)
              Positioned(
                top: -32,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.cozy.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'MÁS POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
