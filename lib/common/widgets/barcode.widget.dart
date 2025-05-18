import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodeWidget extends StatelessWidget {
  final String data;

  const BarcodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final barcode = Barcode.gs128();

    // Generate the SVG string
    final svg = barcode.toSvg(data, width: 500, height: 50, drawText: false);

    return SvgPicture.string(svg);
  }
}
