import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_meditation/home/data/dto/get_all_meditation_dto.dart';
import 'package:flutter_meditation/home/data/model/meditation_model.dart';
import 'package:flutter_meditation/home/data/repository/past_meditation_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@singleton
class MeditationRepositoryLocal implements MeditationRepository{
  final SharedPreferences prefs;

  MeditationRepositoryLocal(this.prefs);

  @override
  Future<List<MeditationModel>?> getAllMeditation() async {
    final String? meditationJson = prefs.getString("meditations");
    if (meditationJson != null) {
      debugPrint(meditationJson);
      return GetMeditationDTO.fromJson(JsonDecoder().convert(meditationJson)).meditations;
    }
    return null;
  }
}