import 'package:flutter/material.dart';

class IpInputScreen extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool isLoading;
  final VoidCallback onSubmit;

  const IpInputScreen({
    required this.controller,
    this.error,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'أدخل عنوان IP الخاص بالجهاز',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: !isLoading,
          decoration: InputDecoration(
            hintText: 'مثال: 192.168.1.10',
            prefixIcon: const Icon(Icons.lan_outlined),
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
            backgroundColor: const Color(0xFF2563EB),
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
              : const Text('متابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
