import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline({required this.title, this.noLeftPadding});
  final String title;
  final bool? noLeftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(noLeftPadding == true ? 0: 8,8,8,8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          // color: Colors.black87,
        ),
      ),
    );
  }
}
