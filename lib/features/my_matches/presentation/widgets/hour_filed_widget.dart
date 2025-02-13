import 'package:flutter/material.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class HpurFieldWidget extends StatefulWidget {
  const HpurFieldWidget({
    super.key,
    this.onTimeChanged,
    this.title,
  });
  final Function(int hour, int minute)? onTimeChanged;
  final String? title;

  @override
  State<HpurFieldWidget> createState() => _HpurFieldWidgetState();
}

class _HpurFieldWidgetState extends State<HpurFieldWidget> {
  int _hour = 12;
  int _minute = 0;

  void _incrementHour() {
    setState(() {
      _hour = (_hour + 1) % 24;
      widget.onTimeChanged!(_hour, _minute);
    });
  }

  void _decrementHour() {
    setState(() {
      _hour = (_hour - 1) < 0 ? 23 : _hour - 1;
      widget.onTimeChanged!(_hour, _minute);
    });
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 1) % 60;
      widget.onTimeChanged!(_hour, _minute);
    });
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 1) < 0 ? 59 : _minute - 1;
      widget.onTimeChanged!(_hour, _minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 20,
      ),
      // height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: LightThemeColors.border,
        ),
        borderRadius: BorderRadius.circular(
          19,
        ),
      ),
      // height: 65,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(widget.title ?? ""),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _incrementHour,
                      child: const Icon(Icons.keyboard_arrow_up_outlined),
                    ),
                    Text(
                      _hour.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _decrementHour,
                      child: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                    ),
                  ],
                ),
                10.pw,
                const Text(
                  ':',
                  style: TextStyle(fontSize: 14),
                ),
                10.pw,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _incrementMinute,
                      child: const Icon(Icons.keyboard_arrow_up_outlined),
                    ),
                    Text(
                      _minute.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _decrementMinute,
                      child: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                    ),
                  ],
                ),
                20.pw,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
