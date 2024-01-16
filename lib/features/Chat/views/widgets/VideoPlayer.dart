import 'dart:io';
import 'package:cache_video_player/player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyVideoPlayer extends StatefulWidget {
  // type 1 for file
  // type 2 for network

  final int videotype;
  final File videopath;
  final String videourl;

  const MyVideoPlayer({
    super.key,
    required this.videotype,
    required this.videopath,
    required this.videourl,
  });

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    if (widget.videotype == 1) {
      _controller = VideoPlayerController.file(widget.videopath)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.network(widget.videourl)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const SizedBox(),
        Align(
          child: SizedBox(height: MediaQuery.of(context).size.height/2,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play(
                    );
                  });
                },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
