import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/features/my_matches/presentation/screens/mymatches_screen.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../my_matches/domain/model/myMatches_Model.dart';
import '../../cubit/home_cubit.dart';

class HomeMatchBody extends StatefulWidget {
  HomeMatchBody({
    super.key,
    this.type,
    this.areaId,
    this.data,
    this.playgrounds,
  });

  final String? type;
  final List<int>? playgrounds;
  final List<String>? data;
  final int? areaId;
  @override
  State<HomeMatchBody> createState() => _HomeMatchBodyState();
}

class _HomeMatchBodyState extends State<HomeMatchBody>
// with AutomaticKeepAliveClientMixin
{
  MyMatches myMatches = MyMatches();

  @override
  void initState() {
    HomeCubit.get(context).getMymatches(
      playgrounds: widget.playgrounds ?? [],
      data: widget.data ?? [],
      areaId: widget.areaId,
      type: widget.type,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is MyMatchesLoaded) myMatches = state.myMatches;
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            await cubit.getMymatches(
              type: widget.type,
            );
          },
          child: LoadingAndError(
            isLoading: state is MyMatchesLoading,
            isError: state is MyMatchesFailed,
            child: myMatches.matches?.isNotEmpty ?? false
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    itemCount: myMatches.matches?.length ?? 0,
                    itemBuilder: (context, index) => ItemWidget(
                      matchModel: myMatches.matches?[index],
                      ismymatch: true,
                    ),
                  )
                : EmptyMatchesBody(),
          ),
        );
      },
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
