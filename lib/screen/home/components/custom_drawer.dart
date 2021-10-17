import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants.dart';
import '/widgets/custom_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
                  const Text('Developed by:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    height: 130,
                    width: 130,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.circular(8),
                        color: Colors.pink.shade100,
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/reyad.jpg'))),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    kDeveloperName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text('UX Designer & App Developer'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.orange[100],
                        ),
                        child: const Text(
                          kDeveloperBatch,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.greenAccent[100],
                        ),
                        child: const Text(
                          kDeveloperSession,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
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
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  const Divider(),
                  const Text('Contributor:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
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
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        await canLaunch(kFbGroup)
                            ? await launch(kFbGroup)
                            : throw 'Could not launch $kFbGroup';
                      },
                      icon: const Icon(Icons.help),
                      label: const Text('Help center'),
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
        const SizedBox(height: 8),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text('session: ' + session),
      ],
    );
  }
}
