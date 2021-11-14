import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    Key? key,
    required this.title,
    this.color,
    required this.link,
    required this.imageUrl,
    this.enableBorder,
  }) : super(key: key);

  final String title;
  final Color? color;
  final String link;
  final String imageUrl;
  final bool? enableBorder;

  void _launchURL() async => await canLaunch(link)
      ? await launch(link)
      : throw 'Could not launch $link';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (link == '') {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'No Link Found');
        } else {
          Fluttertoast.showToast(msg: 'Opening...');
          _launchURL();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: enableBorder == true
                ? Border.all(color: Colors.grey, width: .5)
                : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? Colors.transparent,
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: enableBorder == true ? 2 : 8),
              child: Text(
                title,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
