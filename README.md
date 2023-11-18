# flutter_meditation

A new Flutter project.

## Build project

To build GETIt service locator instances for dependency injection and model classes run:

`flutter pub run build_runner build`

To clean generated files:

`flutter packages pub run build_runner clean`

## App Architecture

- MVVM architecture
- Repository Pattern
  - JSON serialization/deserialization of model classes using freezed library
- dependency injection using injectable library

The app architecture is inspired by the following projects:

 - https://github.com/noveriojoee/what_to_do_app_flutter
 - https://github.com/HarryHaiVn/Flutter-Clean-Architecture-MVVM/tree/master
 - https://github.com/wasabeef/flutter-architecture-blueprints/tree/main
 - https://github.com/dacianf/flutter_rxdart_state_management/tree/master
