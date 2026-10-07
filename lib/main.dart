import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AudioVerificationApp());
}

enum AppStage {
  ipInput,
  otpInput,
  verifyingCode,
  permissionRequest,
  recording,
  review,
  uploading,
  success,
}

class AudioVerificationApp extends StatelessWidget {
  const AudioVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Verification App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),
      home: const VerificationFlowScreen(),
    );
  }
}

class VerificationFlowScreen extends StatefulWidget {
  const VerificationFlowScreen({super.key});

  @override
  State<VerificationFlowScreen> createState() => _VerificationFlowScreenState();
}

class _VerificationFlowScreenState extends State<VerificationFlowScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  AppStage _stage = AppStage.ipInput;
  bool _isLoading = false;
  bool _isRecording = false;
  String? _ipError;
  String? _otpError;
  String _statusMessage = 'في انتظار البيانات';

  Color get _screenBackground {
    switch (_stage) {
      case AppStage.ipInput:
        return const Color(0xFFEAF4FF);
      case AppStage.otpInput:
        return const Color(0xFFFFF7EE);
      case AppStage.verifyingCode:
        return const Color(0xFFF8FAFC);
      case AppStage.permissionRequest:
        return const Color(0xFFF3F0FF);
      case AppStage.recording:
        return const Color(0xFFFDF2F8);
      case AppStage.review:
        return const Color(0xFFECFDF5);
      case AppStage.uploading:
        return const Color(0xFFE0F2FE);
      case AppStage.success:
        return const Color(0xFF1D4ED8);
    }
  }

  Color get _primaryButtonColor {
    switch (_stage) {
      case AppStage.ipInput:
        return const Color(0xFF2563EB);
      case AppStage.otpInput:
        return const Color(0xFFF59E0B);
      case AppStage.verifyingCode:
        return const Color(0xFF2563EB);
      case AppStage.permissionRequest:
        return const Color(0xFF7C3AED);
      case AppStage.recording:
        return const Color(0xFF2563EB);
      case AppStage.review:
        return const Color(0xFF10B981);
      case AppStage.uploading:
        return const Color(0xFF2563EB);
      case AppStage.success:
        return const Color(0xFFFFFFFF);
    }
  }

  String get _screenTitle {
    switch (_stage) {
      case AppStage.ipInput:
        return 'إدخال عنوان IP';
      case AppStage.otpInput:
        return 'إدخال كود التحقق';
      case AppStage.verifyingCode:
        return 'جارٍ التحقق';
      case AppStage.permissionRequest:
        return 'طلب صلاحية التسجيل';
      case AppStage.recording:
        return 'تسجيل الصوت';
      case AppStage.review:
        return 'مراجعة التسجيل';
      case AppStage.uploading:
        return 'إرسال التسجيل';
      case AppStage.success:
        return 'تم الإرسال بنجاح';
    }
  }

  bool _isValidIPv4(String value) {
    final regExp = RegExp(
      r'^(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}$',
    );
    return regExp.hasMatch(value.trim());
  }

  Future<void> _handleIpSubmit() async {
    final ip = _ipController.text.trim();

    if (ip.isEmpty || !_isValidIPv4(ip)) {
      setState(() {
        _ipError = 'عنوان IP غير صحيح، يرجى إدخال عنوان IPv4 صالح.';
      });
      return;
    }

    setState(() {
      _ipError = null;
      _isLoading = true;
      _statusMessage = 'جارٍ التحقق من عنوان IP...';
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _statusMessage = 'تم قبول عنوان IP بنجاح.';
      _stage = AppStage.otpInput;
    });
  }

  Future<void> _handleOtpSubmit() async {
    final code = _otpController.text.trim();

    if (code.isEmpty || code.length < 4) {
      setState(() {
        _otpError = 'يرجى إدخال كود تحقق صحيح.';
      });
      return;
    }

    setState(() {
      _otpError = null;
      _isLoading = true;
      _stage = AppStage.verifyingCode;
      _statusMessage = 'جارٍ التحقق من الكود...';
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final valid = code == '1234';
    if (valid) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'تم التحقق من الكود بنجاح';
        _stage = AppStage.permissionRequest;
      });
    } else {
      setState(() {
        _isLoading = false;
        _otpError = 'كود التحقق غير صحيح، يرجى المحاولة مرة أخرى';
        _stage = AppStage.otpInput;
      });
    }
  }

  Future<void> _requestMicPermission() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'إرسال طلب تسجيل الصوت...';
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final status = await Permission.microphone.request();

    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'تم السماح بتسجيل الصوت';
        _stage = AppStage.recording;
      });
    } else {
      setState(() {
        _isLoading = false;
        _statusMessage = 'تم رفض صلاحية الميكروفون. حاول مرة أخرى.';
        _stage = AppStage.permissionRequest;
      });
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _statusMessage = 'جاري تسجيل الصوت...';
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _statusMessage = 'تم إيقاف التسجيل، يمكنك إرساله أو إعادة التسجيل.';
      _stage = AppStage.review;
    });
  }

  void _reRecord() {
    setState(() {
      _isRecording = false;
      _statusMessage = 'تم حذف التسجيل الحالي. يمكنك تسجيل صوت جديد.';
      _stage = AppStage.recording;
    });
  }

  Future<void> _uploadRecording() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري إرسال التسجيل...';
      _stage = AppStage.uploading;
    });

    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _statusMessage = 'تم إرسال الصوت بنجاح';
      _stage = AppStage.success;
    });
  }

  void _resetFlow() {
    setState(() {
      _stage = AppStage.ipInput;
      _isLoading = false;
      _isRecording = false;
      _ipError = null;
      _otpError = null;
      _statusMessage = 'في انتظار البيانات';
      _ipController.clear();
      _otpController.clear();
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final compact = screenWidth < 380;

    return Scaffold(
      backgroundColor: _screenBackground,
      body: SafeArea(
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(compact ? 18 : 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<AppStage>(_stage),
                decoration: BoxDecoration(
                  color: _stage == AppStage.success ? const Color(0xFF1D4ED8) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(compact ? 18 : 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    if (_stage == AppStage.ipInput) ...[
                      _buildIpScreen(),
                    ] else if (_stage == AppStage.otpInput || _stage == AppStage.verifyingCode) ...[
                      _buildOtpScreen(),
                    ] else if (_stage == AppStage.permissionRequest) ...[
                      _buildPermissionScreen(),
                    ] else if (_stage == AppStage.recording) ...[
                      _buildRecordingScreen(),
                    ] else if (_stage == AppStage.review) ...[
                      _buildReviewScreen(),
                    ] else if (_stage == AppStage.uploading) ...[
                      _buildUploadingScreen(),
                    ] else if (_stage == AppStage.success) ...[
                      _buildSuccessScreen(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isSuccess = _stage == AppStage.success;

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isSuccess ? Colors.white.withOpacity(0.12) : const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(
            isSuccess ? Icons.check_circle : Icons.mic_none_rounded,
            size: 34,
            color: isSuccess ? Colors.white : const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _screenTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isSuccess ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildIpScreen() {
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
          controller: _ipController,
          keyboardType: TextInputType.number,
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
            errorText: _ipError,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleIpSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: _isLoading
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

  Widget _buildOtpScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_statusMessage.isNotEmpty && _stage == AppStage.otpInput)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
            ),
          ),
        if (_stage == AppStage.verifyingCode)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700),
            ),
          ),
        const Text(
          'أدخل الكود المرسل من الخادم',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _otpController,
          obscureText: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
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
            errorText: _otpError,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleOtpSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: _isLoading
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

  Widget _buildPermissionScreen() {
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
          onPressed: _isLoading ? null : _requestMicPermission,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: _isLoading
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

  Widget _buildRecordingScreen() {
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
            _statusMessage,
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
              Icon(_isRecording ? Icons.mic : Icons.mic_none_rounded, size: 64, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                _isRecording ? 'جاري تسجيل الصوت...' : 'تم السماح بتسجيل الصو��',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _startRecording,
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
          onPressed: _isRecording ? _stopRecording : null,
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

  Widget _buildReviewScreen() {
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
          onPressed: _isLoading ? null : _uploadRecording,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: const Text('إرسال الصوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _reRecord,
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

  Widget _buildUploadingScreen() {
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
          _statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A)),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen() {
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
          _statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, color: Colors.white70),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: _resetFlow,
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

