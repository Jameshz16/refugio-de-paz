import 'package:flutter/material.dart';
import 'animated_chick.dart';
import '../theme.dart';
import 'dart:math';

class EmotionJar extends StatelessWidget {
  final Map<String, int> emotionHistory;
  final List<Map<String, String>> emotions;

  const EmotionJar({
    super.key,
    required this.emotionHistory,
    required this.emotions,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a flat list of all emotions recorded
    final List<String> drops = [];
    for (var emotion in emotions) {
      final String name = emotion['name']!;
      final int count = emotionHistory[name] ?? 0;
      for (int i = 0; i < count; i++) {
        drops.add(name);
      }
    }

    // Mezclar las gotas para que se "acomoden" aleatoriamente en el frasco
    // Usamos una semilla fija solo durante el renderizado para que no brinque constantemente
    drops.shuffle(Random(42));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          'Tu Tarrito de Emociones',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 220,
          height: 280,
          decoration: BoxDecoration(
            color: context.cozy.surface.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            border: Border.all(
              color: context.cozy.primary.withOpacity(isDark ? 0.3 : 0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: context.cozy.primary.withOpacity(isDark ? 0.05 : 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              // Cuello del frasco (Rim)
              Positioned(
                top: 0,
                left: -3,
                right: -3,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: context.cozy.primary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Contenido (Canicas / Pollitos)
              Positioned.fill(
                top: 15,
                bottom: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      reverse: true, // Para ver el fondo siempre (acumulación desde abajo)
                      physics: const BouncingScrollPhysics(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        verticalDirection: VerticalDirection.up, // Llena de abajo hacia arriba
                        children: drops.map((emotionName) {
                          // Introducimos sutiles rotaciones a cada pollito para dar efecto físico
                          return Transform.rotate(
                            angle: (Random().nextDouble() - 0.5) * 0.5,
                            child: AnimatedChick(
                              emotionName: emotionName,
                              size: 28, // Pollitos pequeños
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              // Efecto de reflejo (Glance) en vidrio interactivo
              Positioned(
                top: 20,
                left: 20,
                bottom: 40,
                width: 20,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(isDark ? 0.1 : 0.4),
                          Colors.white.withOpacity(0.0),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
