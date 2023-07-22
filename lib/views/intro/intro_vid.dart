import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/views/login/login_page.dart';
import '/views/login/choose_login.dart';

class IntroVid extends StatefulWidget {
  @override
  _IntroVidState createState() => _IntroVidState();
}

class _IntroVidState extends State<IntroVid> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/intro/intro.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized.
      setState(() {});
    });

    // Delay of 2 seconds after the video is loaded before starting playback
    Future.delayed(Duration(seconds: 2), () {
      _controller.setVolume(0); // Mute the video
      _controller.play();
    });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ChooseLoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
