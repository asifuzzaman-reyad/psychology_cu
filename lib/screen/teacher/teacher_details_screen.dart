import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychology_cu/widget/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherDetailsScreen extends StatelessWidget {
  static const routeName = 'teacher_details_screen';

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          //
          body: Column(
            children: [

              //image
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Hero(
                    tag: argument.get('name'),
                    child: CachedNetworkImage(
                      imageUrl: argument.get('imageUrl'),
                      fadeInDuration: Duration(milliseconds: 500),
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, radius: 120,),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircleAvatar(radius: 120,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                      errorWidget: (context, url, error) => CircleAvatar(radius: 120,backgroundImage: AssetImage('assets/images/pp_placeholder.png')),
                    ),
                  ),
                ),
              ),

              // info
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8)],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 24),
                  child: Container(
                    child: Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                argument.get('name'),
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                argument.get('post'),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 4),
                              Text(
                                argument.get('phd') != ''
                                    ? argument.get('phd')
                                    : '',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Divider(height: 24),
                              Text(
                                "Mobile: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 4),
                              SelectableText(
                                argument.get('mobile'),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Email: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 4),
                              SelectableText(
                                argument.get('email'),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              Divider(height: 24),
                              Text(
                                "Field of Interest: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(height: 4),
                              Text(
                                argument.get('interest'),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),

                          //
                          SizedBox(height: 16),

                          //
                          Row(
                            children: [
                              //publication
                              Expanded(
                                child: argument.get('publication') == ''
                                    ? Text('')
                                    : MaterialButton(
                                      onPressed: () async{
                                        final url = argument.get('publication');
                                        //
                                              if (argument.get('publication') != '') {
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              } else {
                                                print('no publication found');
                                              }
                                      },
                                      color: Colors.black,
                                      padding: EdgeInsets.symmetric(vertical: 13),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        "Publication",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              ),

                              SizedBox(width: 10),

                              // mail
                              CustomButton(
                                type: 'mailto:',
                                link: argument.get('email'),
                                icon: Icons.mail,
                                color: Colors.red,
                                borderRadius: 8,
                              ),

                              SizedBox(width: 8),

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

                          //
                          // Container(
                          //   alignment: Alignment.bottomCenter,
                          //   child: InkWell(
                          //     onTap: () async {
                          //       final url = argument.get('publication');
                          //
                          //       if (argument.get('publication') == '') {
                          //         if (await canLaunch(url)) {
                          //           await launch(url);
                          //         }
                          //       } else {
                          //         print('no publication found');
                          //       }
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           child: Container(
                          //             alignment: Alignment.center,
                          //             height: 48,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(12),
                          //               color: Colors.black,
                          //             ),
                          //             child: Text(
                          //               "Publication",
                          //               style: TextStyle(
                          //                   fontSize: 18, color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
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
