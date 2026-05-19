import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../viewmodels/register_otp_viewmodel.dart';
import '../models/user_model.dart';
import 'login_view.dart';

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
    final String otpUri =
        'otpauth://totp/LeafNLoaf:${widget.user.email}?secret=${widget.user.otpSecret}&issuer=LeafNLoaf';

    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Container(
              width: 390,
              height: 844,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [Color(0xFFEAEAAA), Color(0xFF2D4839)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 68,
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
                    left: 135,
                    top: 180,
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: otpUri,
                        version: QrVersions.auto,
                        size: 110.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF2D4839),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Color(0xFF2D4839),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 58,
                    top: 350,
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
                    left: 57,
                    top: 376,
                    child: SizedBox(
                      width: 275.5,
                      height: 38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _buildOtpBox(index),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 101,
                    top: 494,
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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
