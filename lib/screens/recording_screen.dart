import 'package:flutter/material.dart';

class RecordingScreen extends StatelessWidget {
  final bool isRecording;
  final String statusMessage;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const RecordingScreen({
    required this.isRecording,
    required this.statusMessage,
    required this.onStart,
    required this.onStop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF2F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Color(0xFFBE185D), fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          height: 210,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF9A8D4), Color(0xFFE879F9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isRecording ? Icons.mic : Icons.mic_none_rounded, size: 64, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                isRecording ? 'جاري تسجيل الصوت...' : 'تم السماح بتسجيل الصوت',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: isRecording ? null : onStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('بدء تسجيل الصوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: isRecording ? onStop : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('إيقاف التسجيل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
