# REQ-PRODUCTIVITY V21 — Protección de la base de datos y copias portátiles

## Decisión de producto

Michi Focus protegerá los datos en dos capas independientes. Las copias que
salen del espacio privado de Android usarán contraseña y cifrado autenticado.
La base de datos viva migrará después a un motor SQLite cifrado con una clave
aleatoria protegida por Android Keystore, únicamente cuando la migración con
retroceso haya sido probada contra bases reales existentes.

Existe una sola clave maestra de recuperación. La contraseña nunca se guarda y
la interfaz advierte que debe conservarse en un gestor de contraseñas. La huella,
PIN o patrón de Android autoriza la exportación y protege localmente la clave
aleatoria; la clave maestra solo se introduce para recuperar una copia en otro
dispositivo.

## REQ-V21-001 — Copia portátil cifrada

**Status: Implemented**

Implementación aprobada por el usuario el 2026-09-07.

### Criterios de aceptación

- La primera ejecución posterior a la instalación o actualización exige crear
  una única clave maestra de al menos 12 caracteres y confirmarla.
- La pantalla de alta advierte que debe guardarse en un gestor de contraseñas y
  que MichiDoro no puede mostrarla ni recuperarla si se olvida.
- La contraseña deriva con Argon2id una clave de envoltura; no cifra directamente
  cada base ni se guarda en archivos, preferencias o SQLite.
- Una clave aleatoria de 256 bits cifra las copias. Android Keystore conserva
  localmente una envoltura que solo puede abrirse tras huella, PIN o patrón.
- Exportar solicita únicamente la autenticación del dispositivo.
- Importar siempre pide la clave maestra, la mantiene solo en memoria durante la
  operación y registra la clave recuperada en el Keystore del nuevo dispositivo.
- Cada archivo público usa un nombre único `michifocus-backup-<fecha>.michi`,
  no sobrescribe copias anteriores y nunca contiene un
  encabezado SQLite ni texto de tareas, objetivos, rutinas o notas en claro.
- La clave maestra usa Argon2id con sal aleatoria para proteger la clave de datos.
- El contenido se cifra y autentica con AES-256-GCM, nonce aleatorio y datos
  asociados versionados.
- Una contraseña incorrecta, archivo alterado o formato futuro se rechaza antes
  de crear una importación pendiente o reemplazar la base viva.
- El SQLite temporal descifrado permanece dentro del almacenamiento privado de
  la aplicación, se valida integralmente y se elimina ante cualquier fallo.
- La restauración conserva el reemplazo atómico y la recuperación de la base
  anterior ya existentes.
- La interfaz normal deja de producir o aceptar `michifocus.sqlite` público sin
  cifrar. El lector antiguo permanece solo como compatibilidad interna mientras
  se define una migración explícita.

### Evidencia de implementación

- El análisis completo de `lib` y `test` está limpio.
- Las 517 pruebas pasan, incluidos cifrado/descifrado, recuperación de la clave
  de datos, contraseña incorrecta, ausencia de texto claro y regresión integral.
- El empaquetado Android queda pendiente: Gradle falla antes de compilar con
  `Unable to establish loopback connection` en el entorno de ejecución actual,
  incluso con JDK 17, 20 y 21.
- La exportación e importación física se mantienen como puerta para `Verified`.

## REQ-V21-002 — Base viva cifrada con clave del dispositivo

**Status: Approved**

### Criterios de aceptación

- La base viva usa un motor SQLite cifrado mantenido y compatible con Drift.
- Cada instalación genera una clave aleatoria de 256 bits; la contraseña humana
  no se usa directamente como clave diaria de SQLite.
- Android Keystore protege la clave y exige credencial segura del dispositivo.
- La aplicación no abre datos productivos antes de desbloquear la clave.
- La migración desde SQLite en claro crea una copia recuperable, valida todas
  las tablas e índices, conmuta de forma atómica y revierte ante fallos.
- Actualización, cierre inesperado, contraseña de backup incorrecta y pérdida de
  autenticación nunca destruyen la única copia válida.
- La implementación no se marcará terminada hasta probar actualización sobre
  datos existentes y una restauración real en Realme y Poco.

## Fuera de alcance

- Sincronizar la contraseña mediante Syncthing.
- Guardar la contraseña en preferencias, SQLite, logs o archivos externos.
- Usar automáticamente una contraseña almacenada en un gestor externo.
- Cifrar ajustes visuales que no contienen productividad.
