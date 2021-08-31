import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCard extends StatelessWidget {
  const LinkCard({
    required this.title,
    this.color,
    required this.link,
    required this.imageUrl,
  });
  final String title;
  final Color? color;
  final String link;
  final String imageUrl;

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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color ?? Colors.white,
              ),
              child: Image.asset(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
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
