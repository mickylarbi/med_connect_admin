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


// class RoundedRectangularIconButton extends StatelessWidget {
//   final IconData iconData;
//   final void Function()? onPressed;
//   const RoundedRectangularIconButton(
//       {Key? key, required this.iconData, required this.onPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blueGrey),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: onPressed,
//         child: Center(
//           child: Icon(iconData),
//         ),
//       ),
//     );
//   }
// }