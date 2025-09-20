import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/item_of_contact.dart';

class AlertOfMedia extends StatelessWidget {
  const AlertOfMedia({
    super.key,
    required this.cameraTap,
    required this.galleryTap,
  });

  final void Function()? cameraTap;
  final void Function()? galleryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 38, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              cameraTap?.call();
            },
            child: ItemOfContact(
              title: 'Camera'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
          GestureDetector(
            onTap: () async {
              galleryTap?.call();
            },
            child: ItemOfContact(
              title: 'Gallery'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
        ],
      ),
    );
  }
}
