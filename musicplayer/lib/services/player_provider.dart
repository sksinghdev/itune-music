import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/model/MusicListModel.dart';
import 'package:musicplayer/services/db_download_service.dart';

enum RadioPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETED }

class PlayerProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  Results _radioDetails;

  List<Results> _radiosFetcher;
  List<Results> allRadio;

  //List<Results> get allRadio => _radiosFetcher;

  int get totalRecords => _radiosFetcher != null ? _radiosFetcher.length : 0;

  Results get currentRadio => _radioDetails;

  getPlayerState() => _playerState;

  getAudioPlayer() => _audioPlayer;

  getCurrentRadio() => _radioDetails;

  RadioPlayerState _playerState = RadioPlayerState.STOPPED;
  StreamSubscription _positionSubscription;

  PlayerProvider() {
    _initStreams();
  }

  void _initStreams() {

    if (_radioDetails == null) {
      if(_radiosFetcher!=null && _radiosFetcher.length>0){
        _radioDetails = _radiosFetcher[0];
      }

    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.STOPPED) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(Results music) async {
    _radioDetails = music;

    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.LOADING);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_playerState == RadioPlayerState.LOADING && p.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.PLAYING);
      }

      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print("Flutter : state : " + state.toString());
      if (state == AudioPlayerState.PLAYING) {
        //updatePlayerState(RadioPlayerState.PLAYING);
       // notifyListeners();
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(RadioPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playRadio() async {
    await _audioPlayer.play(currentRadio.previewUrl, stayAwake: true);
  }

  stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(RadioPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
    //await _audioPlayer.dispose();
  }

  bool isPlaying() {
    return getPlayerState() == RadioPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == RadioPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == RadioPlayerState.STOPPED;
  }

  fetchAllRadios({
    String searchQuery = "",
  }) async {
    stopRadio();
     _radiosFetcher = List<Results>();
     allRadio  = List<Results>();
    print('santi search view $searchQuery');
    String urlfor =
        "https://itunes.apple.com/search?term=" + searchQuery + "&entity=song";
    print('santi media search url : $urlfor');
    MusicListModel model = await DBDownloadService.fetchAllRadios(urlfor);

    if (model != null && model.results.length > 0) {
//      for (var i = 0; i < model.results.length; i++) {
//        Results resul = model.results[i];
//        String trackname = resul.trackName;
//        print('trackname value : $trackname');
//      }
      var modellength = model.results.length.toString();
      print('santi mode lenght : $modellength');

      allRadio.addAll(model.results);
      var fetchmodellength = allRadio.length.toString();
      print('santi mode allRadio length : $fetchmodellength');
    }
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state) {
    _playerState = state;
    notifyListeners();
  }
}
