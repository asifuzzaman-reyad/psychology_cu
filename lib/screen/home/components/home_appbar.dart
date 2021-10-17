import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/screen/notice/notice_screen.dart';

AppBar homeAppbar(context) {
  return AppBar(
    elevation: 0,
    titleSpacing: 8,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/icons/menu.svg',
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        const Text.rich(
          TextSpan(
            text: 'PSY ',
            // style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'ASSISTANT',
                style: TextStyle(color: Colors.orange),
              )
            ],
          ),
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
          maxLines: 1,
        ),
        IconButton(
            icon: SvgPicture.asset(
              'assets/icons/bell.svg',
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              print("notification");

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NoticeScreen()));
            }),
      ],
    ),
  );
}
