import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: pdfView(widget.fileUrl),
    );
  }
}

//
Widget pdfView(String fileUrl) {
  return PDF(autoSpacing: false).cachedFromUrl(
    fileUrl,
    placeholder: (double progress) => Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(),
              Text('$progress'),
            ],
          ),
          SizedBox(width: 12),
          Text('Loading ...'),
        ],
      ),
    ),
    errorWidget: (dynamic error) => Center(child: Text(error.toString())),
  );
}
