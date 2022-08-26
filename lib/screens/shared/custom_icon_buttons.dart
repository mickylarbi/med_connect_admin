import 'package:flutter/material.dart';

class OutlineIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onPressed;
  final Color? backgroundColor;
  const OutlineIconButton(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Icon(iconData),
        ),
      ),
    );
  }
}

class SolidIconButton extends StatelessWidget {
  final Color? color;
  final IconData iconData;
  final void Function()? onPressed;
  const SolidIconButton(
      {Key? key, required this.iconData, required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color != null ? color!.withOpacity(.2) : Colors.blueGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Center(
          child: Icon(iconData, color: color ?? Colors.white),
        ),
      ),
    );
  }
}
