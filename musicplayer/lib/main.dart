import 'package:flutter/material.dart';
import 'package:musicplayer/controller/dashboard.dart';
import 'package:musicplayer/services/player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
          child: DasBoardVIew(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DasBoardVIew(),
      ),
    );
  }
}
