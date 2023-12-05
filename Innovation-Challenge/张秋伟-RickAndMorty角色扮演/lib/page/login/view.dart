import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:third_party_base/third_party_base.dart';
import '../../app/config.dart';
import '../../app/router_name.dart';
import '../../data/model/login_model.dart';
import 'logic.dart';
import 'package:base_ui/base_ui.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final logic = Get.put(LoginLogic());
  final state = Get.find<LoginLogic>().state;

  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController =  TextEditingController();
  TextEditingController _passwordController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // 设置globalKey，用于后面获取FormStat
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GetBuilder<LoginLogic>(builder: (logic){
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
              buildTitle(), // Login
              buildTitleLine(), // Login下面的下划线
              const SizedBox(height: 60),
              buildUserNameTextField(), // 输入账户名
              const SizedBox(height: 30),
              buildPasswordTextField(context), // 输入密码
              // buildForgetPasswordText(context), // 忘记密码
              const SizedBox(height: 60),
              buildLoginButton(context), // 登录按钮
              const SizedBox(height: 40),
              // buildOtherLoginText(), // 其他账号登录
              // buildOtherMethod(context), // 其他登录方式
              buildRegisterText(context), // 注册
            ],
          );
        },),
      ),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () async{
                var data = await Get.toNamed(RouterName.regist);
                if(data is LoginModel){
                  _usernameController.text = data.userName;
                  _passwordController.text = data.password;
                  _press();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget buildOtherMethod(context) {
  //   return ButtonBar(
  //     alignment: MainAxisAlignment.center,
  //     children: _loginMethod
  //         .map((item) =>
  //         Builder(builder: (context) {
  //           return IconButton(
  //               icon: Icon(item['icon'],
  //                   color: Theme
  //                       .of(context)
  //                       .iconTheme
  //                       .color),
  //               onPressed: () {
  //                 //TODO: 第三方登录方法
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                       content: Text('${item['title']}登录'),
  //                       action: SnackBarAction(
  //                         label: '取消',
  //                         onPressed: () {},
  //                       )),
  //                 );
  //               });
  //         }))
  //         .toList(),
  //   );
  // }

  // final List _loginMethod = [
  //   {
  //     "title": "facebook",
  //     "icon": Icons.facebook,
  //   },
  //   {
  //     "title": "google",
  //     "icon": Icons.fiber_dvr,
  //   },
  //   {
  //     "title": "twitter",
  //     "icon": Icons.account_balance,
  //   },
  // ];
  //
  // Widget buildOtherLoginText() {
  //   return const Center(
  //     child: Text(
  //       '其他账号登录',
  //       style: TextStyle(color: Colors.grey, fontSize: 14),
  //     ),
  //   );
  // }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
            child: const Text("登录"),
          onPressed: () {
            _press();
          },
        ),
      ),
    );
  }

  void _press(){
    // 表单校验通过才会继续执行
    if ((_formKey.currentState as FormState).validate()) {
      (_formKey.currentState as FormState).save();
      logic.login(_usernameController.text, _passwordController.text);
    }
  }

  // Widget buildForgetPasswordText(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8),
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: TextButton(
  //         onPressed: () {
  //           // Navigator.pop(context);
  //           print("忘记密码");
  //         },
  //         child: const Text("忘记密码？",
  //             style: TextStyle(fontSize: 14, color: Colors.grey)),
  //       ),
  //     ),
  //   );
  // }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
        obscureText: state.isObscure, // 是否显示文字
        onChanged: (v){
          var l = v.length;
          v = v.replaceAll(' ', '');
          if(l!=v.length){
            _passwordController.text = v;
            _passwordController.selection = TextSelection(baseOffset: v!.length, extentOffset: v!.length);
          }

        },
        validator: (v) {
          if (v!.isEmpty) {
            return '请输入密码';
          }
        },
        decoration: InputDecoration(
            labelText: "请输入密码",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: state.eyeColor,
              ),
              onPressed: () {
                logic.obscure();
              },
            )));
  }

  Widget buildUserNameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(labelText: '请输入账号'),
      onChanged: (v){
        var l = v.length;
        v = v.replaceAll(' ', '');
        if(l!=v.length){
          _usernameController.text = v;
          _usernameController.selection = TextSelection(baseOffset: v!.length, extentOffset: v!.length);
        }
      },
      validator: (v) {
        if(v==null||v.isEmpty){
          return '请输入正确的账户名';
        }
      },
      // onSaved: (v) => _username = v!,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          '登录',
          style: TextStyle(fontSize: 42),
        ));
  }
}