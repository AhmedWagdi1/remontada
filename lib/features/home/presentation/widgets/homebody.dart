import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';

class Homebody extends StatefulWidget {
  const Homebody({super.key, this.areaId, this.data, this.playgroundId});
  final List<int>? playgroundId;
  final List<String>? data;
  final int? areaId;
  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody>
    with AutomaticKeepAliveClientMixin {
  HomeModel homeModel = HomeModel();

  @override
  void initState() {
    HomeCubit.get(context).getHomeData(
      playgrounds: widget.playgroundId ?? [],
      data: widget.data ?? [],
      areaId: widget.areaId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeDataLoaded) homeModel = state.homeModel;
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return ListView.builder(
          itemCount: homeModel.match?.length ?? 0,
          itemBuilder: (context, index) {
            return
                // int.parse(homeModel.match?[index].constSub ??
                //             "") ==
                //         20
                //     ?
                ItemWidget(
              cubit: cubit,
              matchModel: homeModel.match?[index],
              ismymatch: false,
            );
            // : SizedBox();
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
