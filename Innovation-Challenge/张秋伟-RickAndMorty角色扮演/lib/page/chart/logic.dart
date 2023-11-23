
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:rick_and_morty/data/model/chat_model.dart';
import 'package:rick_and_morty/data/model/params/ai_param.dart';
import 'package:rick_and_morty/data/source/app_responsitory.dart';
import 'package:rick_and_morty/page/chart/state.dart';
import 'package:third_party_base/third_party_base.dart';

import '../../data/model/ai_model.dart';

class ChartLogic extends GetxController  {
  final ChartState state = ChartState();

  late AIModel aiModel;
  late AiParma payload;
  @override
  void onInit() {
    super.onInit();
    aiModel = Get.arguments;
    payload = AiParma(500,"abab5.5-chat",{"sender_type" : "BOT", "sender_name" : aiModel.name},[{"bot_name" : aiModel.name,"content" : aiModel.content}],[]);
  }

  void send(String contentm)async{
    state.chat.add(Chat(true, contentm));
    update();
    var msg = EMMessage.createTxtSendMessage(
      targetId: "AI",
      content: contentm,
    );
    EMClient.getInstance.chatManager.sendMessage(msg);
    payload..messages.add(ChatModel("USER","用户",contentm));
    var data = await AppResponsitory.instance.chatcompletionPro(payload);
    EasyLoading.dismiss();
    payload..messages.add(ChatModel("BOT", aiModel.name,data.reply));
    state.chat.add(Chat(false, data.reply));
    update();
  }


}
