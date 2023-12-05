import 'package:flutter/material.dart';

@immutable
class UnknownRoutePage extends StatelessWidget{
  const UnknownRoutePage({
    Key? key  // 接收一个text参数
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("业务暂未实现"),),
      body: const Center(
        child: Text("业务暂未实现,请耐心等待"),
      ),
    );
  }

}