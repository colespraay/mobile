import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Controller to capture and share widgets as images
class ShareWidgetController {
  final GlobalKey _globalKey = GlobalKey();

  GlobalKey get key => _globalKey;

  /// Capture the widget as an image and return as bytes
  Future<Uint8List?> captureAsImage({
    double pixelRatio = 3.0,
    Color backgroundColor = Colors.white,
  }) async {
    try {
      // Find the RenderRepaintBoundary
      RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('Error: Could not find RenderRepaintBoundary');
        return null;
      }

      // Capture the image
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      // Convert to byte data with white background
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw white background
      final paint = Paint()..color = backgroundColor;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint,
      );

      // Draw the captured image on top
      canvas.drawImage(image, Offset.zero, Paint());

      final picture = recorder.endRecording();
      final finalImage = await picture.toImage(image.width, image.height);

      // Convert to byte data
      ByteData? byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        debugPrint('Error: Could not convert image to bytes');
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget as image: $e');
      return null;
    }
  }

  /// Share the widget as an image
  Future<void> shareAsImage({
    String? text,
    String? subject,
    String fileName = 'shared_image.png',
    double pixelRatio = 3.0,
    Color backgroundColor = Colors.white,
  }) async {
    try {
      // Capture the image
      final imageBytes = await captureAsImage(
        pixelRatio: pixelRatio,
        backgroundColor: backgroundColor,
      );

      if (imageBytes == null) {
        debugPrint('Failed to capture image');
        return;
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';

      // Write the file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: text,
        subject: subject,
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }

  /// Save the widget as an image to gallery/downloads
  Future<File?> saveAsImage({
    String fileName = 'image.png',
    double pixelRatio = 3.0,
    Color backgroundColor = Colors.white,
  }) async {
    try {
      final imageBytes = await captureAsImage(
        pixelRatio: pixelRatio,
        backgroundColor: backgroundColor,
      );

      if (imageBytes == null) {
        debugPrint('Failed to capture image');
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      debugPrint('Image saved to: $filePath');
      return file;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }
}

/// Widget wrapper that makes any widget shareable as an image
class ShareableWidget extends StatelessWidget {
  final ShareWidgetController controller;
  final Widget child;
  final Color? backgroundColor;

  const ShareableWidget({
    Key? key,
    required this.controller,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.key,
      child: Container(
        color: backgroundColor ?? Colors.white, // Default to white instead of transparent
        child: child,
      ),
    );
  }
}

/// Example usage widget
class ShareableCardExample extends StatefulWidget {
  const ShareableCardExample({Key? key}) : super(key: key);

  @override
  State<ShareableCardExample> createState() => _ShareableCardExampleState();
}

class _ShareableCardExampleState extends State<ShareableCardExample> {
  final ShareWidgetController _shareController = ShareWidgetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shareable Widget Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareController.shareAsImage(
              text: 'Check out my verification steps!',
              fileName: 'verification_steps.png',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final file = await _shareController.saveAsImage(
                fileName: 'verification_${DateTime.now().millisecondsSinceEpoch}.png',
              );
              if (file != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Saved to: ${file.path}')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Wrap your widget with ShareableWidget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShareableWidget(
                controller: _shareController,
                backgroundColor: Colors.white,
                child: _buildVerificationSteps(),
              ),
            ),

            const SizedBox(height: 20),

            // Control buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _shareController.shareAsImage(
                      text: 'Verification Steps',
                      fileName: 'steps.png',
                    ),
                    icon: const Icon(Icons.share),
                    label: const Text('Share as Image'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final bytes = await _shareController.captureAsImage();
                      if (bytes != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Image captured: ${bytes.length} bytes'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capture Only'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next Steps Section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Next steps:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _buildStep(
                number: '1',
                title: 'Check your email',
                description: 'Look for an email from our verification partner, Persona',
              ),
              const SizedBox(height: 20),
              _buildStep(
                number: '2',
                title: 'Click the verification link',
                description: 'This will open a secure verification flow',
              ),
              const SizedBox(height: 20),
              _buildStep(
                number: '3',
                title: 'Complete identity verification',
                description: 'Upload your ID and take a selfie (~5 minutes)',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Warning section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE047),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF92400E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Don\'t see the email?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBullet('Check your spam/junk folder'),
                    const SizedBox(height: 4),
                    _buildBullet('Make sure you entered the correct email address'),
                    const SizedBox(height: 4),
                    _buildBullet('The link expires in 24 hours'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF92400E),
            height: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF92400E),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// Alternative: ShareService for dependency injection
class ShareService {
  /// Share any widget as an image
  static Future<void> shareWidget({
    required GlobalKey key,
    String? text,
    String? subject,
    String fileName = 'shared_image.png',
    double pixelRatio = 3.0,
  }) async {
    try {
      RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final imageBytes = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(filePath)], text: text, subject: subject);
    } catch (e) {
      debugPrint('Error sharing widget: $e');
    }
  }
}
