import 'package:flutter/material.dart';

class PermissionRequestScreen extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRequest;

  const PermissionRequestScreen({
    required this.isLoading,
    required this.onRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'تم التحقق من الكود بنجاح',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'لإرسال تسجيل صوتي، يحتاج التطبيق إلى صلاحية الميكروفون.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF374151)),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
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
              : const Text('إرسال طلب تسجيل الصوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
