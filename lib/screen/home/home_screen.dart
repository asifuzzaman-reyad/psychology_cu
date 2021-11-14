import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '/ad_mob/ad_state.dart';
import '/ad_mob/my_banner_ad.dart';
import '../home/components/custom_drawer.dart';
import '../home/components/home_appbar.dart';
import '../home/header.dart';
import 'components/categories.dart';
import 'components/drive_collections.dart';
import 'components/important_links.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

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

                //banner
                MyBannerAd(banner: banner),

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
