import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../shared/components/component.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(cubit. tasks[index]),
          separatorBuilder: ((context, index) => Container(
                height: 15,
              )),
          itemCount:cubit.tasks.length);
      },
     
    );
  }
}
