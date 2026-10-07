import 'package:flutter/material.dart';

class OtpInputScreen extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool isLoading;
  final String statusMessage;
  final bool isVerifying;
  final VoidCallback onSubmit;

  const OtpInputScreen({
    required this.controller,
    this.error,
    required this.isLoading,
    required this.statusMessage,
    required this.isVerifying,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isVerifying && statusMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF16A34A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (isVerifying)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const Text(
          'أدخل الكود المرسل من الخادم',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          enabled: !isLoading,
          decoration: InputDecoration(
            hintText: '••••',
            prefixIcon: const Icon(Icons.lock_outline),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
            ),
            errorText: error,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('إرسال الكود', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
