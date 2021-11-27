import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd extends StatelessWidget {
  const MyBannerAd({Key? key, required this.banner, this.enableMargin})
      : super(key: key);
  final BannerAd? banner;
  final bool? enableMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (banner == null)
          const SizedBox(height: 0)
        else
          Container(
              height: 50,
              margin: enableMargin == true
                  ? const EdgeInsets.symmetric(vertical: 0)
                  : const EdgeInsets.symmetric(vertical: 8),
              child: AdWidget(ad: banner!))
      ],
    );
  }
}
