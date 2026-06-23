import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/register_otp_viewmodel.dart';
import '../models/user_model.dart';
import 'cust/main_view.dart';

class RegisterOtpView extends StatefulWidget {
  final UserModel user;

  const RegisterOtpView({super.key, required this.user});

  @override
  State<RegisterOtpView> createState() => _RegisterOtpViewState();
}

class _RegisterOtpViewState extends State<RegisterOtpView> {
  final RegisterOtpViewModel _viewModel = RegisterOtpViewModel();

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Color(0xFFC23437)),
              SizedBox(width: 10),
              Text(
                'Peringatan',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC23437),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleVerify() async {
    final success = await _viewModel.verifyOtp(
      widget.user,
      onError: _showErrorDialog,
    );
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verifikasi Email Berhasil!',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Color(0xFF426E55),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerMainView(user: widget.user),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFEF9C3),
                    Color(0xFF84A98C),
                    Color(0xFF52796F),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 82,
                    child: Container(
                      width: 255,
                      height: 38,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(108.57),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD699AB),
                                    Color(0xFFCA748D),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(88.35),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFEED5DB),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEED5DB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(88.35),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFCA748D),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 130,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned(
                    top: 345,
                    left: 20,
                    child: const Text(
                      'OTP Code',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.10,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 376,
                    child: SizedBox(
                      width: 376,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          8,
                          (index) => _buildOtpBox(index),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 430,
                    child: SizedBox(
                      width: 226,
                      child: Opacity(
                        opacity: 0.80,
                        child: const Text(
                          'Open your Email and enter the code you received.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFDFDFD),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight:
                                FontWeight.w600,
                            height: 1.10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 520,
                    child: GestureDetector(
                      onTap: _viewModel.isLoading ? null : _handleVerify,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 200,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _viewModel.isLoading
                                ? [
                                    const Color(0xFFD699AB).withOpacity(0.6),
                                    const Color(0xFFCA748D).withOpacity(0.6),
                                  ]
                                : const [Color(0xFFD699AB), Color(0xFFCA748D)],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCA748D).withOpacity(0.45),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _viewModel.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: TextField(
        controller: _viewModel.otpControllers[index],
        focusNode: _viewModel.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(
          color: Color(0xFF2D4839),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w900,
        ),
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) => _viewModel.nextField(value, index),
      ),
    );
  }
}
