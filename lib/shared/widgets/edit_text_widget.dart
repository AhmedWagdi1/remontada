import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/all_extensions.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? hintText, label, errorText;
  final TextInputType type;
  bool password = false;
  final bool expanded;
  final Color activeBorderColor, borderColor, backgroundColor, hintColor;
  final bool floatingHint;
  final int? maxLines;
  final int? minLines;
  final void Function()? onTap;
  FocusNode? focusNode;
  TextAlign textalign;
  int? maxLengh;
  TextDirection? textdirection;
  EdgeInsetsDirectional? contentPadding;
  double borderRadius;
  double? hintSize;
  String? prefixIcon;
  Widget? suffixIcon, suffixWidget, prefixWidget;
  TextEditingController? controller;
  InputDecoration? inputDecoration;
  ValueChanged<String>? onChanged;
  ValueChanged<String?>? onSaved;
  String? Function(String?)? validator;
  bool? isOutline;
  bool? enable;
  bool? readOnly;

  TextFormFieldWidget({
    this.onChanged,
    this.onSaved,
    this.isOutline,
    this.readOnly,
    this.hintSize,
    this.enable,
    this.validator,
    this.onTap,
    this.prefixWidget,
    this.password = false,
    this.expanded = false,
    this.floatingHint = false,
    this.type = TextInputType.text,
    this.hintText = "",
    this.label,
    this.textalign = TextAlign.start,
    this.maxLengh,
    this.errorText,
    this.controller,
    this.activeBorderColor = const Color(0x058A8C95),
    this.borderRadius = 8.0,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.hintColor = const Color(0xffA1A7AD),
    this.maxLines,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.inputDecoration,
    this.contentPadding,
    this.textdirection,
    super.key,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool passHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      cursorColor: context.colorScheme.primary,
      readOnly: widget.readOnly ?? false,
      enabled: widget.enable ?? true,
      validator: widget.validator,
      maxLength: widget.maxLengh,
      focusNode: widget.focusNode,
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      textAlign: widget.textalign,
      textDirection: widget.textdirection,
      style: context.bodySmall?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: widget.inputDecoration ??
          InputDecoration(
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 22.h,
                  horizontal: 40.3.w,
                ),
            // filled: true,
            fillColor: context.formFieldColor,
            prefixIcon:
                widget.prefixIcon?.toSvg(color: context.bodySmall?.color),
            prefix: widget.prefixWidget,
            suffix: widget.suffixWidget,
            suffixIcon: widget.suffixIcon ??
                (widget.password
                    ? IconButton(
                        onPressed: () =>
                            setState(() => passHidden = !passHidden),
                        icon: Icon(
                          passHidden
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off,
                          color: context.colorScheme.primary.withOpacity(.5),
                        ),
                      )
                    : null),
            errorText: widget.errorText,
            // helperText: "",
            border: borderType(),
            focusedBorder: borderType(),
            enabledBorder: borderType(),
            errorBorder: borderType(),
            hintStyle: TextStyle(
              color: widget.hintColor,
              fontSize: widget.hintSize ?? 14,
              fontWeight: FontWeight.w400,
            ),
            hintText: widget.hintText,
          ),
      keyboardType: widget.type,
      obscureText: passHidden && widget.password,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onTap: () => widget.onTap?.call(),
    );
  }

  InputBorder borderType() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: widget.activeBorderColor, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(widget.borderRadius),
      ),
    );
  }
}
