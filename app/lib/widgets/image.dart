import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UniversalImage extends StatelessWidget {
  final String? type;
  final String? url;
  final double? height;
  final double? width;

  const UniversalImage({Key? key, this.type, this.url, this.height, this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var imageURL = "$url.$type";
    switch (type?.toLowerCase()) {
      case 'svg':
        return SvgPicture.network(imageURL, height: height, width: width);
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Image.network(imageURL, height: height, width: width);
    }
    return Container();
  }
}
