import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Widgets {
  static void showAppDialog(
      {String? title,
      required String description,
      String? buttonText,
      Function? onPressed,
      bool isError = false,
      bool isCongrats = false}) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: isError
                  ? Text(
                      'opps'.tr,
                      style: AppTextStyle.boldStyle(
                        fontSize: 20,
                      ),
                    )
                  : isCongrats
                      ? Text(
                          'congratulation'.tr,
                          style: AppTextStyle.boldStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      : title != null
                          ? Text(
                              title,
                              style: AppTextStyle.boldStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )
                          : const SizedBox(),
            ),
            SizedBox(
              height: isError || isCongrats || title != null ? 12 : 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                style: AppTextStyle.regularStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: flatButtonStyle2,
              onPressed: onPressed as void Function()? ??
                  () async {
                    if (description == 'Unauthorized' ||
                        description == 'jwt expired') {
                      GetStorage().erase();
                    }
                    Get.back();
                  },
              child: Text(
                buttonText ?? 'close'.tr,
                style: AppTextStyle.regularStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

final ButtonStyle flatButtonStyle2 = TextButton.styleFrom(
  foregroundColor: Colors.white,
  minimumSize: const Size(
    88,
    40,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
    Radius.circular(6),
  )),
  backgroundColor: AppColors.primary,
);
