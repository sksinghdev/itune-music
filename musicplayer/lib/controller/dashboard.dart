import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayer/services/player_provider.dart';
import 'package:musicplayer/uirowtemplate/now_playing_template.dart';
import 'package:musicplayer/uirowtemplate/radio_row_template.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class DasBoardVIew extends StatefulWidget {
  @override
  _DasBoardVIewState createState() => _DasBoardVIewState();
}

class _DasBoardVIewState extends State<DasBoardVIew> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  String messagetoshow = "";

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() async {
    String valeto = await fortext();
    if (valeto != null && valeto.length > 5) {
      setState(() {
        messagetoshow = valeto;
      });
    } else {
      setState(() {
        messagetoshow = "";
      });
    }
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
        if (radioModel.allRadio != null && radioModel.allRadio.length > 0) {
          print('hello 3');
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
        if (radioModel.allRadio != null && radioModel.allRadio.length == 0) {
          return new Expanded(
            child: _noData("No Music Found"),
          );
        }
        if (radioModel.allRadio == null) {
          return new Expanded(
            child: _noData("Tap To Search Music"),
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

  Future<String> fortext() async {
    String valuetorurn;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        valuetorurn = "";
        return valuetorurn;
      }
    } on SocketException catch (_) {
      valuetorurn = "No Internet Found!";
      return valuetorurn;
    }
  }

  Widget _noData(String message) {
    if (messagetoshow.length > 6) {
    } else {
      messagetoshow = message;
    }
    bool showTextMessage = false;
    showTextMessage = true;

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
                    messagetoshow,
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
    if (playerProvider.currentRadio == null) {
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

  Widget getspinner = SizedBox(
    width: 0.0,
    height: 0.0,
  );
}
