
import 'package:flutter/material.dart';
import 'package:psychology_cu/widget/custom_button.dart';

import '../../../constants.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerHeader(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Developed by:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Container(
                      height: 130,
                      width: 130,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(8),
                          color: Colors.pink.shade100,
                          image: DecorationImage(image: NetworkImage(profileImage))),
                    ),
                    SizedBox(height: 16),

                    Text(
                      kDeveloperName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text('Ux designer, App developer'),
                    SizedBox(height: 8),
                    Text(kDeveloperBatch),
                    SizedBox(height: 4),
                    Text('Session: ' + kDeveloperSession),

                    SizedBox(height: 32),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mobile:',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 4),
                        Text(
                          kDeveloperMobile,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email:',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 4),
                        SelectableText(
                          kDeveloperEmail,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Facebook',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 4),
                        SelectableText(
                          'fb.com/asifuzzaman.reyad',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8),
            //
            Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //call
                  CustomButton(type: 'tel:', link: kDeveloperMobile, icon: Icons.call, color: Colors.green),

                  SizedBox(width: 8),

                  //mail
                  CustomButton(type: 'mailto:', link: kDeveloperEmail, icon: Icons.mail, color: Colors.red),

                  SizedBox(width: 8),

                  //facebook
                  CustomButton(type: '', link: kDeveloperFb, icon: Icons.facebook, color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
