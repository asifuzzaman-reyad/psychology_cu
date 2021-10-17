import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/widgets/custom_button.dart';

class TeacherDetailsScreen extends StatelessWidget {
  static const routeName = 'teacher_details_screen';

  const TeacherDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          body: Column(
            children: [
              //image
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Hero(
                    tag: argument.get('name'),
                    child: CachedNetworkImage(
                      imageUrl: argument.get('imageUrl'),
                      fadeInDuration: const Duration(milliseconds: 500),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 120,
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CircleAvatar(
                                  radius: 120,
                                  backgroundImage: AssetImage(
                                      'assets/images/pp_placeholder.png')),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          radius: 120,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png')),
                    ),
                  ),
                ),
              ),

              // info
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 8)
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              argument.get('name'),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              argument.get('post'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              argument.get('phd') != ''
                                  ? argument.get('phd')
                                  : '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                            const Divider(height: 24),
                            const Text(
                              "Mobile: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              argument.get('mobile'),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Email: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              argument.get('email'),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                            const Divider(height: 24),
                            const Text(
                              "Field of Interest: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              argument.get('interest'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),

                        //
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .1),

                        //
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              //publication
                              Expanded(
                                child: argument.get('publication') == ''
                                    ? const Text('')
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6))),
                                        onPressed: () async {
                                          final url =
                                              argument.get('publication');
                                          //
                                          if (argument.get('publication') !=
                                              '') {
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            }
                                          } else {
                                            print('no publication found');
                                          }
                                        },
                                        // color: Colors.black,
                                        // padding: const EdgeInsets.symmetric(
                                        //     vertical: 13),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(8)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(13),
                                          child: Text(
                                            "Publication",
                                            style: TextStyle(
                                              fontSize: 16,
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),

                              const SizedBox(width: 10),

                              // mail
                              CustomButton(
                                type: 'mailto:',
                                link: argument.get('email'),
                                icon: Icons.mail,
                                color: Colors.red,
                                borderRadius: 8,
                              ),

                              const SizedBox(width: 8),

                              //call
                              CustomButton(
                                type: 'tel:',
                                link: argument.get('mobile'),
                                icon: Icons.call,
                                color: Colors.green,
                                borderRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
