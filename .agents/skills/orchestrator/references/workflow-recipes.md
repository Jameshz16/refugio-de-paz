# Recetas de Flujo de Trabajo

Recetas paso a paso para los flujos de trabajo más comunes en el proyecto **Bajo Tus Alas**.

---

## 🆕 Receta: Agregar una Nueva Pantalla

**Skills involucrados**: `mobile-developer` → `mobile-design` → `flutter-navigation` → `testing-strategy`

### Pasos

1. **Crear el modelo** (si se necesita uno nuevo)

   ```
   lib/models/nuevo_modelo.dart
   ```

   - Definir propiedades con tipos fuertes
   - Implementar `fromJson()` / `toJson()` si interactúa con API

2. **Crear el servicio** (si se conecta a backend/storage)

   ```
   lib/services/nuevo_service.dart
   ```

   - Separar la lógica de datos del UI
   - Manejar errores con try-catch

3. **Crear la pantalla**

   ```
   lib/screens/nueva_screen.dart
   ```

   - Usar `StatelessWidget` si no maneja estado local
   - Seguir patrón de diseño de `mobile-design`:
     - Touch targets ≥ 48dp
     - Colores del `CozyTheme`
     - Tipografía de `google_fonts`
   - Agregar `Semantics` en widgets interactivos

4. **Agregar navegación**
   - Agregar ruta en el sistema de navegación
   - Conectar desde la pantalla origen con `Navigator.push()` o `context.go()`

5. **Crear tests**
   ```
   test/screens/nueva_screen_test.dart
   ```

   - Widget test básico: renderiza correctamente
   - Test de interacción: tap en botones funciona
   - Test de estado: datos se muestran correctamente

---

## 🐛 Receta: Investigar y Corregir un Bug

**Skills involucrados**: `error-tracking` → `mobile-developer` → `testing-strategy`

### Pasos

1. **Revisar logs y contexto**
   - Consultar consola de Flutter para stack traces
   - Identificar el archivo y línea del error
   - Verificar si es reproducible consistentemente

2. **Aislar el problema**
   - Identificar si es UI, lógica de negocio, o servicio externo
   - Crear un test que reproduzca el bug (test-first)

3. **Aplicar el fix**
   - Modificar el código mínimo necesario
   - Verificar que no introduce regresiones

4. **Verificar**
   - Correr el test que reproduce el bug → debe pasar
   - Correr suite completa de tests → nada roto
   - Probar manualmente en emulador

---

## 🎨 Receta: Mejorar el Diseño de una Pantalla

**Skills involucrados**: `mobile-design` → `accessibility` → `testing-strategy`

### Pasos

1. **Auditoría visual**
   - Revisar colores, tipografía, espaciado
   - Verificar que se usan tokens del `CozyTheme`
   - Evaluar uso de animaciones y transiciones

2. **Auditoría de accesibilidad**
   - Verificar `Semantics` en todos los elementos interactivos
   - Comprobar ratio de contraste ≥ 4.5:1
   - Touch targets ≥ 48x48dp

3. **Implementar mejoras**
   - Aplicar cambios de diseño
   - Agregar micro-animaciones con `flutter_animate` o `AnimatedContainer`
   - Usar `HapticFeedback` en interacciones importantes

4. **Verificar**
   - Probar en múltiples tamaños de pantalla
   - Verificar con el inspector de accesibilidad de Flutter

---

## 🔄 Receta: Migrar Estado a Riverpod

**Skills involucrados**: `flutter-riverpod-expert` → `mobile-developer` → `testing-strategy`

### Pasos

1. **Identificar estado a migrar**
   - Buscar `setState()` en el código
   - Buscar variables de estado local (`_isLoading`, `_selectedX`, etc.)
   - Buscar lógica de negocio mezclada con UI

2. **Crear providers**

   ```
   lib/providers/nombre_provider.dart
   ```

   - Usar `@riverpod` con code generation
   - `AsyncNotifierProvider` para datos async
   - `NotifierProvider` para estado sync

3. **Migrar UI**
   - Cambiar `StatefulWidget` → `ConsumerWidget`
   - Reemplazar `setState()` → `ref.watch()` / `ref.read()`
   - Usar `.when()` para estados async

4. **Crear tests**
   - Test de provider con `ProviderContainer.test()`
   - Mock de dependencias con overrides

---

## 🚀 Receta: Preparar para Producción

**Skills involucrados**: `security-best-practices` → `error-tracking` → `ci-cd-pipelines` → `testing-strategy`

### Pasos

1. **Auditoría de seguridad**
   - Verificar que API keys NO están en el código fuente
   - Migrar secretos a `flutter_dotenv` o `--dart-define`
   - Verificar que no se loguean datos sensibles

2. **Configurar error tracking**
   - Integrar Sentry o Firebase Crashlytics
   - Agregar boundary de errores global
   - Configurar source maps para stack traces legibles

3. **Configurar CI/CD**
   - GitHub Actions para tests automáticos en PR
   - Build de APK/IPA en merge a main
   - Opcional: deploy a Google Play / App Store con Fastlane

4. **Suite de tests completa**
   - Cobertura mínima del 70%
   - Tests de integración para flujos críticos
   - Tests de widget para todas las pantallas

---

## Plantilla de Checklist Rápido

Copiar y personalizar para cualquier tarea:

```markdown
## Checklist — [Descripción de la tarea]

### Antes de comenzar

- [ ] Leí el SKILL.md del orquestador
- [ ] Identifiqué el tipo de tarea
- [ ] Sé qué skills necesito

### Durante la implementación

- [ ] Seguí la arquitectura de `mobile-developer`
- [ ] Apliqué los principios de `mobile-design`
- [ ] Los widgets tienen `Semantics`
- [ ] Los errores se manejan correctamente

### Antes de terminar

- [ ] Agregué tests
- [ ] No hay secretos en el código
- [ ] La navegación funciona
- [ ] Probé en emulador
```
