import 'dart:async';

import 'package:flutter/material.dart';

/// Custom video controls overlay
/// - Double-tap trái/phải → tua -10s / +10s
/// - Lock button → khóa màn hình
class VideoControlsOverlay extends StatefulWidget {
  final VoidCallback? onDoubleTapLeft;
  final VoidCallback? onDoubleTapRight;
  final VoidCallback? onToggleLock;
  final bool isLocked;

  const VideoControlsOverlay({
    super.key,
    this.onDoubleTapLeft,
    this.onDoubleTapRight,
    this.onToggleLock,
    this.isLocked = false,
  });

  @override
  State<VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  bool _showSeekIndicator = false;
  String _seekText = '';
  IconData _seekIcon = Icons.fast_forward;
  Timer? _seekTimer;

  void _showSeekFeedback(String text, IconData icon) {
    setState(() {
      _showSeekIndicator = true;
      _seekText = text;
      _seekIcon = icon;
    });
    _seekTimer?.cancel();
    _seekTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showSeekIndicator = false);
      }
    });
  }

  @override
  void dispose() {
    _seekTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLocked) {
      return GestureDetector(
        onTap: widget.onToggleLock,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock, color: Colors.white, size: 24),
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Double-tap zones
        Row(
          children: [
            // Left zone — rewind 10s
            Expanded(
              child: GestureDetector(
                onDoubleTap: () {
                  widget.onDoubleTapLeft?.call();
                  _showSeekFeedback('-10s', Icons.fast_rewind);
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Right zone — forward 10s
            Expanded(
              child: GestureDetector(
                onDoubleTap: () {
                  widget.onDoubleTapRight?.call();
                  _showSeekFeedback('+10s', Icons.fast_forward);
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),

        // Seek indicator
        if (_showSeekIndicator)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_seekIcon, color: Colors.white, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    _seekText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
