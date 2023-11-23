

import 'package:flutter/material.dart';

class TwoPage extends StatelessWidget{
  const TwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: const Center(
        child: Text('Running on:'),
      ),
    );
  }

}