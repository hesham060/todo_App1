import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

Widget defaultTextFormField(
        {String? Function(String?)? validate,
        required TextEditingController controller,
        void Function(void)? onSubmit,
        void Function(void)? onChanged,
        required IconData? iconData,
        required String labelText,
        IconData? suffixIcon,
        VoidCallback? suffixPressed,
        VoidCallback? ontap,
        TextInputType? type,
        bool isClicable = true}) =>
    TextFormField(
      onTap: ontap,
      validator: validate,
      controller: controller,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixPressed,
              )
            : null,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabled: isClicable,
      ),
    );
Widget buildTaskItem(Map model, context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(
                  '${model['time']}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model['title']}',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateData(status: 'done', id: model['id']);
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {

                    AppCubit.get(context).updateData(status: 'archive', id: model['id']) ;
                  },
                  icon: Icon(
                    Icons.archive,
                    color: Colors.black45,
                  )),
            ],
          ),
        ],
      ),
    );
