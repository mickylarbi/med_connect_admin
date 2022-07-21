import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  final IconData? leading;
  final String? title;
  final List<Widget>? actions;
  const CustomAppBar({Key? key, this.leading, this.actions, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      width: kScreenWidth(context),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Stack(children: [
        if (leading != null)
          Align(
            alignment: Alignment.centerLeft,
            child: OutlineIconButton(
              iconData: leading!,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        if (title != null)
          Align(
            alignment: Alignment.center,
            child: HeaderText(text: title!),
          ),
        if (actions != null)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          )
      ]),
    );
  }
}

List<Widget> fancyAppBar(BuildContext context,
    ScrollController scrollController, String title, List<Widget> actions) {
  return [
    AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        return Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
          height: scrollController.offset <= 50
              ? 138 - scrollController.offset
              : 88,
          width: kScreenWidth(context),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Opacity(
            opacity: scrollController.offset <= 50
                ? scrollController.offset >= 0
                    ? (50 - scrollController.offset) / 50
                    : 1
                : 0,
            child: Text(
              //TODO: add filter icon
              title,
              style: TextStyle(
                fontSize: scrollController.offset < 0
                    ? 30 + (scrollController.offset.abs() * 0.05)
                    : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
    Align(
      alignment: Alignment.topCenter,
      child: AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            return Opacity(
              opacity: scrollController.offset <= 50
                  ? scrollController.offset >= 0
                      ? scrollController.offset / 50
                      : 0
                  : 1,
              child: Container(
                height: 88,
                alignment: Alignment.center,
                child: HeaderText(
                  text: title,
                ),
              ),
            );
          }),
    ),
    Positioned(
      right: 36,
      child: Container(
        height: 88,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlineIconButton(
              iconData: Icons.filter_list_alt,
              onPressed: () {},
            )
          ],
        ),
      ),
    )
  ];
}
