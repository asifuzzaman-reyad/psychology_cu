import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widget/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerHeader(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Developed by:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Container(
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(8),
                        color: Colors.pink.shade100,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/reyad.jpg'))),
                  ),
                  SizedBox(height: 16),
                  Text(
                    kDeveloperName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text('UX Designer & App Developer'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.orange[100],
                        ),
                        child: Text(
                          kDeveloperBatch,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.greenAccent[100],
                        ),
                        child: Text(
                          kDeveloperSession,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //call
                        CustomButton(
                            type: 'tel:',
                            link: kDeveloperMobile,
                            icon: Icons.call,
                            color: Colors.green),

                        SizedBox(width: 8),

                        //mail
                        CustomButton(
                            type: 'mailto:',
                            link: kDeveloperEmail,
                            icon: Icons.mail,
                            color: Colors.red),

                        SizedBox(width: 8),

                        //facebook
                        CustomButton(
                            type: '',
                            link: kDeveloperFb,
                            icon: Icons.facebook,
                            color: Colors.blue),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Text('Contributor:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      // mainAxisSpacing: 8,
                      childAspectRatio: 1.3,
                      children: [
                        contributorCard('Khadija Ujma', '16-17', 'ujma.jpg'),
                        contributorCard('Bibi Hazera', '18-19', 'hazera.jpg'),
                        contributorCard(
                            'Afzal Hossain Hridoy', '17-18', 'hridoy.jpg'),
                        contributorCard(
                            'Azizul Hakim Shojol', '17-18', 'sojol.jpg'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        await canLaunch(kFbGroup)
                            ? await launch(kFbGroup)
                            : throw 'Could not launch $kFbGroup';
                      },
                      icon: Icon(Icons.help),
                      label: Text('Help center'),
                    ),
                  ),
                  // SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  Widget contributorCard(String name, String session, String imageName) {
    return Column(
      children: [
        CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/' + imageName)),
        SizedBox(height: 8),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Text('session: ' + session),
      ],
    );
  }
}
