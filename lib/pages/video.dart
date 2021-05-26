import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class SerieExample extends StatefulWidget {
  final String url;
  SerieExample({Key key, this.url}) : super(key: key);

  @override
  _SerieExampleState createState() => _SerieExampleState();
}

class _SerieExampleState extends State<SerieExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          widget.url,
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}
