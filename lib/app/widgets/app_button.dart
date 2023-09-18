import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/utils/text_style.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Widget? icon;
  final double? buttonWidth;
  final bool enabled;
  final Color? buttonColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? minwidthh;
  final double? minlength;
  final double? verticalPaddingg;
  final double? elevation;
  final double? radiusb;
  final double? textSize;

  final Color? borderclr;
  final FocusNode? focusNode;

  AppButton(
      {this.buttonWidth,
      required this.title,
      this.buttonColor,
      this.radiusb,
      this.borderclr,
      this.minlength,
      this.minwidthh,
      this.textSize,
      this.enabled = true,
      required this.onPressed,
      this.icon,
      this.verticalPaddingg,
      this.textColor,
      this.elevation,
      this.padding,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(20.0),
      child: ButtonTheme(
        minWidth: buttonWidth == 0.0 ? 0.0 : 40,
        child: ElevatedButton(
          focusNode: focusNode,
          onPressed: enabled ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor == null
                ? enabled
                    ? AppColors.primary
                    : Colors.grey
                : enabled
                    ? buttonColor
                    : Colors.grey),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: radiusb == null
                    ? BorderRadius.circular(14)
                    : BorderRadius.circular(radiusb!))),
            side: MaterialStateProperty.all(BorderSide(
              color: borderclr == null ? Colors.transparent : borderclr!,
            )),
            minimumSize: minwidthh == null && minlength == null
                ? MaterialStateProperty.all(Size(146, 56))
                : MaterialStateProperty.all(Size(minwidthh!, minlength!)),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Padding(
            padding: verticalPaddingg == null
                ? EdgeInsets.symmetric(vertical: 15)
                : EdgeInsets.symmetric(vertical: verticalPaddingg!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null ? SizedBox() : icon!,
                Text(
                  title,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: AppTextStyle.semiBoldStyle(
                      fontSize: textSize == null ? 16 : textSize,
                      color: textColor == null ? Colors.white : textColor!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
