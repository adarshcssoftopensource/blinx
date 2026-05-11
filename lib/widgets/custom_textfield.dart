import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:flutter/material.dart';

import '../utils/screens/fonts.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  final bool obscureText;
  final bool showEyeIcon;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType,

    this.obscureText = false,
    this.showEyeIcon = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: Fonts.interMedium,
              color: ColorConstants.black,
            ),
          ),
          const SizedBox(height: 8),
        ],

        SizedBox(
          height: 48,
          width: double.infinity,
          child: TextField(
            controller: widget.controller,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: Fonts.interRegular,
              color: ColorConstants.greyColor,
            ),
            obscureText: widget.showEyeIcon ? _isObscured : widget.obscureText,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: Fonts.interRegular,
                height: 1.0,
                letterSpacing: 0.0,
                color: ColorConstants.lightGreyColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 0,
              ),
              suffixIcon: widget.showEyeIcon
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: ColorConstants.darkGreyColor,
                        size: 20,
                      ),
                      onPressed: _toggleObscure,
                    )
                  : null,
              filled: true,
              fillColor: ColorConstants.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: ColorConstants.white2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: ColorConstants.white2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
