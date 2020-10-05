import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:musicplayer/model/MusicListModel.dart';
import 'package:musicplayer/services/player_provider.dart';
import 'package:musicplayer/utils/hex_color.dart';
import 'package:provider/provider.dart';

class RadioRowTemplate extends StatefulWidget {
  final Results radioModel;

  RadioRowTemplate({Key key, this.radioModel}) : super(key: key);

  @override
  _RadioRowTemplateState createState() => _RadioRowTemplateState();
}

class _RadioRowTemplateState extends State<RadioRowTemplate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  Widget _buildSongRow() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerProvider.resetStreams();
    bool _isSelectedRadio;
    if (playerProvider.currentRadio == null) {
      _isSelectedRadio = false;
    } else {
      _isSelectedRadio =
          this.widget.radioModel.trackId == playerProvider.currentRadio.trackId;
    }

    return ListTile(
      title: new Text(
        this.widget.radioModel.trackName,
        style: new TextStyle(
          fontWeight: FontWeight.w600,
          color: HexColor("#182545"),
          fontSize: 14
        ),
        maxLines: 1,
      ),
      leading: _image(this.widget.radioModel.artworkUrl100),
      subtitle: new Text(this.widget.radioModel.artistName+"\n${this.widget.radioModel.collectionName}", maxLines: 2,style: TextStyle(fontSize: 12),),
      trailing: Wrap(
        spacing: -10.0, // gap between adjacent chips
        runSpacing: 0.0, // gap between lines
        children: <Widget>[
          _buildPlayStopIcon(
            playerProvider,
            _isSelectedRadio,
          ),
        ],
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: HexColor("#FFE5EC"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(
      PlayerProvider playerProvider, bool _isSelectedSong) {
    return IconButton(
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
      onPressed: () {
        if (!playerProvider.isStopped() && _isSelectedSong) {
          playerProvider.stopRadio();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(this.widget.radioModel);

            playerProvider.playRadio();
          }
        }
      },
    );
  }

  getSpinkKit() {
    return SpinKitWave(
      color: Color(0xFF8185E2),
      size: 20.0,
    );
  }

  Widget _buildAudioButton(PlayerProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (!model.isStopped()) {
        return Icon(MaterialCommunityIcons.pause_circle,
            size: 30, color: Color(0xFF8185E2));
      }

      if (model.isStopped()) {
        return Icon(MaterialCommunityIcons.play_circle,
            size: 30, color: Color(0xFF8185E2));
      }
    } else {
      return Icon(MaterialCommunityIcons.play_circle,
          size: 30, color: Color(0xFF8185E2));
    }

    return new Container();
  }
}
