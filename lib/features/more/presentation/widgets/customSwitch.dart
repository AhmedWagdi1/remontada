import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 33.07,
                width: 33.61,
              ),
              Container(
                width: 45,
                height: 16.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: _circleAnimation!.value == Alignment.centerLeft
                      ? LightThemeColors.surface
                      : LightThemeColors.switchBackground,
                ),
                // child: Padding(
                //   padding: const EdgeInsets.only(
                //       top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
                //   child:
                // ),
              ),
              Positioned(
                right: widget.value == false ? 0 : null,
                left: widget.value == true ? 0 : null,
                child: Container(
                  alignment: widget.value
                      ? ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerRight
                          : Alignment.centerLeft)
                      : ((Directionality.of(context) == TextDirection.rtl)
                          ? Alignment.centerLeft
                          : Alignment.centerRight),
                  child: Container(
                    width: 16.07,
                    height: 16.07,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: context.background,
                      ),
                      shape: BoxShape.circle,
                      color: LightThemeColors.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
