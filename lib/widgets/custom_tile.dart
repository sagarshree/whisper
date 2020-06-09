import 'package:flutter/material.dart';
import 'package:whisper/utilities/universal_constants.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subTitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  CustomTile({
    @required this.leading,
    this.title,
    this.icon,
    @required this.subTitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.mini = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: UniversalVariables.separatorColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),
                            subTitle,
                          ],
                        )
                      ],
                    ),
                    // following means trailing != null ? trailing : Container(),
                    trailing ?? Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}