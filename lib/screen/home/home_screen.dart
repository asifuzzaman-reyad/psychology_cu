import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../home/components/custom_drawer.dart';
import '../home/components/home_appbar.dart';
import '../home/header.dart';
import 'components/categories.dart';
import 'components/important_links.dart';
import 'drive_collections.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(context),
      drawer: const CustomDrawer(),
      body: Scrollbar(
        radius: const Radius.circular(8),
        interactive: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // header
                Header(),

                const SizedBox(height: 24),

                // categories
                const Categories(),

                const SizedBox(height: 24),

                //important links
                const ImportantLinks(),

                const SizedBox(height: 24),

                //drive links
                const DriveCollections(),

                // collections
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// collection links
