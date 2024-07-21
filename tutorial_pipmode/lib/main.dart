import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  Offset position = Offset(100, 100);
  bool isFloatingVideoVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videoplayback.mp4',
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toggleFloatingVideo() {
    setState(() {
      isFloatingVideoVisible = !isFloatingVideoVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Floating Video Example'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: toggleFloatingVideo,
              child: Text('Play Floating Video'),
            ),
          ),
          if (isFloatingVideoVisible && _controller.value.isInitialized)
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Draggable(
                feedback: Material(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: VideoPlayer(_controller),
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                },
                child: SizedBox(
                  width: 200,
                  height: 150,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
