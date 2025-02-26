import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';

class GroupBody extends StatefulWidget {
  const GroupBody({
    super.key,
    this.areaId,
    this.data,
    this.playgroundId,
    this.itemGroupe,
  });
  final List<int>? playgroundId;
  final List<String>? data;
  final int? areaId;
  final bool? itemGroupe;
  @override
  State<GroupBody> createState() => _GroupBodyState();
}

class _GroupBodyState extends State<GroupBody> {
  HomeModel homeModel = HomeModel();

  @override
  void initState() {
    HomeCubit.get(context).getGroupeMatches(
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
        if (state is GroupMatchesLoaded) homeModel = state.homeModel;
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
              isHomeGroupe: true,
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

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
