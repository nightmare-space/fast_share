// import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:speed_share/themes/app_colors.dart';

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
    // return Scaffold(
    //   backgroundColor: AppColors.background,
    //   body: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(4.0),
    //       child: BetterPlayer.network(
    //         widget.url,
    //         betterPlayerConfiguration: BetterPlayerConfiguration(
    //           // aspectRatio: 9 / 16,
    //           fullScreenByDefault: false,
    //           autoPlay: true,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
