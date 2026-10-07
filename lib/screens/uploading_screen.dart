import 'package:flutter/material.dart';

class UploadingScreen extends StatelessWidget {
  final String statusMessage;

  const UploadingScreen({required this.statusMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 88,
            height: 88,
            child: CircularProgressIndicator(
              strokeWidth: 7,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A)),
        ),
      ],
    );
  }
}
