import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../values/colors.dart';

class SplashDemoPage extends StatefulWidget {
  const SplashDemoPage({super.key});

  @override
  State<SplashDemoPage> createState() => _SplashDemoPageState();
}

class _SplashDemoPageState extends State<SplashDemoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(
      'assets/videos/sc_bg_video.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    // play
    _controller.play();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.only(top:24.0),
        child: Center(
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
