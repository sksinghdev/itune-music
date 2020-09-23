import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicplayer/model/MusicListModel.dart';

import 'base_model.dart';

class WebService {
  Future<MusicListModel> getData(String url ) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {

      return MusicListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
