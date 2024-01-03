# In action 
![Meditation view](https://github.com/marvpaul/flutter_meditation/blob/master/screenshots/meditationView.png?raw=true)
![Meditation view](https://github.com/marvpaul/flutter_meditation/blob/master/screenshots/startscreen.png?raw=true)
![Meditation view](https://github.com/marvpaul/flutter_meditation/blob/master/screenshots/settings.png?raw=true)

# flutter_meditation

Frontend for our breathing meditation app. The app includes: 
- integration to MiBand 3 / 4 (connection via bluetooth, fetch of heart rate in realtime)
- Binaural beats
- Several breathing pattern
- Realtime heart measurement
- Kaleidoscope mandala which synchronizes with breathing

The goal of this app is to provide a user-tailored meditation experience which aims to relax the user. For this purpose we measure the heart rate in realtime using a MiBand 3. The user has to go through a training phase (2 sessions) where we randomly change the meditation parameters (kaleidoscope image, breathing cycle length, binaural beat frequencies ...). We record the heart rate along with the session and finally sent it over to our backend which trains a machine learning model in order to deliver meditaion parameters which will relax the user the most (bring heart rate down). 



## Build / deploy project

To build GETIt service locator instances for dependency injection and model classes run:

`flutter pub run build_runner build`

To clean generated files:

`flutter packages pub run build_runner clean`

To run for development purposes, please use `flutter run`

If you want to deploy the app, please consider reading these articles: 
- Android: https://docs.flutter.dev/deployment/android
- iOS: https://docs.flutter.dev/deployment/ios

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
