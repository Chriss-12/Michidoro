# REQ-PRODUCTIVITY V20 — Silencio temporal de enfoque en Android

## Decisión de producto

Michi Focus incorporará un control de distracciones en Ajustes con un modo de
silencio temporal garantizado mediante una regla propia de No molestar. El
silencio selectivo por aplicación queda sujeto a una prueba nativa: Android no
ofrece a una aplicación normal una API pública que garantice silenciar paquetes
arbitrarios antes de que suenen.

La conducta está vinculada estrictamente al Pomodoro: el usuario configura una
vez el perfil y Michi Focus activa la protección solo cuando el contador de
enfoque está avanzando y la aplicación permanece en primer plano.

La aplicación no usará Accesibilidad, administración del dispositivo, VPN ni
automatización de pantallas del sistema para simular una capacidad inexistente.

## REQ-V20-001 — Sesión de silencio temporal

**Status: In Progress**

Implementación aprobada por el usuario el 2026-08-31. El primer corte cubre
la regla propia de No molestar, autorización, Ajustes y ciclo del Pomodoro.

### Objetivo

Activar automáticamente una sesión local de silencio solo mientras avanza cada
bloque de enfoque, sin modificar permanentemente el volumen ni las preferencias
personales de Android.

### Criterios de aceptación

- La función está desactivada por defecto y se presenta como `Silencio de
  enfoque` dentro de Ajustes.
- Ajustes ofrece el switch principal `Activar al iniciar un Pomodoro`; el perfil
  y la lista de aplicaciones se configuran una vez y se reutilizan.
- El menú de tres puntos de la pantalla Pomodoro ofrece el switch `Bloquear
  notificaciones en este Pomodoro` cuando existe un plan preparado o activo.
- El switch del menú hereda inicialmente el valor general de Ajustes, pero su
  cambio afecta únicamente al plan actual y no modifica la preferencia global.
- Activarlo durante un bloque de enfoque en marcha aplica la protección de
  inmediato; desactivarlo retira inmediatamente solo la regla propia activa.
- Durante un descanso, el switch configura el siguiente bloque de enfoque sin
  activar silencio en el descanso actual.
- Al completar, descartar o cambiar el plan se elimina la modificación temporal;
  el siguiente Pomodoro vuelve a heredar la configuración general.
- Si se intenta activar desde el menú sin autorización, se muestra la
  explicación y `Autorizar en Android`; cancelar deja el switch apagado y no
  interrumpe el temporizador.
- La protección comienza únicamente cuando el contador de enfoque empieza a
  avanzar, no al abrir la tarea ni al preparar el plan.
- Al iniciar un descanso se desactiva; al comenzar el siguiente bloque de
  enfoque se vuelve a activar.
- Finalizar, descartar, completar o cambiar la tarea termina inmediatamente la
  protección perteneciente a ese Pomodoro.
- Pausar el contador siempre restaura las notificaciones; reanudar vuelve a
  aplicar la protección si el plan actual la tiene habilitada.
- Mandar Michi Focus a segundo plano o salir de la aplicación retira
  inmediatamente su regla. Al volver, solo se reactiva si el contador de
  enfoque continúa avanzando.
- Máxima concentración reutiliza esta misma configuración y no crea otra sesión
  de silencio paralela.
- Si Android rechaza o revoca el acceso, el Pomodoro continúa normalmente y la
  aplicación muestra una advertencia sin afirmar que el bloqueo está activo.
- Los perfiles mínimos son `Solo alarmas` y `Sin interrupciones`; llamadas o
  mensajes prioritarios solo se ofrecen cuando la política pública de Android
  pueda representarlos con precisión.
- La regla de Michi Focus nunca desactiva ni sobrescribe un modo No molestar que
  pertenezca al usuario o a otra aplicación.
- Finalizar, cancelar, caducar, reiniciar el teléfono o revocar el acceso deja
  la regla propia en un estado seguro y coherente.
- La sesión activa y su configuración son locales al celular y no se
  sincronizan mediante Syncthing.

## REQ-V20-002 — Selección de aplicaciones

**Status: Proposed**

Permanece condicionado a la prueba física Realme/Poco; no se implementará una
promesa de silencio selectivo antes de disponer de esa evidencia.

### Objetivo

Configurar una sola vez una selección buscable de una o varias aplicaciones que
se reutilice en cada Pomodoro, incluyendo acciones para seleccionar todas o
quitar toda la selección.

### Criterios de aceptación

- La lista muestra icono, nombre y paquete únicamente cuando este último sea
  necesario para resolver nombres duplicados.
- Admite búsqueda, selección individual, selección múltiple, `Seleccionar
  todas` y `Quitar selección`.
- La pantalla muestra el resumen `N aplicaciones seleccionadas` y no obliga a
  elegir nuevamente antes de cada Pomodoro.
- Michi Focus y componentes críticos del sistema no se incluyen en acciones
  masivas peligrosas.
- La selección se guarda únicamente en el dispositivo porque las aplicaciones
  instaladas pueden variar entre celulares.
- La primera versión evita `QUERY_ALL_PACKAGES`; usa el conjunto mínimo de
  aplicaciones visibles por intención de launcher y, si se aprueba el acceso a
  notificaciones, los paquetes observados legítimamente por ese servicio.
- La interfaz no afirma que una aplicación fue silenciada si el sistema solo
  permite ocultar su notificación después de publicada.
- Cada aplicación ofrece `Abrir ajustes de notificaciones`, que intenta abrir
  directamente su pantalla del sistema y usa una explicación alternativa si el
  fabricante no admite ese destino.

### Puerta de viabilidad obligatoria

- Un prototipo nativo debe comprobar en Realme y Poco si una notificación de una
  aplicación seleccionada puede evitar sonido, vibración y aviso emergente
  antes de mostrarse, con pantalla encendida y apagada.
- Si alguna interrupción ocurre antes de la supresión, la función se llamará
  `Ocultar notificaciones seleccionadas`, no `Silenciar aplicaciones`, y se
  ofrecerá como complemento opcional del silencio global.
- Si el prototipo no es consistente entre ambos celulares, el producto conserva
  la selección como guía para abrir los ajustes individuales, sin prometer una
  duración automática que Android no pueda restaurar.

## REQ-V20-003 — Autorizaciones y orientación del sistema

**Status: In Progress**

### Objetivo

Guiar al usuario exactamente a las pantallas de Android que debe autorizar y
reflejar el estado real al regresar a Michi Focus.

### Criterios de aceptación

- Para No molestar, el botón abre
  `Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS` y vuelve a consultar
  `NotificationManager.isNotificationPolicyAccessGranted()` al reanudar.
- El primer switch sin autorización muestra una explicación breve y el botón
  `Autorizar en Android`; una autorización vigente se reutiliza en los
  Pomodoros posteriores hasta que el usuario la revoque.
- La implementación usa una `AutomaticZenRule` propiedad de Michi Focus en
  Android 24 o posterior; Android 23 requiere una ruta compatible separada y
  pruebas que preserven la política previa.
- El acceso a notificaciones es opcional y solo se solicita si se aprueba el
  modo selectivo; en Android 30 o posterior se intenta abrir el detalle del
  listener y en versiones anteriores la lista general de listeners.
- Ajustes conserva acciones separadas `Administrar aplicaciones`, `Abrir ajustes
  de Android` y, dentro de cada aplicación, `Abrir ajustes de notificaciones`.
- El acceso denegado, revocado, no disponible o restringido por perfil
  administrado se explica sin bloquear tareas, rutinas, notas ni Pomodoro.
- Los estados visibles son `No configurado`, `Autorización necesaria`,
  `Disponible`, `Activo`, `Finalizando` y `No compatible`.
- El switch del menú de Pomodoro refleja el estado efectivo después de regresar
  de Ajustes de Android, no el valor solicitado antes de conceder el acceso.
- Nunca se solicita al usuario una contraseña, PIN o patrón dentro de Michi
  Focus; Android conserva el control de sus pantallas protegidas.

## REQ-V20-004 — Recuperación, seguridad y verificación integral

**Status: In Progress**

### Objetivo

Garantizar que una sesión temporal no quede activa indefinidamente ni altere
silenciosamente el comportamiento del teléfono.

### Criterios de aceptación

- El final programado sobrevive a proceso cerrado, reinicio, cambio de hora y
  cambio de zona horaria mediante el mecanismo nativo mínimo aprobado.
- Las transiciones enfoque → pausa → reanudación → descanso → siguiente enfoque
  y primer plano → segundo plano → primer plano restauran o vuelven a aplicar
  únicamente la regla propiedad de Michi Focus.
- Una notificación persistente mientras la sesión está activa muestra tiempo
  restante y una acción `Terminar silencio`, cuando Android lo permita.
- La aplicación registra solo estado técnico local: perfil, inicio, fin, regla
  propia y paquetes elegidos; nunca contenido de notificaciones.
- Desinstalar, restablecer la app o retirar autorización no deja una regla
  activa sin una ruta de recuperación explicada.
- Los avisos de fin de Pomodoro de Michi Focus se prueban bajo ambos perfiles;
  cualquier excepción requerida se configura explícitamente y se explica.
- Pruebas automatizadas cubren selección, duración, permisos, caducidad,
  recuperación, revocación, todas las salidas del Pomodoro y exclusión de datos
  sincronizados.
- Pruebas de presentación cubren el switch del menú de tres puntos, herencia de
  Ajustes, modificación por plan, cambio inmediato durante enfoque y limpieza
  al terminar.
- La verificación física cubre Realme y Poco, Android en primer plano y segundo
  plano, proceso cerrado, reinicio y permisos concedidos/denegados.
- El requisito solo puede pasar a `Verified` después de demostrar que ninguna
  sesión queda activa más allá de su fin y que el texto distingue silencio
  garantizado de ocultación posterior.

## Fuera de alcance

- Bloquear el inicio o uso de otras aplicaciones.
- Cambiar automáticamente el volumen multimedia, llamadas o alarmas.
- Transferir una sesión activa o una lista de paquetes entre celulares.
- Leer, almacenar o sincronizar el contenido de notificaciones de terceros.
- Usar APIs privadas, root, ADB, Accesibilidad o administración empresarial.

## Arquitectura prevista

- Flutter conserva el formulario, perfiles, selección y estado observable.
- Un puente Android pequeño consulta capacidades, abre Ajustes y controla solo
  la regla No molestar propiedad de Michi Focus.
- Un controlador con Signals deriva disponibilidad, sesión activa, tiempo
  restante y advertencias, y recibe transiciones explícitas del controlador de
  Pomodoro; los widgets no contienen reglas del sistema.
- La persistencia es una preferencia local independiente de SQLite productivo,
  backup de productividad y sincronización V11.
- La expiración nativa debe reutilizar infraestructura existente cuando sea
  segura; cualquier permiso o cambio de manifiesto requiere aprobación durante
  la implementación.

## Referencias oficiales verificadas el 2026-08-31

- Android `NotificationManager` y acceso a Notification Policy:
  https://developer.android.com/reference/android/app/NotificationManager
- Android `AutomaticZenRule`:
  https://developer.android.com/reference/android/app/AutomaticZenRule
- Android `Settings` para No molestar, listener y ajustes por aplicación:
  https://developer.android.com/reference/android/provider/Settings
- Android `NotificationListenerService`:
  https://developer.android.com/reference/android/service/notification/NotificationListenerService
- Visibilidad limitada de paquetes:
  https://developer.android.com/training/package-visibility/declaring
