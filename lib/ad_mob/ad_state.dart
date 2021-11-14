import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);

  //demo banner unit id
  // String get bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111';
  //original ad unit
  String get bannerAdUnitId => 'ca-app-pub-7506553655513676/5201854706';

  // ad  listener
  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdImpression: (ad) => print('Ad impressed: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) =>
        print('Ad screen dismissed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, error:$error.'),
  );
}
