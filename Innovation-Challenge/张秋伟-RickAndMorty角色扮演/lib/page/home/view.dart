import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:third_party_base/third_party_base.dart';
import '../../app/router_name.dart';
import '../index/view.dart';
import '../user/view.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;
  final List<Widget> _pageList = [
    IndexPage(),
    UserPage(),
  ];


  final List<BottomNavigationBarItem> _barItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
    const BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: '个人'),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(builder: (logic){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rick And Morty'),
        ),
        body: getNowWidget(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            logic.currentIndex(index);
          },
          currentIndex: state.currentIndex,
          items: _barItem,
          iconSize: 25,
          fixedColor: LibColors.libColorRoyalblue,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
        ),
      );
    });

  }

  Widget getNowWidget(){
    Widget widget =  _pageList[state.currentIndex];
    return widget;
  }
}

