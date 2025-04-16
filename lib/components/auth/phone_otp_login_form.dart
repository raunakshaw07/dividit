import 'package:dividit/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneOtpLoginForm extends StatefulWidget {
  final bool isLogin;
  const PhoneOtpLoginForm({super.key, required this.isLogin});

  @override
  State<PhoneOtpLoginForm> createState() => _PhoneOtpLoginFormState();
}

class _PhoneOtpLoginFormState extends State<PhoneOtpLoginForm> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _otpSent = false;
  bool _isLoading = false;

  void _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar("⚠️ Validation Error", "Please enter a phone number");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authController.signInWithPhone("+91$phone");
      setState(() => _otpSent = true);
      Get.snackbar("✅ OTP sent to $phone", "");
    } catch (e) {
      setState(() => _otpSent = true);
      Get.snackbar("❌ Error", "Error sending OTP: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showSnackbar("Please enter the OTP");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authController.verifyPhoneOtp(phoneNumber: phone, otp: otp, isLogin: widget.isLogin);
      Get.snackbar("✅ Success", "Phone ${widget.isLogin ? 'login' : 'signup'} successful");
    } catch (e) {
      Get.snackbar( "❌ Error", "Error verifying OTP: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+91 ",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              if (_otpSent)
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: "Enter OTP",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _otpSent ? _verifyOtp : _sendOtp,
                    child: Text(_otpSent ? "Verify OTP" : "Send OTP"),
                  ),
              if (_otpSent)
                TextButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: const Text("Resend OTP"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
