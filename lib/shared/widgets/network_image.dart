import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/all_extensions.dart';
import '../../core/utils/extentions.dart';
import 'shimer_loading_items.dart';

class NetworkImagesWidgets extends StatelessWidget {
  const NetworkImagesWidgets(this.url,
      {super.key, this.fit, this.width, this.height, this.radius = 0});
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: url != ''
          ? CachedNetworkImage(
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  LoadingImage(w: width, h: double.infinity)
                      .paddingAll(0.w)
                      .center(),
              fit: fit,
              imageUrl: url,
              errorWidget: (context, _, __) =>
                  Image.asset("logo".png("icons"), fit: BoxFit.contain),
            ).cornerRadiusWithClipRRect(radius)
          : Image.asset("logo".png('icons'), fit: BoxFit.contain),
    );
  }
}
