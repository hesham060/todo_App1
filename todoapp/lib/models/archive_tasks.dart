import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/component.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
      var tasks = AppCubit.get(context).archivedTasks;
        return ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
            separatorBuilder: ((context, index) => Container(
                  height: 15,
                )),
            itemCount: tasks.length);
      },
    );
    
  }
}