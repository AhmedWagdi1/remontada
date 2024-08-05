import 'package:animated_widgets_flutter/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/extentions.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';

///// put it in routes
///  import '../../modules/splash/presentation/splash.dart';
/// static const String splashScreen = "/splashScreen";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SplashCubit()..getPostion(),
        child: Scaffold(
          body: BlocConsumer<SplashCubit, SplashStates>(
            listener: (context, state) {},
            builder: (context, state) {
              final cubit = SplashCubit.get(context);
              return Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "Splash".png("images"),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OpacityAnimatedWidget.tween(
                      opacityEnabled: 1,
                      opacityDisabled: 0,
                      duration: const Duration(milliseconds: 3000),
                      enabled: true,
                      animationFinished: (finished) async {
                        final route = await cubit.checkLogin();

                        // Navigator.pushNamed(
                        //   context,
                        //   route,
                        // );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          route,
                          (route) => false,
                        );
                      },
                      child: SvgPicture.asset(
                        "logo".svg('icons'),
                        // width: 200,
                        // height: 250,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
