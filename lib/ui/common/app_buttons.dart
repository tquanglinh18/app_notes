import 'package:flutter/material.dart';


class AppButtons extends StatelessWidget {
  final String urlBtn;
  final bool active;
  final Function() onTap;

  const AppButtons({
    Key? key,
    required this.urlBtn,
    this.active = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: active ? onTap : null,
      child: Image.asset(urlBtn),
    );
  }
}
