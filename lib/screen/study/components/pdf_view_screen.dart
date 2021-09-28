import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({required this.fileUrl, required this.title});
  final String fileUrl;
  final String title;

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

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
    pageFling: false,
    nightMode: darkMode? true : false,
    fitEachPage: true,
    // fitPolicy: FitPolicy.BOTH,
  ).cachedFromUrl(
    fileUrl,
    placeholder: (double progress) => Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(),
              Text('${progress.toStringAsFixed(0)}'),
            ],
          ),
          SizedBox(width: 12),
          Text('Loading ...'),
        ],
      ),
    ),
    errorWidget: (dynamic error) => Center(
        child: Text(
      'Fail to load file. Try again or\nCheck your internet connection',
      textAlign: TextAlign.center,
    ),),
  );
}
