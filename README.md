# <img src="https://github.com/marvpaul/flutter-meditation/blob/master/assets/icon.png?raw=true" width="40" alt="Meditation view"> indsync - interactive meditation


## Introduction and showcase
This is what the app looks like in action. You can connect a Mi-Band 2/3/4 to get realtime heartrate data and meditate with the help of: 
- Binaural beats
- Several breathing pattern
- Realtime heart measurement
- Kaleidoscope mandala which synchronizes with breathing
- different visualizations
You can either configure these settings by yourself or (after the app collected enough training data, 2x10 minute sessions) let an AI-model predict the meditation sessions parameters which will relax you the most.
<div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/meditationView.png?raw=true" width="200" alt="Meditation view">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/startscreen.png?raw=true" width="200" alt="Start screen">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/settings.png?raw=true" width="200" alt="Settings">
</div>

## Testing
For our frontend we used the flutter testing framework paired with mockito to mock certain methods and data objects. 

Test coverage: 
[![codecov](https://codecov.io/gh/marvpaul/flutter-meditation/master/graph/badge.svg)](https://codecov.io/gh/marvpaul/flutter-meditation)

To run the tests locally you can use `flutter test`

## Design
We used a figma draft to design the UI which can be found here: https://www.figma.com/file/XJANOZdmRCKBhPL7Fgr3uC/Meditation-App-Material-Design?type=design&node-id=54895-66&mode=design

## Documentation 
We included source code documentation using `dart doc` following the dart documentation standards. The latest documentation will always be generated through our Github actions pipeline and is available as a pipeline artifact.

## AI mode 
The goal of this app is mainly to provide a user-tailored meditation experience which aims to relax the user. For this purpose we measure the heart rate in realtime using a MiBand 3. The user has to go through a training phase (2 sessions) where we randomly change the meditation parameters (kaleidoscope image, breathing cycle length, binaural beat frequencies ...). We record the heart rate along with the session and finally sent it over to our backend which trains a machine learning model in order to deliver meditaion parameters which will relax the user the most (bring heart rate down). 

## Build / deploy project

To build GETIt service locator instances for dependency injection and model classes run:
`flutter pub run build_runner build`

To clean generated files:
`flutter packages pub run build_runner clean`

Run for development: 
`flutter run`

If you want to deploy the app, please consider reading these articles: 
- Android: https://docs.flutter.dev/deployment/android
- iOS: https://docs.flutter.dev/deployment/ios

## App Architecture

- MVVM architecture
- Repository Pattern
  - JSON serialization/deserialization of model classes using freezed library
- dependency injection using injectable library

<img src="https://github.com/marvpaul/flutter-meditation/blob/master/architecture.png?raw=true" width="50%" alt="Meditation view">

The frontend of our Flutter app adopts the MVVM architecture, which divides the application's components into a view, viewmodel, and model/repository. The view is responsible for displaying data received from the viewmodel. The viewmodel, in turn, retrieves data from a repository that can be either remote or local. Additionally, there are services employed within the repository to fulfill specific functionalities, such as connecting to a Bluetooth wearable. Finally, Data Transfer Objects (DTOs) classes assist in serializing/deserializing our data models.

The app architecture is inspired by the following projects:

 - https://github.com/noveriojoee/what_to_do_app_flutter
 - https://github.com/HarryHaiVn/Flutter-Clean-Architecture-MVVM/tree/master
 - https://github.com/wasabeef/flutter-architecture-blueprints/tree/main
 - https://github.com/dacianf/flutter_rxdart_state_management/tree/master
