import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:psychology_cu/screen/notice/notice_screen.dart';

AppBar customAppbar(context) {
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
        Text.rich(
          TextSpan(
            text: 'PSYCHO',
            // style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'LOGY',
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
