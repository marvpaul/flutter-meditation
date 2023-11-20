# object serialization
## shared preferences with  JSON serialization/deserialization

### freezed

- code generator for data (model) classes
    - https://betterprogramming.pub/a-look-at-the-flutter-freezed-package-5ea5473c6abc

#### example project:
https://github.com/dacianf/flutter_rxdart_state_management/tree/master

### dart json

## SQLite
- better choice when store a large amount of (structured) data
  https://stackoverflow.com/questions/6276358/pros-and-cons-of-sqlite-and-shared-preferences

# State Management (Notifications from ViewModel to View)

## ChangeNotifier

## Bloc
https://martin-appelmann.de/mit-flutter-bloc-effizienten-app-entwicklung/

- bloc "is great for testable code"
    - https://www.reddit.com/r/FlutterDev/comments/mgxty6/pros_and_cons_of_using_flutter_bloc_vs/

## RXDart
https://github.com/dacianf/flutter_rxdart_state_management/tree/master

## Provider
https://pub.dev/packages/provider

# Dependency injection

- why we should use it + example using **get_it**:
    - https://medium.com/@flutterdynasty/dependency-injection-in-flutter-0f308870d1a5#:~:text=Dependency%20injection%20is%20a%20powerful,specific%20requirements%20and%20design%20patterns.
## Injectable
- Code generator for get_it
    - https://pub.dev/packages/injectable#setup

# Examples

## MVVM + DI + Change Notifier + Repository Pattern

https://github.com/cesarferreira/flutter-architecture-example

## WhatToDo App (MVVM, Provider, Injectable, Freezed)

https://github.com/noveriojoee/what_to_do_app_flutter