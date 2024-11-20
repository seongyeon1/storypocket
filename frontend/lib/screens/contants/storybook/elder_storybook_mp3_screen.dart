import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_project/models/story_book.dart';

class ElderStorybookMp3Screen extends StatefulWidget {
  final StoryBook storyBook;
  const ElderStorybookMp3Screen({super.key, required this.storyBook});

  @override
  State<ElderStorybookMp3Screen> createState() =>
      _ElderStorybookMp3ScreenState();
}

class _ElderStorybookMp3ScreenState extends State<ElderStorybookMp3Screen> {
  final player = AudioPlayer();

  bool isPlaying = false;
  double volume = 0.5;
  bool isVolumeDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAudioPlayer();
  }

  Future<void> initAudioPlayer() async {
    await player.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/mp3/story-1.mp3')));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP3 플레이어'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/storyimage/${widget.storyBook.sessionId}-1.png",
              width: 370,
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return const CircularProgressIndicator();
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 64.0,
                    onPressed: player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 64.0,
                    onPressed: player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 64.0,
                    onPressed: () => player.seek(Duration.zero),
                  );
                }
              },
            ),
            StreamBuilder<Duration?>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Text(
                  '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                );
              },
            ),
            StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return Text(
                  '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                );
              },
            ),
            Slider(
              min: 0.0,
              max: (player.duration ?? Duration.zero).inSeconds.toDouble(),
              value: (player.position ?? Duration.zero).inSeconds.toDouble(),
              onChanged: (value) {
                player.seek(Duration(seconds: value.toInt()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
