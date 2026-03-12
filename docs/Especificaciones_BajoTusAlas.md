# Especificaciones Técnicas y Funcionales

## Proyecto: Bajo tus Alas

**Concepto de la App:** "Una app que te cuida". Una aplicación espiritual, emocional y de acompañamiento personal.
**Framework Core:** Flutter (Dart)
**Backend/IA:** DeepSeek API (Generación de versículos y oraciones)

---

## 1. Widget de Pantalla de Inicio (Versículo Diario)

**Requisito:** Un widget que permita leer un versículo inspirador o un mensaje de aliento directamente desde el _Home Screen_ del teléfono (Android/iOS) sin necesidad de abrir la aplicación.

**Ejecución Técnica:**

- **Librería a usar:** `home_widget` (permite la comunicación entre el código Dart de Flutter y los AppWidgets nativos de Android y WidgetExtensions de iOS).
- **Almacenamiento Local Compartido:** El versículo generado o programado del día se almacenará utilizando `SharedPreferences` (Android) y `UserDefaults` (iOS) a través de un _App Group_. El widget nativo leerá los datos desde este almacenamiento compartido de manera síncrona.
- **Proceso en Segundo Plano:** Se empleará `workmanager` para inicializar un trabajo en background (`Background Fetch`) cada 12/24 horas. Este trabajo hará una llamada silenciosa al modelo o extraerá un versículo local para refrescar la información que ven el widget.

---

## 2. "Tarrito de Emociones" (Registro e Historial de Estado de Ánimo)

**Requisito:** Un sistema visual (tarrito) en el cual el usuario pueda llevar un registro continuo de su estado de ánimo y emociones a lo largo del tiempo.

**Ejecución Técnica:**

- **Estructura de Datos:** Se creará un modelo `EmotionRecord` con propiedades: `id`, `fecha (DateTime)`, `tipo_emocion (String)`, `intensidad (int)` y `nota_opcional (String)`.
- **Almacenamiento Local:** Se migrará a o implementará `sqflite` (SQLite) o `hive` para persistencia continua de datos, creando la tabla/caja `historial_emociones`.
- **UI/UX y Animación:**
  - El "tarro" será construido utilizando el widget `CustomPaint` para dibujar la estructura, o bien un recurso de `Lottie` o `Rive` interactivo.
  - Al ingresar una emoción, una animación simulará un objeto (ej. una "gota", "semilla" o "canica") con el color de la emoción cayendo dentro del tarro utilizando física básica (`flutter_animate` o el motor de física nativo en Flutter).
  - Cada vez que el usuario entre, verá gráficamente (por volumen y colores) cómo se compone su estado emocional reciente.

---

## 3. Sección "Mi Diario con Dios"

**Requisito:** Renombrar y restructurar la actual sección de diario para que el enfoque sea un diálogo directo o cartas dirigidas a Dios.

**Ejecución Técnica:**

- **UI/UX (Modificación visual):**
  - La interfaz usará fuentes tipográficas inmersivas e inspiradoras (`google_fonts`, ej. _Caveat_ o _Dancing Script_) que simulen la escritura a mano en un entorno similar a un cuaderno íntimo.
  - La estructura de la vista de lectura (`diary_screen.dart`) cambiará de listas planas a interfaces tipo tarjetas encuadernadas o "cartas".
- **Gestión de Entradas:** El CRUD de este diario vinculará la emoción del día y el correspondiente versículo entregado por la Inteligencia Artificial (DeepSeek), almacenando todo como una unidad de lectura reflexiva (una "entrada sagrada").
- **Seguridad y Privacidad:** Al ser un elemento íntimo, se puede añadir soporte de autenticación biométrica (Huella/FaceID) utilizando el paquete `local_auth` al momento de abrir el diario.

---

## 4. Personajes Animados de Emociones

**Requisito:** Reemplazar los botones de texto simples de las emociones (Feliz, Triste, Ansioso, etc.) por representaciones visuales de pequeños personajes.

**Ejecución Técnica:**

- **Inclusión de Assets:** Se utilizarán archivos vectoriales (`.svg`) mediante `flutter_svg` o animaciones JSON mediante `lottie`. Cada estado de ánimo tendrá asociado su propio archivo visual en la carpeta `assets/emotions/`.
- **Interfaz de Selección:**
  - Se retirará el control basado en `ChoiceChip` o botones de la pantalla principal (en el archivo `main.dart`).
  - Se implementará un `GridView` interactivo o un Carrusel (`PageView`) con tarjetas de personajes.
  - **Experiencia Háptica y de Feedback:** Al seleccionar (hacer "Tap" usando `GestureDetector` o `InkWell`) en un personaje, este reproducirá una pequeña animación de "seleccionado" (escalado utilizando `AnimatedContainer` o `AvatarGlow`) y emitirá una respuesta de vibración ligera (`HapticFeedback.lightImpact()`).

## 5. Lógica de Flujo de Interacción UI/UX

**Requisito:**

1. El widget nativo actuará como un "gancho" interactivo, preguntándole al usuario: _¿Cómo te sientes hoy?_ para motivarlo a entrar a la aplicación, antes o en lugar de solo mostrar el versículo estático.
2. Al ingresar a la app, el flujo principal forzará un proceso en dos pasos: primero seleccionar la emoción (personaje) y solo después de esto, mostrar el área de redacción (_"¿Qué tienes para decirle a Dios hoy?"_).

**Ejecución Técnica:**

- **En el Widget Nativo (iOS/Android):** El layout definirá una vista inicial ("Estado 0") con el mensaje _¿Cómo te sientes hoy?_ y un botón o el área completa servirá como un `Deep Link` o `App Intent`. Al hacer tap, abrirá la app directamente en la pantalla principal.
- **En la Pantalla Principal (`main.dart`):**
  - Se usará un control de estado local (un bloque `if` o `Visibility`) o un widget `Stepper` / `PageView` (con `NeverScrollableScrollPhysics` para controlar la navegación programáticamente) para manejar las "fases" del proceso.
  - **Fase 1:** Se muestra únicamente la cuadrícula/carrusel de personajes de emociones. El formulario de texto está oculto.
  - **Transición:** Al hacer tap en un personaje, se guarda la variable `_selectedEmotion` y se dispara un `setState()` o `AnimationController`.
  - **Fase 2:** La vista se anima revelando el `TextField` con el HintText personalizado (_"¿Qué tienes para decirle a Dios hoy?"_).
  - Al completar el formulario y enviarlo a la IA, la pantalla generará el versículo devuelto por el modelo, junto a una frase de aliento o breve explicación de por qué ese versículo acompaña la emoción seleccionada.
