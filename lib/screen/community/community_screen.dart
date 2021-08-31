import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  static const routeName = 'community_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Screen'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text('Update coming soon...'),
      ),
    );
  }
}
