import 'package:flutter/material.dart';
import 'package:whisper/utils/universal_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  CustomAppBar({
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
              color: UniversalVariables.separatorColor,
              width: 1.4,
              style: BorderStyle.solid),
        ),
      ),
      child: AppBar(
        brightness: Brightness.dark,
        backgroundColor: UniversalVariables.blackColor,
        title: title,
        elevation: 0,
        leading: leading,
        centerTitle: centerTitle,
        actions: actions,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
