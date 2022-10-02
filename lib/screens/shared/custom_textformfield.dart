import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final Widget? suffix;
  final Widget? prefix;

  const CustomTextFormField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.keyboardType,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.minLines = 1,
      this.maxLines = 1,
      this.onFieldSubmitted,
      this.onChanged,
      this.focusNode,
      this.initialValue,
      this.suffix,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      focusNode: focusNode,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        filled: true,
        fillColor: const Color(0xFFE4E4E4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffix: suffix,
        prefix: prefix,
      ),
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  const PasswordTextFormField({
    Key? key,
    this.hintText = 'Password',
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: obscureText,
        builder: (context, value, child) {
          return TextFormField(
            controller: widget.controller,
            obscureText: value,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                filled: true,
                fillColor: const Color(0xFFE4E4E4),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                suffixIcon: IconButton(
                    icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    })),
          );
        });
  }

  @override
  void dispose() {
    obscureText.dispose();
    super.dispose();
  }
}

class PrefixTextFormField extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  const PrefixTextFormField(
      {Key? key,
      required this.hintText,
      required this.iconData,
      this.keyboardType,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        filled: true,
        fillColor: const Color(0xFFE4E4E4),
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
