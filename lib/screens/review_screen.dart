import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onUpload;
  final VoidCallback onReRecord;

  const ReviewScreen({
    required this.isLoading,
    required this.onUpload,
    required this.onReRecord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'تم إنهاء التسجيل، يمكنك إرساله أو تسجيل صوت جديد.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xFF065F46), fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onUpload,
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
              : const Text('إرسال الصوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: isLoading ? null : onReRecord,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
            foregroundColor: const Color(0xFF2563EB),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('إعادة التسجيل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
