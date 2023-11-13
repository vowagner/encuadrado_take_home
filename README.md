# Proyecto take-home Encuadrado


## Tabla de Contenidos

- [Visión General](#visión-general)
- [Requisitos Previos](#requisitos-previos)
- [Setup](#setup)
  - [Clonar el Repositorio](#clonar-el-repositorio)
  - [Instalar Dependencias](#instalar-dependencias)
  - [Ejecutar la Aplicación](#ejecutar-la-aplicación)
  - [Probar en Android](#probar-en-android)
  - [Probar en iOS](#probar-en-ios)
  - [Build](#build)
- [Funcionamiento](#funcionamiento)



## Visión General

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


