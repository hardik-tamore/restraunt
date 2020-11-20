import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Function onPressed;
  final Color splashColor;

  const TransparentButton({
    Key key,
    @required this.child,
    this.width,
    this.height = 50.0,
    this.splashColor = Colors.black12,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
            onTap: onPressed,
            splashColor: splashColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),
          );
  }
}