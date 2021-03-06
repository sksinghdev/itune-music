import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/services/player_provider.dart';
import 'package:musicplayer/uirowtemplate/now_playing_template.dart';
import 'package:musicplayer/uirowtemplate/radio_row_template.dart';
import 'package:provider/provider.dart';

class DasBoardVIew extends StatefulWidget {
  @override
  _DasBoardVIewState createState() => _DasBoardVIewState();
}

class _DasBoardVIewState extends State<DasBoardVIew> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllRadios(searchQuery: "Love you");

    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    var radiosBloc = Provider.of<PlayerProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      radiosBloc.fetchAllRadios(
        searchQuery: _searchQuery.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color green = Color(0xFF8185E2);
    return Scaffold(
      backgroundColor: Color(0xFFc9c9c9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Itunes Music",
          style: GoogleFonts.abel(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              textStyle: TextStyle(
                color: Color(0xFFffffff),
              )),
        ),
        elevation: 0,
        backgroundColor: green,

      ),
      body: Column(
        children: [_searchBar(), _radiosList(), _nowPlaying()],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
            child: new TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Search Music',
              ),
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _radiosList() {
    return Consumer<PlayerProvider>(
      builder: (context, radioModel, child) {
        if (radioModel.allRadio.length > 0) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                      itemCount: radioModel.allRadio.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RadioRowTemplate(
                            radioModel: radioModel.allRadio[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      })
                ],
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }

        if (radioModel.allRadio == 0) {
          return new Expanded(
            child: _noData(),
          );
        }

        return getSpinkKit();
      },
    );
  }
  getSpinkKit() {
    return SpinKitFadingCircle(
      color: Color(0xFF8185E2),
      size: 30.0,
    );
  }
  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    noDataTxt = "No Music Found";
    showTextMessage = true;

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
                    noDataTxt,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : getSpinkKit(),
          ),
        ),
      ],
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    playerProvider.resetStreams();
    String trackname;
    String trackImage;
    if (playerProvider.currentRadio  == null) {
      trackname = "";
      trackImage = "";
    } else {

      trackname = playerProvider.currentRadio.trackName;
      trackImage = playerProvider.currentRadio.artworkUrl100;
    }
    return Visibility(
      visible: playerProvider.getPlayerState() == RadioPlayerState.PLAYING,
      child: NowPlayingTemplate(
        radioTitle: trackname,
        radioImageURL: trackImage,
      ),
    );
  }
}
