import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../bookmarks/study_bookmark_button.dart';

class PdfViewScreen extends StatefulWidget {
  final String fileUrl;
  final String title;

  const PdfViewScreen({Key? key, required this.fileUrl, required this.title})
      : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    //
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('No Internet Connection'),
          action: SnackBarAction(
            onPressed: () async {
              await AppSettings.openDeviceSettings();
            },
            label: 'Connect',
          ),
        ));
      } else {
        print('network status: $_connectionStatus');
      }
    });
  }

  // TODO: update orientation method
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // dispose to return portrait mode
  @override
  dispose() {
    //
    _connectivitySubscription.cancel();

    //
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.portrait
          ? buildAppBar()
          : null,
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? PdfViewPortrait(url: widget.fileUrl, darkMode: isDarkMode)
          : PdfViewLandScape(url: widget.fileUrl, darkMode: isDarkMode),
    );
  }

  // pdf view app bar
  AppBar buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      actions: const [
        // study bookmark
        StudyBookmarkButton(),

        SizedBox(width: 8),
      ],
    );
  }
}

// pdf viewer portrait
class PdfViewPortrait extends StatefulWidget {
  const PdfViewPortrait({Key? key, required this.url, required this.darkMode})
      : super(key: key);

  final String url;
  final bool darkMode;

  @override
  _PdfViewPortraitState createState() => _PdfViewPortraitState();
}

class _PdfViewPortraitState extends State<PdfViewPortrait> {
  @override
  Widget build(BuildContext context) {
    return PDF(
      enableSwipe: true,
      autoSpacing: false,
      fitEachPage: true,
      pageFling: false,
      nightMode: widget.darkMode ? true : false,
      fitPolicy: FitPolicy.BOTH,
    ).cachedFromUrl(
      widget.url,
      placeholder: (double progress) => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(),
                Text(progress.toStringAsFixed(0)),
              ],
            ),
            const SizedBox(width: 12),
            const Text('Loading ...'),
          ],
        ),
      ),
      errorWidget: (dynamic error) => const Center(
        child: Text(
          'Try again\nor\nCheck your internet connection',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// pdf viewer landscape
class PdfViewLandScape extends StatefulWidget {
  const PdfViewLandScape({Key? key, required this.url, required this.darkMode})
      : super(key: key);

  final String url;
  final bool darkMode;

  @override
  _PdfViewLandScapeState createState() => _PdfViewLandScapeState();
}

class _PdfViewLandScapeState extends State<PdfViewLandScape> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDF(
        enableSwipe: true,
        autoSpacing: false,
        fitEachPage: true,
        pageFling: false,
        nightMode: widget.darkMode ? true : false,
        fitPolicy: FitPolicy.WIDTH,
      ).cachedFromUrl(
        widget.url,
        placeholder: (double progress) => Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text(progress.toStringAsFixed(0)),
                ],
              ),
              const SizedBox(width: 12),
              const Text('Loading ...'),
            ],
          ),
        ),
        errorWidget: (dynamic error) => const Center(
          child: Text(
            'Check your internet connection\nor\nTry again',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
