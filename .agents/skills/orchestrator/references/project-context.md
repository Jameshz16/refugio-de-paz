# Contexto del Proyecto: Bajo Tus Alas

> Última actualización: 2026-03-02

## Resumen

**Refugio de Paz / Bajo Tus Alas** es una aplicación Flutter de acompañamiento espiritual y emocional. El usuario selecciona una emoción (representada por un pollito SVG animado), escribe un mensaje a Dios, y la IA DeepSeek genera un versículo bíblico personalizado con una oración.

---

## Estructura de Directorios

```
refugio_de_paz/
├── lib/
│   ├── main.dart                     # Entry point + HomeScreen (⚠️ 474 líneas)
│   ├── theme.dart                    # CozyTheme (colores pastel)
│   ├── models/
│   │   └── verse.dart                # Modelo: text, reference, prayer, isFavorite
│   ├── screens/
│   │   ├── diary_screen.dart         # Mi Diario con Dios
│   │   └── favorites_screen.dart     # Versículos guardados
│   ├── services/
│   │   ├── ai_service.dart           # DeepSeek API integration
│   │   ├── notification_service.dart # Notificaciones locales
│   │   └── storage_service.dart      # Persistencia con SharedPreferences
│   └── widgets/
│       └── animated_chick.dart       # Pollito SVG animado
├── assets/
│   └── emotions/                     # SVGs de emociones (6 pollitos)
│       ├── feliz.svg
│       ├── triste.svg
│       ├── ansioso.svg
│       ├── agradecido.svg
│       ├── cansado.svg
│       └── temeroso.svg
├── test/
│   └── widget_test.dart              # Test base (sin implementar)
├── docs/
│   └── Especificaciones_BajoTusAlas.md
└── .agents/skills/                   # 11 skills (incluido orchestrator)
```

---

## Dependencias Principales

| Paquete              | Uso                          |
| -------------------- | ---------------------------- |
| `flutter_svg`        | Renderizar pollitos SVG      |
| `shared_preferences` | Almacenamiento local         |
| `google_fonts`       | Tipografía personalizada     |
| `http`               | Llamadas HTTP a DeepSeek API |

---

## Emociones Disponibles

| Emoción    | Emoji | Color              | SVG              |
| ---------- | ----- | ------------------ | ---------------- |
| Feliz      | 😊    | `#4CAF50` (green)  | `feliz.svg`      |
| Triste     | 😢    | `#2196F3` (blue)   | `triste.svg`     |
| Ansioso    | 😰    | `#FF9800` (orange) | `ansioso.svg`    |
| Agradecido | 🙏    | `#9C27B0` (purple) | `agradecido.svg` |
| Cansado    | 😴    | `#607D8B` (grey)   | `cansado.svg`    |
| Temeroso   | 😨    | `#F44336` (red)    | `temeroso.svg`   |

---

## Flujo Principal del Usuario

```
[Home Screen Widget]
     │ "¿Cómo te sientes hoy?"
     ▼
[Fase 1: Grid de Pollitos]
     │ Tap en un pollito → HapticFeedback
     ▼
[Fase 2: TextField]
     │ "¿Qué tienes para decirle a Dios hoy?"
     │ → Enviar a DeepSeek API
     ▼
[Tarjeta de Versículo]
     │ Versículo + Oración personalizada
     │ → Guardar en favoritos ❤️
     ▼
[Mi Diario / Favoritos]
```

---

## Deuda Técnica (Priorizada)

1. **🔴 ALTA** — `main.dart` tiene 474 líneas con UI + lógica → Separar en archivos
2. **🔴 ALTA** — Sin gestión de estado formal → Migrar a Riverpod
3. **🟡 MEDIA** — Sin tests → Implementar suite completa
4. **🟡 MEDIA** — Sin manejo de errores centralizado → Agregar error tracking
5. **🟢 BAJA** — Sin i18n → Textos hardcoded en español
6. **🟢 BAJA** — Sin CI/CD → Implementar pipeline

---

## Features Pendientes (Especificación)

- [ ] Widget de Home Screen nativo (iOS/Android) con `home_widget`
- [ ] Tarrito de emociones visual con `CustomPaint`
- [ ] Autenticación biométrica para el diario (`local_auth`)
- [ ] Deep Links para abrir la app desde el widget
- [ ] Trabajo en background con `workmanager`
- [ ] Migrar storage a `sqflite` o `hive`
