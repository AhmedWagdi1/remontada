import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/my_matches/presentation/screens/mymatches_screen.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.index});
  final int? index;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..initTabBar(this, widget.index ?? 0),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = LayoutCubit.get(context);
          return Scaffold(
            body: TabBarView(
              controller: cubit.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                MyMatchesScreen(),
                Container(),
                Container(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: cubit.tabController.index,
              onTap: cubit.changeTab,
            ),
            extendBody: true,
          );
        },
      ),
    );
  }
}

// class DiagonalLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 4.0;

//     final startPoint = Offset(378, 0); // نقطة البداية
//     final endPoint = Offset(129.39, 681.61); // نقطة النهاية

//     canvas.drawLine(startPoint, endPoint, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
