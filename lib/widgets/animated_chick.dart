import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import '../data/chick_svg_data.dart';

/// Widget animado "cozy" para los pollitos de emociones.
/// Cada emoción tiene su propia animación característica.
class AnimatedChick extends StatefulWidget {
  final String emotionName;
  final double size;

  const AnimatedChick({
    super.key,
    required this.emotionName,
    this.size = 50,
  });

  @override
  State<AnimatedChick> createState() => _AnimatedChickState();
}

class _AnimatedChickState extends State<AnimatedChick>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;

  @override
  void initState() {
    super.initState();

    // Controlador principal (movimiento base)
    _primaryController = AnimationController(
      vsync: this,
      duration: _getPrimaryDuration(),
    )..repeat(reverse: true);

    // Controlador secundario (detalle extra)
    _secondaryController = AnimationController(
      vsync: this,
      duration: _getSecondaryDuration(),
    )..repeat(reverse: true);
  }

  Duration _getPrimaryDuration() {
    switch (widget.emotionName) {
      case 'Feliz':
        return const Duration(milliseconds: 800);
      case 'Triste':
        return const Duration(milliseconds: 2500);
      case 'Ansioso':
        return const Duration(milliseconds: 1800);
      case 'Agradecido':
        return const Duration(milliseconds: 3000);
      case 'Cansado':
        return const Duration(milliseconds: 3500);
      case 'Temeroso':
        return const Duration(milliseconds: 2200);
      default:
        return const Duration(milliseconds: 1500);
    }
  }

  Duration _getSecondaryDuration() {
    switch (widget.emotionName) {
      case 'Feliz':
        return const Duration(milliseconds: 1200);
      case 'Triste':
        return const Duration(milliseconds: 4000);
      case 'Ansioso':
        return const Duration(milliseconds: 1400);
      case 'Agradecido':
        return const Duration(milliseconds: 2000);
      case 'Cansado':
        return const Duration(milliseconds: 2500);
      case 'Temeroso':
        return const Duration(milliseconds: 1600);
      default:
        return const Duration(milliseconds: 1500);
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _secondaryController]),
      builder: (context, child) {
        return _buildAnimatedChick();
      },
    );
  }

  Widget _buildAnimatedChick() {
    switch (widget.emotionName) {
      case 'Feliz':
        return _buildFeliz();
      case 'Triste':
        return _buildTriste();
      case 'Ansioso':
        return _buildAnsioso();
      case 'Agradecido':
        return _buildAgradecido();
      case 'Cansado':
        return _buildCansado();
      case 'Temeroso':
        return _buildTemeroso();
      default:
        return _buildDefault();
    }
  }

  /// Feliz: Rebota suavemente y se inclina con alegría
  Widget _buildFeliz() {
    final bounce = sin(_primaryController.value * pi) * 4;
    final tilt = sin(_secondaryController.value * pi * 2) * 0.05;
    return Transform.translate(
      offset: Offset(0, -bounce),
      child: Transform.rotate(
        angle: tilt,
        child: Transform.scale(
          scale: 1.0 + sin(_primaryController.value * pi) * 0.05,
          child: _svgWidget(),
        ),
      ),
    );
  }

  /// Triste: Se mece lentamente de lado a lado, como buscando consuelo
  Widget _buildTriste() {
    final sway = sin(_primaryController.value * pi * 2) * 3;
    final droop = sin(_secondaryController.value * pi) * 1.5;
    return Transform.translate(
      offset: Offset(sway, droop),
      child: Transform.rotate(
        angle: sin(_primaryController.value * pi * 2) * 0.03,
        child: _svgWidget(),
      ),
    );
  }

  /// Ansioso: Tiembla ligeramente y se mueve rápido
  Widget _buildAnsioso() {
    final shakeX = sin(_primaryController.value * pi * 6) * 2;
    final shakeY = sin(_secondaryController.value * pi * 4) * 1;
    return Transform.translate(
      offset: Offset(shakeX, shakeY),
      child: Transform.scale(
        scale: 1.0 + sin(_primaryController.value * pi * 2) * 0.03,
        child: _svgWidget(),
      ),
    );
  }

  /// Agradecido: Flota suavemente, resplandor tranquilo
  Widget _buildAgradecido() {
    final float = sin(_primaryController.value * pi) * 3;
    final glow = 0.8 + sin(_secondaryController.value * pi) * 0.2;
    return Transform.translate(
      offset: Offset(0, -float),
      child: Opacity(
        opacity: glow,
        child: Transform.scale(
          scale: 1.0 + sin(_primaryController.value * pi) * 0.03,
          child: _svgWidget(),
        ),
      ),
    );
  }

  /// Cansado: Se balancea lento, como cabeceando de sueño
  Widget _buildCansado() {
    final nod = sin(_primaryController.value * pi) * 0.08;
    final drift = sin(_secondaryController.value * pi) * 2;
    return Transform.translate(
      offset: Offset(drift * 0.5, 0),
      child: Transform.rotate(
        angle: nod,
        alignment: Alignment.bottomCenter,
        child: _svgWidget(),
      ),
    );
  }

  /// Temeroso: Tiembla y se encoge
  Widget _buildTemeroso() {
    final tremble = sin(_primaryController.value * pi * 8) * 1.5;
    final shrink = 1.0 - sin(_secondaryController.value * pi) * 0.08;
    return Transform.translate(
      offset: Offset(tremble, 0),
      child: Transform.scale(
        scale: shrink,
        child: _svgWidget(),
      ),
    );
  }

  Widget _buildDefault() {
    final float = sin(_primaryController.value * pi) * 2;
    return Transform.translate(
      offset: Offset(0, -float),
      child: _svgWidget(),
    );
  }

  Widget _svgWidget() {
    final svgString = ChickSvgData.emotions[widget.emotionName] ?? ChickSvgData.feliz;
    return SvgPicture.string(
      svgString,
      width: widget.size,
      height: widget.size,
    );
  }
}
