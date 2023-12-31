import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/home/data/dto/get_all_meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/all_meditations_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@singleton
class AllMeditationsRepositoryLocal implements AllMeditationsRepository{
  final SharedPreferences prefs;
  AllMeditationsRepositoryLocal(this.prefs);

  @override
  Future<List<MeditationModel>?> getAllMeditation() async {
    /* prefs.clear(); */
    final String? meditationJson = prefs.getString(AllMeditationsRepository.sessionKey);
    if (meditationJson != null) {
      return GetMeditationDTO.fromJson(JsonDecoder().convert(meditationJson)).meditations;
    }
    return null;
  }

  @override
  void saveMeditations(List<MeditationModel> meditations) {
    final String meditationJson = JsonEncoder().convert(GetMeditationDTO(meditations: meditations).toJson());
    prefs.setString(AllMeditationsRepository.sessionKey, meditationJson);
  }
  
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