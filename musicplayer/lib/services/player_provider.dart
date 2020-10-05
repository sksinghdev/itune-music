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
      if (state == AudioPlayerState.PLAYING) {
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
      if(isPlaying()){
        updatePlayerState(RadioPlayerState.STOPPED);
        await _audioPlayer.stop();
      }

    }
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
    String urlfor =
        "https://itunes.apple.com/search?term=" + searchQuery + "&entity=song";
    MusicListModel model = await DBDownloadService.fetchAllRadios(urlfor);

    if (model != null && model.results.length > 0) {
      allRadio.addAll(model.results);
    }
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState state) {
    _playerState = state;
    notifyListeners();
  }
}
