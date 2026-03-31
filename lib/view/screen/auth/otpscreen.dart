import 'package:flutter/material.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/custom_appar_widget.dart';
import 'package:transport_project/view/widget/custom_auth_button_widget.dart';

class VerifyOTPScreen extends StatelessWidget {
  const VerifyOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [AppColor.primaryColor, AppColor.secondaryColor]
                    : [AppColor.primaryColorL, AppColor.secondaryColorL],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Verify OTP",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter the 6-digit code sent to +1 (555)\n123-4567",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.hintColor),
                ),
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => _buildOTPBox(
                      context,
                      first: index == 0,
                      last: index == 5,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "01:59",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child:  Text(
                    "Resend Code ↻",
                     style: TextStyle(color: theme.hintColor),
                  ),
                ),

                const Spacer(),

                CustomAuthButton(text: "Verify and Continue", onPressed: () {}),

                const SizedBox(height: 20),

                // _buildHelpCard(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(
    BuildContext context, {
    bool first = false,
    bool last = false,
  }) {
        final theme = Theme.of(context);

    return SizedBox(
      width: 48,
      height: 58,
      child: TextFormField(
        autofocus: first,
        onChanged: (value) {
          if (value.length == 1 && !last) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && !first) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor:  theme.brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
