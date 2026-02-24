// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  // Background gradient: dark navy to black
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final t = y / size;
      final r = (10 + (5 * t)).toInt();
      final g = (14 + (8 * t)).toInt();
      final b = (33 + (0 * t)).toInt();
      image.setPixel(x, y, img.ColorRgb8(r, g, b));
    }
  }

  // Draw circular background disc (subtle dark red glow)
  final cx = size ~/ 2;
  final cy = size ~/ 2;
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x - cx;
      final dy = y - cy;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist < 380) {
        final factor = 1.0 - (dist / 380);
        final pixel = image.getPixel(x, y);
        final pr = pixel.r.toInt();
        final pg = pixel.g.toInt();
        final pb = pixel.b.toInt();
        final newR = (pr + (40 * factor * factor)).clamp(0, 255).toInt();
        final newG = (pg + (5 * factor * factor)).clamp(0, 255).toInt();
        final newB = (pb + (10 * factor * factor)).clamp(0, 255).toInt();
        image.setPixel(x, y, img.ColorRgb8(newR, newG, newB));
      }
    }
  }

  // Draw film strip arcs (golden)
  for (int angle = -30; angle <= 210; angle++) {
    final rad = angle * pi / 180;
    for (int r = 340; r <= 360; r++) {
      final x = (cx + r * cos(rad)).toInt();
      final y = (cy + r * sin(rad)).toInt();
      if (x >= 0 && x < size && y >= 0 && y < size) {
        // Golden color with fade
        final alpha =
            ((1.0 - ((angle + 30) / 240).abs()) * 200).clamp(30, 200).toInt();
        image.setPixel(x, y, img.ColorRgba8(255, 193, 7, alpha));
      }
    }
  }

  // Draw play triangle (crimson red #E50914)
  final triCx = cx + 20; // slight offset to center visually
  final triCy = cy;
  final triSize = 200;
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      // Check if point is inside triangle
      // Triangle pointing right: left vertex at (-triSize, -triSize), (-triSize, triSize), (triSize, 0)
      final px = (x - triCx).toDouble();
      final py = (y - triCy).toDouble();

      // Normalized coordinates
      final nx = px / triSize;
      final ny = py / triSize;

      // Triangle: right-pointing
      // Vertices: (-0.8, -0.9), (-0.8, 0.9), (1.0, 0.0)
      if (nx >= -0.8 && nx <= 1.0) {
        final maxY = 0.9 * (1.0 - nx) / 1.8;
        if (ny.abs() <= maxY) {
          // Add slight gradient
          final brightness = 229 + ((nx + 0.8) * 15).toInt();
          image.setPixel(
              x, y, img.ColorRgb8(brightness.clamp(200, 245), 9, 20));
        }
      }
    }
  }

  // Save icon
  final pngData = img.encodePng(image);
  File('assets/app_icon.png').writeAsBytesSync(pngData);
  print('✅ Icon generated: assets/app_icon.png (${pngData.length} bytes)');
}
