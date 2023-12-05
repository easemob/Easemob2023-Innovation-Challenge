

import 'package:flutter/material.dart';
import 'package:third_party_base_example/app/router_name.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ElevatedButton(child:  const Text("1234"),onPressed: (){
            Navigator.of(context).pushNamed(RouterName.two);
          },),
        );
  }

}