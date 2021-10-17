import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomButton extends StatelessWidget {
  // different types of button function
  // tel:
  // sms:
  // 'mailto'
  // link -> ''

  final String type;
  final String link;
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final double? borderRadius;

  const CustomButton(
      {Key? key,
      required this.type,
      required this.link,
      required this.icon,
      required this.color,
      this.iconColor,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 32,
      onPressed: () async {
        if (link != '') {
          final _url = '$type$link';
          await canLaunch(_url)
              ? await launch(_url)
              : throw 'Could not launch $_url';
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'No data found');
        }
      },
      elevation: 4,
      color: color,
      child: Icon(
        icon,
        size: 24,
        color: iconColor ?? Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      shape: borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!))
          : const CircleBorder(),
    );
  }
}
