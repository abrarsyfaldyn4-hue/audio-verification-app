import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String statusMessage;
  final VoidCallback onNewRecording;

  const SuccessScreen({
    required this.statusMessage,
    required this.onNewRecording,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, size: 90, color: Colors.white),
        const SizedBox(height: 22),
        const Text(
          'تم إرسال الصوت بنجاح',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const SizedBox(height: 18),
        Text(
          statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, color: Colors.white70),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: onNewRecording,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1D4ED8),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('تسجيل صوت جديد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
