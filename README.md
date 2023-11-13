# Proyecto take-home Encuadrado


## Tabla de Contenidos

- [Objetivo](#objetivo)
- [Requisitos Previos](#requisitos-previos)
- [Setup](#setup)
  - [Clonar el Repositorio](#clonar-el-repositorio)
  - [Instalar Dependencias](#instalar-dependencias)
  - [Ejecutar la Aplicación](#ejecutar-la-aplicación)
  - [Probar en Android](#probar-en-android)
  - [Probar en iOS](#probar-en-ios)
  - [Build](#build)
- [Funcionamiento](#funcionamiento)
- [Comentarios](#comentarios)



## Objetivo

La plataforma Encuadrado resuelve tres principales problemas : agendamiento, cobros y boletas. Esta prueba se enfoca en la solución (bastante) simplificada del primero de estos problemas: el agendamiento, que consta de dos partes: la visa del profesional y la vista del cliente. \
Para realizar esta prueba se desarrolló una aplicación mobile utilizando Flutter.


## Requisitos Previos

Antes que todo, se deben tener instaldos 

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)

## Setup
Para probar el proyecto, se deben seguir los siguiente pasos:
### Clonar el Repositorio

```bash
git clone https://github.com/vowagner/encuadrado_take_home
cd encuadrado_take_home
```


### Instalar Dependencias

```bash
flutter pub get
```

### Ejecutar la Aplicación

```bash
flutter run
```
Se debe tener un emulador de Android/iOS en ejecución o un dispositivo físico conectado. A continuación se ahonda en el tema.

### Probar en Android

- Se recomienda el uso de [Android Studio](https://developer.android.com/studio?hl=es-419) Con este, se puede crear un nuevo emulador de Android desde el AVD Manager y al momento de correr flutter run, debería ejecutar la aplicación en el emulador.
- Si se desea probar en un dispositivo físico Android, hay que activar la depuración USB y conectarlo al computador con cable USB.

### Probar en iOS

- Para un emulador de iOS, se necesita tener [Xcode](https://developer.apple.com/xcode/resources/) instalado en el sistema (exclusivo para macOS). Desde Xcode, se puede abrir el simulador de iOS y ejecutar un dispositivo virtual.
- Para probar con dispositivo físico iOS, es necesario activar la depuración y conectarlo al MAC con Xcode instalado.

### Build

- Si se desea, se puede crear el archivo de instalación (APK o IPA) para transferir e instalar a dispositivos físicos. Para generar el archivo se corre:

```bash
flutter build apk  # Para Android
flutter build ios  # Para iOS
```

## Funcionamiento


Una vez iniciada la aplicación, se observa una pantalla de inicio con el logo de Encuadrado y dos botones, correspondientes a las dos vistas disponibles.

### Vista Profesional

- Al presionar el botón de modo profesional, pasamos a la pantalla de inicio de sesión. Solo existe una cuenta de usuario y contraseña válidos para iniciar, estos datos están estipulados en el manual de este proyecto.

```bash
user: encuadrado
pass: enc123**456&789
```

- El usuario está guardado como texto plano en la app, mientras que para la contraseña se guardó el hash SHA256.
- Si ingresamos correctamente, veremos la vista profesional. Aquí tenemos un calendario con todas las citas ingresadas en el calendario, en vista semanal. Se puede deslizar a la izquierda o derecha para ver otras fechas. Esto fue implementado con *syncfusion_flutter_calendar*.
- Arriba a la derecha, tenemos un botón para acceder a la configuración. En esta vista, podemos cambiar cada uno de los valores correspondientes al profesional y la config de las citas:
Días a la semana que se atiende, Nombre del servicio, hora mínima, hora máxima, duración mínima, dirección máxima y costo por hora.
- Toda esta información se guarda en el state utilizando *Provider* como gestor de estado, además, para lograr la persistencia de datos entre sesiones, usamos *shared_preferences*. Combinando ambas, se logra un buen manejo de datos, incluso si la aplicación se cierra y abre denuevo.

### Vista Paciente

- Al presionar el botón de modo paciente, pasamos a una vista de calendario. En esta vista, se pueden ver todos los horarios ocupados del profesional, para así poder elegir una hora disponible. También se muestran en el calendario los feriados nacionales (para esto se utilizó *http* y la api [Feriados API](https://www.feriadosapp.com/api/))

- En el calendario visto, solo veremos los días en el que el profesional trabaja. Por ejemplo, si en la vista profesional cambiamos los días disponibles a Lunes-Miercoles-Viernes, en la vista paciente solo veremos estos días. Además, solo se muestra el rango de horario en el que el profesional trabaja.
- Arriba a la derecha, tenemos un botón para reservar una hora. Al presionarlo, se abre una pestaña que muestra la información del servicio a reservar y permite seleccionar el día de la sesión, la hora de inicio y la hora final. Si se cumplen todas las restricciones, al presionar "Agendar Cita" se guardará la cita y se podrá ver en el calendario de Paciente y de Profesional. Además, si cerramos la app y abrimos denuevo, se recuperará esa información.
- Si la cita no es válida, aparecerá un mensaje con el la indicación del error.

## Comentarios

- En primer lugar lo obvio: debido a que el tiempo es limitado, me enfoqué completamente en desarrollar las funcionalidades pedidas y dejé el diseño de la app un poco de lado.

- Ya que no cuento con un dispositivo iOS y las restricciones que impone Apple al testeo fuera de su ecosistema, no pude probar la app para iOS. Debería funcionar todo correcto, pero agradecería considerar testearla en Android al momento de la revisión.

- La app fue testeada tanto en un emulador de Android Studio, así como también instalada en mi teléfono. Todo funciona correctamente.
