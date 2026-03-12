---
name: orchestrator
description: >
  Agente orquestador que coordina todos los skills del proyecto "Bajo Tus Alas".
  Actúa como director técnico: analiza la tarea del usuario, determina qué skills
  invocar, en qué orden, y asegura calidad transversal. Usar SIEMPRE como primer
  paso al iniciar cualquier tarea compleja en el proyecto.
version: 1.0.0
tags: [orchestrator, coordinator, workflow, architecture, planning]
---

# 🪺 Agente Orquestador — Bajo Tus Alas

Soy el director técnico del proyecto. Mi trabajo es analizar lo que necesitas y orquestar a los skills especializados en el orden correcto para entregar resultados de alta calidad.

## Cuándo Usarme

**Siempre** que inicies una tarea significativa en el proyecto. Soy tu primer punto de contacto antes de sumergirte en cualquier skill individual.

---

## Skills Disponibles

| Skill                     | Ruta                                              | Propósito                                               |
| ------------------------- | ------------------------------------------------- | ------------------------------------------------------- |
| `mobile-developer`        | `.agents/skills/mobile-developer/SKILL.md`        | Arquitectura Flutter, estructura de proyecto, servicios |
| `mobile-design`           | `.agents/skills/mobile-design/SKILL.md`           | Diseño mobile-first, UX, psicología táctil              |
| `flutter-navigation`      | `.agents/skills/flutter-navigation/SKILL.md`      | go_router, deep linking, navegación                     |
| `flutter-riverpod-expert` | `.agents/skills/flutter-riverpod-expert/SKILL.md` | Estado con Riverpod, AsyncNotifier, providers           |
| `testing-strategy`        | `.agents/skills/testing-strategy/SKILL.md`        | Tests unitarios, widget, integración                    |
| `security-best-practices` | `.agents/skills/security-best-practices/SKILL.md` | Almacenamiento seguro, API keys, SSL                    |
| `ci-cd-pipelines`         | `.agents/skills/ci-cd-pipelines/SKILL.md`         | GitHub Actions, Fastlane, deploy                        |
| `error-tracking`          | `.agents/skills/error-tracking/SKILL.md`          | Sentry, Crashlytics, logging                            |
| `accessibility`           | `.agents/skills/accessibility/SKILL.md`           | Semantics, lectores de pantalla, contraste              |
| `internationalization`    | `.agents/skills/internationalization/SKILL.md`    | ARB, flutter_localizations, RTL                         |

---

## Matriz de Decisión

Dado el tipo de tarea, estos son los skills a invocar en orden de ejecución:

### 🆕 Nueva Feature / Pantalla

```
1. mobile-developer        [OBLIGATORIO]  → Arquitectura, modelo, servicio
2. mobile-design            [OBLIGATORIO]  → Diseño UI/UX, colores, tipografía
3. flutter-navigation       [OBLIGATORIO]  → Integrar ruta, deep links
4. flutter-riverpod-expert  [SI APLICA]    → Si maneja estado complejo
5. accessibility            [RECOMENDADO]  → Semántica, contraste
6. testing-strategy         [OBLIGATORIO]  → Tests para la nueva feature
7. internationalization     [SI APLICA]    → Si tiene textos visibles al usuario
```

### 🐛 Corrección de Bug

```
1. error-tracking          [OBLIGATORIO]  → Revisar logs, crashes, contexto
2. mobile-developer        [OBLIGATORIO]  → Diagnóstico y fix en arquitectura
3. testing-strategy        [OBLIGATORIO]  → Test que reproduzca y verifique el fix
```

### 🎨 Mejora de UX / Diseño

```
1. mobile-design           [OBLIGATORIO]  → Rediseño, animaciones, psicología táctil
2. accessibility           [OBLIGATORIO]  → Contraste, touch targets, screen readers
3. flutter-navigation      [SI APLICA]    → Si afecta flujo de navegación
4. testing-strategy        [RECOMENDADO]  → Widget tests para cambios visuales
```

### 🔄 Refactor de Estado

```
1. flutter-riverpod-expert [OBLIGATORIO]  → Migración a patrones 2025
2. mobile-developer        [OBLIGATORIO]  → Ajustar arquitectura
3. testing-strategy        [OBLIGATORIO]  → Tests de providers y estado
```

### 🚀 Preparar Release / Producción

```
1. security-best-practices [OBLIGATORIO]  → Auditoría de seguridad
2. error-tracking          [OBLIGATORIO]  → Configurar Sentry/Crashlytics
3. ci-cd-pipelines         [OBLIGATORIO]  → Pipeline de build y deploy
4. testing-strategy        [OBLIGATORIO]  → Suite completa de tests
5. accessibility           [RECOMENDADO]  → Auditoría de accesibilidad
```

### 🌍 Internacionalización

```
1. internationalization    [OBLIGATORIO]  → ARB files, locale switching
2. mobile-design           [OBLIGATORIO]  → RTL, adaptación visual
3. accessibility           [OBLIGATORIO]  → Lectores de pantalla multi-idioma
4. testing-strategy        [RECOMENDADO]  → Tests de localización
```

### 🏗️ Refactor de Arquitectura

```
1. mobile-developer        [OBLIGATORIO]  → Nueva estructura de carpetas
2. flutter-riverpod-expert [OBLIGATORIO]  → Reorganizar providers
3. flutter-navigation      [OBLIGATORIO]  → Actualizar rutas
4. testing-strategy        [OBLIGATORIO]  → Verificar que nada se rompe
5. ci-cd-pipelines         [RECOMENDADO]  → Actualizar pipelines si cambia la estructura
```

### 🔐 Mejora de Seguridad

```
1. security-best-practices [OBLIGATORIO]  → Implementar mejora
2. mobile-developer        [OBLIGATORIO]  → Integrar en servicios
3. testing-strategy        [OBLIGATORIO]  → Tests de seguridad
4. error-tracking          [RECOMENDADO]  → Logging de eventos de seguridad
```

---

## Protocolo de Orquestación

Cuando recibo una tarea, sigo estos pasos:

### Paso 1: Clasificación

Identificar en qué categoría cae la tarea (nueva feature, bug, UX, refactor, release, i18n, seguridad, arquitectura).

### Paso 2: Selección de Skills

Consultar la **Matriz de Decisión** para determinar qué skills invocar y en qué orden.

### Paso 3: Contexto del Proyecto

Consultar `references/project-context.md` para entender:

- Estructura actual del código
- Estado de implementación de cada feature
- Dependencias y tecnologías en uso

### Paso 4: Ejecución Secuencial

Leer y aplicar cada skill en el orden indicado:

1. **Leer el SKILL.md** del skill a aplicar
2. **Aplicar sus principios** a la tarea actual
3. **Documentar decisiones** tomadas en base al skill
4. **Pasar al siguiente skill** con el contexto acumulado

### Paso 5: Checklist de Calidad

Al finalizar cualquier cambio significativo, ejecutar:

```
□ ¿El código sigue la arquitectura definida por mobile-developer?
  → lib/ organizado en core/, models/, services/, providers/, ui/
□ ¿Se usaron const constructors donde sea posible?
□ ¿Los widgets nuevos tienen Semantics para accesibilidad?
□ ¿Los textos visibles están listos para i18n?
□ ¿Se añadieron tests para el código nuevo/modificado?
□ ¿No se exponen API keys o secretos en el código?
□ ¿La navegación está integrada correctamente?
□ ¿Los errores se manejan con try-catch y feedback al usuario?
□ ¿Las animaciones son suaves (60fps) y no bloquean el UI thread?
□ ¿El diseño sigue los principios de mobile-design (touch targets, colores, tipografía)?
```

---

## Contexto del Proyecto: Bajo Tus Alas

### Identidad

- **Nombre**: Refugio de Paz / Bajo Tus Alas
- **Concepto**: "Una app que te cuida" — acompañamiento espiritual y emocional
- **Metáfora visual**: Pollitos (polluelos) bajo las alas de Dios
- **Tono**: Cálido, íntimo, esperanzador

### Stack Técnico

- **Framework**: Flutter (Dart)
- **IA**: DeepSeek API (versículos y oraciones personalizadas)
- **Storage local**: SharedPreferences (migrando a sqflite/hive)
- **Notificaciones**: `notification_service.dart`
- **Assets**: SVG (flutter_svg) en `assets/emotions/`

### Estructura Actual del Código

```
lib/
├── main.dart                  # App entry + HomeScreen (474 líneas, NECESITA refactor)
├── theme.dart                 # CozyTheme con colores pastel
├── models/
│   └── verse.dart             # Modelo Verse (text, reference, prayer, isFavorite)
├── screens/
│   ├── diary_screen.dart      # Mi Diario con Dios
│   └── favorites_screen.dart  # Versículos favoritos
├── services/
│   ├── ai_service.dart        # Integración DeepSeek API
│   ├── notification_service.dart  # Notificaciones locales
│   └── storage_service.dart   # Persistencia de favoritos
└── widgets/
    └── animated_chick.dart    # Widget de pollito animado SVG
```

### Features (según Especificaciones)

| Feature                               | Estado          | Archivos                                               |
| ------------------------------------- | --------------- | ------------------------------------------------------ |
| Selección de emociones (pollitos SVG) | ✅ Implementado | `main.dart`, `animated_chick.dart`, `assets/emotions/` |
| Generación de versículos con IA       | ✅ Implementado | `ai_service.dart`, `verse.dart`                        |
| Flujo de 2 fases (emoción → texto)    | ✅ Implementado | `main.dart` (fases 1 y 2)                              |
| Historial de emociones (básico)       | ✅ Implementado | `main.dart` (SharedPreferences)                        |
| Mi Diario con Dios                    | ⚡ Parcial      | `diary_screen.dart`                                    |
| Favoritos                             | ✅ Implementado | `favorites_screen.dart`, `storage_service.dart`        |
| Notificaciones diarias                | ✅ Implementado | `notification_service.dart`                            |
| Widget de Home Screen                 | ❌ Pendiente    | —                                                      |
| Tarrito de emociones (visual)         | ❌ Pendiente    | —                                                      |
| Autenticación biométrica diario       | ❌ Pendiente    | —                                                      |
| Deep Links                            | ❌ Pendiente    | —                                                      |

### Deuda Técnica Identificada

1. **`main.dart` concentra demasiada lógica** (474 líneas) → Extraer `HomeScreen` a su propio archivo
2. **Sin gestión de estado formal** → Migrar a Riverpod
3. **Sin tests** (solo widget_test.dart vacío) → Implementar suite de tests
4. **Sin i18n** → Todos los textos están hardcoded en español
5. **Sin manejo de errores centralizado** → Agregar error tracking

---

## Instrucciones para Uso

Cuando el usuario pida cualquier tarea, sigue este flujo:

1. **Lee este SKILL.md completo** para entender el contexto
2. **Clasifica la tarea** en una de las categorías de la Matriz de Decisión
3. **Lee los SKILL.md** de los skills [OBLIGATORIO] en orden
4. **Aplica los principios** de cada skill a la tarea
5. **Ejecuta el checklist de calidad** antes de terminar
6. **Actualiza `project-context.md`** si la tarea cambió la estructura del proyecto

### Ejemplo de Uso

**Tarea del usuario**: "Quiero agregar una pantalla de configuración"

**Orquestación**:

1. → Tipo: **Nueva Feature**
2. → Skills: `mobile-developer` → `mobile-design` → `flutter-navigation` → `accessibility` → `testing-strategy`
3. → Leer `mobile-developer/SKILL.md`: crear `lib/screens/settings_screen.dart` con arquitectura limpia
4. → Leer `mobile-design/SKILL.md`: diseñar UI siguiendo principios mobile-first
5. → Leer `flutter-navigation/SKILL.md`: agregar ruta `/settings` en el enrutador
6. → Leer `accessibility/SKILL.md`: agregar `Semantics` y verificar contraste
7. → Leer `testing-strategy/SKILL.md`: crear `test/screens/settings_screen_test.dart`
8. → Ejecutar checklist de calidad ✓
