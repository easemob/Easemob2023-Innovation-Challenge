import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  final logic = Get.put(UserLogic());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          child: ElevatedButton(onPressed: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: const Text("关于我们"),
                content: const Text("RIck and Morty 100 years! Wubba lubba dub dub"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("确认"),
                    onPressed: () {
                      Navigator.of(context).pop(true); //关闭对话框
                    },
                  ),
                ],
              );
            });
          }, child: const Text("关于我们")),
        ),
        Container(
          width: double.maxFinite,
          child: ElevatedButton(onPressed: (){
            logic.logout();
          }, child: const Text("退出登录")),
        )
      ],
    );
  }
}
