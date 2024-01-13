/// {@category Repository}
/// Repository for handling a list of all previous meditations
library all_meditations_repository_local;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/home/data/dto/get_all_meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A local implementation of the [AllMeditationsRepository] interface.
@singleton
class AllMeditationsRepositoryLocal implements AllMeditationsRepository {
  /// The [SharedPreferences] instance for storing data locally.
  final SharedPreferences prefs;

  /// Constructs an instance of [AllMeditationsRepositoryLocal] with the provided [prefs].
  AllMeditationsRepositoryLocal(this.prefs);

  final StreamController<List<MeditationModel>?> _meditationStreamController = StreamController<List<MeditationModel>?>.broadcast();

  Stream<List<MeditationModel>?> get meditationStream => _meditationStreamController.stream;


  /// Retrieves all saved meditations from local storage.
  ///
  /// Returns a list of [MeditationModel] if available; otherwise, returns `null`.
  @override
  Future<List<MeditationModel>?> getAllMeditation() async {
    final String? meditationJson = prefs.getString(AllMeditationsRepository.sessionKey);
    if (meditationJson != null) {
      List<MeditationModel> meditations = GetMeditationDTO.fromJson(JsonDecoder().convert(meditationJson)).meditations;
      _meditationStreamController.add(meditations);
      return meditations; 
    }
    return null;
  }

  /// Saves a list of meditations to local storage.
  ///
  /// The [meditations] parameter represents the list of [MeditationModel] to be saved.
  @override
  void saveMeditations(List<MeditationModel> meditations) {
    _meditationStreamController.add(meditations);
    final String meditationJson = JsonEncoder().convert(GetMeditationDTO(meditations: meditations).toJson());
    prefs.setString(AllMeditationsRepository.sessionKey, meditationJson);
  }
  
  /// Adds a single meditation to the list of saved meditations in local storage.
  ///
  /// The [meditation] parameter represents the [MeditationModel] to be added.
  @override
  void addMeditation(MeditationModel meditation) {
    final String? meditationJson = prefs.getString(AllMeditationsRepository.sessionKey);
    List<MeditationModel> meditations;
    if (meditationJson != null) {
      meditations = GetMeditationDTO.fromJson(JsonDecoder().convert(meditationJson)).meditations;
    } else {
      meditations = [];
    }
    meditations.add(meditation); 
    saveMeditations(meditations); 
  }
}
