import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfScreen extends StatelessWidget {
  final String? pdfLocation;
  const PdfScreen({super.key, this.pdfLocation});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text("PDF"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PDFView(
          filePath: pdfLocation,
          fitPolicy: FitPolicy.BOTH, // Fit PDF to both width and height
        ),
      ),
    );
  }
}
