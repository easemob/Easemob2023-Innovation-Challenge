

import 'dart:ffi';

class AIModel{
  String name;
  String img;
  String content;

  AIModel(this.name, this.img,this.content);

}

class Chat{
  bool isRight;
  String text;

  Chat(this.isRight, this.text);
}
