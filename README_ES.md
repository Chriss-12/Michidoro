# 🍅 MichiDoro

[English](README.md) | [Español](README_ES.md)

MichiDoro es una aplicación Pomodoro de código abierto desarrollada con Flutter y Dart para mejorar la productividad, organizar el estudio y planificar el trabajo personal. Funciona principalmente sin conexión y mantiene los datos de productividad almacenados localmente en el dispositivo.

> Proyecto en preparación para su publicación en F-Droid.

## ✨ Características principales

- Temporizador Pomodoro para organizar períodos de concentración.
- Sesiones de trabajo y descanso.
- Gestión de tareas personales.
- Gestión de metas.
- Historial de sesiones realizadas.
- Estadísticas y reportes de productividad.
- Funcionamiento principalmente offline.
- Almacenamiento local de los datos de productividad.

## 🛠️ Tecnologías utilizadas

| Tecnología | Uso en el proyecto |
| --- | --- |
| Flutter y Dart | Desarrollo multiplataforma de la aplicación |
| Material Design 3 | Componentes y sistema visual |
| Clean Architecture | Separación de responsabilidades y dependencias |
| Feature First | Organización del código por funcionalidades |
| `go_router` | Navegación declarativa |
| `get_it` | Inyección de dependencias |
| `signals_flutter` | Gestión reactiva del estado |
| Drift / SQLite | Persistencia local de datos |
| `flex_color_scheme` | Gestión de temas y colores |
| `flutter_animate` | Animaciones de interfaz |
| `responsive_framework` | Adaptación a diferentes tamaños de pantalla |
| `toastification` | Mensajes y avisos dentro de la aplicación |

## 🏗️ Arquitectura del proyecto

MichiDoro utiliza **Clean Architecture** junto con una estructura **Feature First**. Cada funcionalidad agrupa sus propias capas y componentes, mientras que las dependencias apuntan hacia el núcleo de la aplicación.

```text
lib/
├── app/             # Configuración general, rutas, temas e inyección
├── features/        # Funcionalidades organizadas por dominio
│   └── feature/
│       ├── data/          # Fuentes de datos e implementaciones
│       ├── domain/        # Entidades, contratos y lógica de negocio
│       └── presentation/  # Páginas, widgets y controladores
├── l10n/            # Recursos de localización
└── shared/          # Componentes reutilizables
```

Esta organización facilita las pruebas, el mantenimiento y la incorporación de nuevas funcionalidades sin acoplar la interfaz con la persistencia.

## 📋 Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- [Git](https://git-scm.com/).
- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible con Flutter 3.32 o superior.
- Dart 3.8 o superior, incluido con Flutter.
- Un dispositivo o emulador compatible configurado para Flutter.

Puedes comprobar la configuración del entorno con:

```bash
flutter doctor
```

## 🚀 Instalación y ejecución

Clona el repositorio, instala las dependencias y ejecuta la aplicación:

```bash
git clone https://github.com/Chriss-12/michidoro.git
cd michidoro
flutter pub get
flutter run
```

Para consultar los dispositivos disponibles:

```bash
flutter devices
```

## 🔒 Privacidad

MichiDoro está diseñada para funcionar principalmente offline. Las tareas, metas, sesiones y estadísticas de productividad se almacenan localmente en el dispositivo mediante Drift y SQLite.

La aplicación no requiere un servicio remoto para sus funciones principales. Antes de distribuir una compilación, se recomienda revisar los permisos y los metadatos de privacidad exigidos por F-Droid.

## 📱 Capturas de pantalla

<table>
  <tr>
    <td align="center"><img src="docs/screenshots/001-image.png" width="240" alt="Captura 001 de MichiDoro"><br><sub>001-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/002-image.png" width="240" alt="Captura 002 de MichiDoro"><br><sub>002-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/003-image.png" width="240" alt="Captura 003 de MichiDoro"><br><sub>003-image.png</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/004-image.png" width="240" alt="Captura 004 de MichiDoro"><br><sub>004-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/005-image.png" width="240" alt="Captura 005 de MichiDoro"><br><sub>005-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/006-image.png.png" width="240" alt="Captura 006 de MichiDoro"><br><sub>006-image.png.png</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/007-image.png" width="240" alt="Captura 007 de MichiDoro"><br><sub>007-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/008-image.png" width="240" alt="Captura 008 de MichiDoro"><br><sub>008-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/009-image.png" width="240" alt="Captura 009 de MichiDoro"><br><sub>009-image.png</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/010-image.png" width="240" alt="Captura 010 de MichiDoro"><br><sub>010-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/011-image.png" width="240" alt="Captura 011 de MichiDoro"><br><sub>011-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/012-image.png" width="240" alt="Captura 012 de MichiDoro"><br><sub>012-image.png</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/013-image.png" width="240" alt="Captura 013 de MichiDoro"><br><sub>013-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/014-image.png" width="240" alt="Captura 014 de MichiDoro"><br><sub>014-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/015-image.png" width="240" alt="Captura 015 de MichiDoro"><br><sub>015-image.png</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/016-image.png" width="240" alt="Captura 016 de MichiDoro"><br><sub>016-image.png</sub></td>
    <td align="center"><img src="docs/screenshots/017-image.png" width="240" alt="Captura 017 de MichiDoro"><br><sub>017-image.png</sub></td>
    <td></td>
  </tr>
</table>

## 🤝 Cómo contribuir

Las contribuciones son bienvenidas. Para proponer un cambio:

1. Haz un fork del repositorio.
2. Crea una rama descriptiva para tu aporte.
3. Implementa el cambio siguiendo la arquitectura existente.
4. Ejecuta el análisis y las pruebas antes de enviar tu propuesta.
5. Abre un pull request explicando claramente el problema y la solución.

Comandos de verificación recomendados:

```bash
flutter analyze
flutter test
```

Antes de contribuir, revisa los issues abiertos y evita incluir datos personales, archivos generados o credenciales en los commits.

## 📄 Licencia

Este proyecto se distribuye bajo la **GNU General Public License v3.0**. Consulta el archivo [LICENSE](LICENSE) para conocer los términos completos.

## 👤 Autor

**Cristhian Alave**

GitHub: [@Chriss-12](https://github.com/Chriss-12)

---

Repositorio oficial: [github.com/Chriss-12/michidoro](https://github.com/Chriss-12/michidoro)
