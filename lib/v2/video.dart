// import 'package:better_player/better_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class SerieExample extends StatefulWidget {
  const SerieExample({Key key, this.url}) : super(key: key);
  final String url;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: widget.url.startsWith('http')
              ? BetterPlayer.network(
                  widget.url,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    // aspectRatio: 9 / 16,
                    fullScreenByDefault: false,
                    autoPlay: true,
                    fit: BoxFit.contain,
                  ),
                )
              : BetterPlayer.file(
                  widget.url,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    // aspectRatio: 9 / 16,
                    fullScreenByDefault: false,
                    autoPlay: true,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ),
    );
  }
}
