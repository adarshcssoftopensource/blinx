import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController controller;
  bool showControls = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;

    controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
        controller.play();
      }
    });

    controller.addListener(_onControllerUpdated);
  }

  void _onControllerUpdated() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdated);
    controller.pause();
    controller.dispose();

    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = controller.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => setState(() => showControls = !showControls),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: isInitialized
                    ? FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: VideoPlayer(controller),
                        ),
                      )
                    : SizedBox(
                        height: 80,
                        width: 80,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
              if (showControls)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                ),

              if (showControls)
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: Image.asset(
                      CommonUi.setPngIcon("left_vector"),
                      height: 15,
                      width: 15,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              if (showControls && isInitialized)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.white54,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              _formatDuration(controller.value.position),
                              style: const TextStyle(color: Colors.white),
                            ),

                            const Spacer(),

                            IconButton(
                              icon: Icon(
                                isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
                                  controller.setVolume(isMuted ? 0 : 1);
                                });
                              },
                            ),

                            Text(
                              _formatDuration(controller.value.duration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
