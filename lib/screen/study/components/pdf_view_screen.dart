import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewScreen extends StatefulWidget {
  final String fileUrl;
  final String title;

  const PdfViewScreen({Key? key, required this.fileUrl, required this.title})
      : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  //TODO: fix lost orientation issue

  // allow to change orientation
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //
  //     // DeviceOrientation.landscapeRight,
  //     // DeviceOrientation.landscapeLeft,
  //   ]);
  // }

  // dispose to return portrait mode
  // @override
  // dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool darkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: pdfView(widget.fileUrl, darkMode),
    );
  }
}

// pdf view
Widget pdfView(String fileUrl, bool darkMode) {
  return PDF(
    enableSwipe: true,
    autoSpacing: false,
    fitEachPage: true,
    pageFling: false,
    nightMode: darkMode ? true : false,
    fitPolicy: FitPolicy.BOTH,
  ).cachedFromUrl(
    fileUrl,
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
  );
}
