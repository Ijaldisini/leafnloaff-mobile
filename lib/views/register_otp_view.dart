import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/register_otp_viewmodel.dart';
import '../models/user_model.dart';

class RegisterOtpView extends StatefulWidget {
  final UserModel user;

  const RegisterOtpView({super.key, required this.user});

  @override
  State<RegisterOtpView> createState() => _RegisterOtpViewState();
}

class _RegisterOtpViewState extends State<RegisterOtpView> {
  final RegisterOtpViewModel _viewModel = RegisterOtpViewModel();

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
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [Color(0xFFEAEAAA), Color(0xFF2D4839)],
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
                    ),
                  ),

                  Positioned(
                    top: 180,
                    child: SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Verifikasi Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Kami telah mengirimkan 8-digit kode OTP ke email:\n\n${widget.user.email}\n\nSilakan periksa kotak masuk atau folder spam Anda.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 400,
                    child: const Text(
                      'OTP Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 430,
                    child: SizedBox(
                      width: 275.5,
                      height: 38,
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
                    top: 520,
                    child: GestureDetector(
                      onTap: _viewModel.isLoading
                          ? null
                          : () => _viewModel.verifyOtp(context, widget.user),
                      child: Container(
                        width: 189,
                        height: 38,
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(108.57),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) => _viewModel.nextField(value, index),
      ),
    );
  }
}
