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
  Duration rewindDuration = const Duration(seconds: 10);
  Duration forwardDuration = const Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future<void> initAudioPlayer() async {
    await player.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///assets/mp3/story-1.mp3')));
  }

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
            Text(
              widget.storyBook.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/image/storyimage/${widget.storyBook.sessionId}-1.png",
              width: 370,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    size: 40,
                  ),
                  onPressed: () {
                    // 현재 위치에서 10초 뒤로 이동
                    Duration currentPosition = player.position;
                    Duration newPosition = currentPosition - rewindDuration;
                    player.seek(newPosition);
                  },
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
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    size: 40,
                  ),
                  onPressed: () {
                    // 현재 위치에서 10초 앞으로 이동
                    Duration currentPosition = player.position;
                    Duration newPosition = currentPosition + forwardDuration;
                    player.seek(newPosition);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<Duration?>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return Text(
                      '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: audioFontSize(),
                    );
                  },
                ),
                Text(
                  " / ",
                  style: audioFontSize(),
                ),
                StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return Text(
                      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: audioFontSize(),
                    );
                  },
                ),
              ],
            ),
            StreamBuilder<Duration?>(
              // StreamBuilder 추가
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Slider(
                  min: 0.0,
                  max: (player.duration ?? Duration.zero).inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(), // 현재 위치로 value 설정
                  onChanged: (value) {
                    player.seek(Duration(seconds: value.toInt()));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle audioFontSize() {
    return const TextStyle(
      fontSize: 18,
    );
  }
}
