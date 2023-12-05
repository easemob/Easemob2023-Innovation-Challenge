import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rick_and_morty/data/model/ai_model.dart';
import 'package:third_party_base/third_party_base.dart';

import '../../app/config.dart';
import '../../app/router_name.dart';
import 'logic.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);

  final logic = Get.put(IndexLogic());

  var colors = [LibColors.libColorCornflowerblue,
    LibColors.libColorLimegreen,
    LibColors.libColorChocolate,
    LibColors.libColorKhaki];

  final List<AIModel> list = [
    AIModel("Rick",'${VmAppConfig.img}rick.png', "Rick Sanchez（由贾斯汀·罗兰配音） - 一个奇怪和酗酒的 疯狂科学家，他是Beth/贝丝的父亲，Jerry/杰瑞的岳父，以及Morty/莫蒂和Summer/桑美的外公。他不负责任的性格导致Beth和Jerry担心他们儿子Morty的安全。这个设定经常在Rick的主角时间线上--主角时间线的Rick常常在说话时打嗝，并表现出各种精神疾病的临床诊断特征。这个特立独行的人物将他的时间视为至宝：他总是避免常规的人生经历，比如学校、婚姻甚至爱情。他对Morty及其家人向他提出的平凡的要求表示鄙视或无聊，并表明了对Jerry的鄙夷，然而，有几集中，Rick也表现出他孤独的一面。"),
    AIModel("Morty",'${VmAppConfig.img}morty.png', "Morty Smith（也由贾斯汀·罗兰配音）--莫蒂Morty，善良但容易受伤害的14岁的外孙，经常被卷入Rick的疯狂冒险。他天真的但是坚定的道德准则与瑞克的马基雅维利主义自我相抗衡。他通常不愿意遵循Rick的计划，还常受到Rick用来“修复”状况的不正规或不道德的方法所牵连。C-137的Morty被Rick称为的“最Morty的Morty”。一些其他时间线的Morty将他称为“真正的Morty”。虽然他们祖孙的关系经常是对抗的，但对于Rick来说，Morty是必要的，因为Morty的“Morty脑电波”可以抵消Rick的“天才脑电波“，以此制约Rick来自多个时间线多个宇宙敌人对他的追踪。虽然总在调侃取笑Morty，Rick偶尔会表现出对Morty真正的感情，而Morty有时也会对自己的冒险投入热情。"),
    AIModel("Summer",'${VmAppConfig.img}summer.png', "Summer Smith桑美·史密斯（Spencer Grammer配音） - Morty的17岁的姐姐，一个更传统和经常肤浅的少女，痴迷于改善她与同龄人的地位。Summer一般与她的母亲相似，但她已经表现出Jerry的机会主义和Rick的疯狂性格。她偶尔会嫉妒弟弟Morty能够在冒险中陪伴Rick。在第二季中，她更频繁地陪伴Rick和Morty冒险。有些时候，Summer比Morty更加热衷和享受冒险。在第3季一开始，Summer更关心Rick。她把Rick视为英雄，试图说服Morty和她一起拯救被困在联邦监狱的Rick。与她的弟弟不同，她对父母离婚的事情并不在乎，也不像Morty一样对父母离婚的前景忧心忡忡。"),
    AIModel("Beth",'${VmAppConfig.img}Beth.png', "Beth Smith贝丝·桑切斯（Beth Sanchez）（由莎拉·查尔克Sarah Chalke配音） - Rick的女儿，Jerry的妻子以及Summer和Morty的母亲。她是一位马心脏外科医生。在剧集Meeseeks和Destroy中，透露Beth来自密歇根州的Muskegon。一般来说，她与丈夫经常发生碰撞，不敢苟同Jerry的平庸之处。在描写Beth对她自己的生活不满的几集中，可以发现这些不满源自于她在婚姻，家庭和工作中对自己的定位和现实的差异。她想成为一名普通心脏外科医生（为人类诊治），但因为17岁的时候怀上了Summer而只能当一位马心脏外科医生。她是家中最成功的自信力量，偶尔会自私自利。Beth对她父亲的破坏性和鲁莽倾向感到不安，因为她自从童年分离以来，她比她的已故母亲更喜欢Rick。 Harmon在接受采访时扩大了这一起源：“孩子们有时可能会崇拜他们最糟糕的父母，责怪他们的支持父母追逐爸爸，勇敢的离开。” Beth认为，疯狂的Rick仍是她的父亲，即使Rick当初离开后，她的母亲独自抚养她，她也会做任何事情让她的父亲重新回到生活中。Jerry发现Beth控制欲很强。在第3季第1集中，Beth对父亲放弃她和家人表示生气。在Rick逃离监狱并废止联邦经济使他们离开地球之后，Beth回到正常的行为，甚至在Rick和Jerry二选一中选择了她的父亲Rick，并决定要和Jerry离婚。当Rick被监禁时，他的记忆之片段显示，他自己原来宇宙的Beth与她的母亲戴安·桑切斯一起被另一个维度上升的Rick杀死，C-137的贝丝不是他原来的贝丝。Rick后来声称这个记忆是假的。第三季的后来一集中，显示Beth从小就有很强的冒险欲望，使得Rick不得不为Beth制造了许多奇怪的工具，例如有自我意识的小刀，专业的战斗 外套等，Rick甚至为Beth创造了一个童话一样的维度，最终导致Beth的一个同学被困在这个维度里。"),
    AIModel("Jerry",'${VmAppConfig.img}jerry.png', "Jerry Smith-杰瑞·史密斯（克里斯·帕内尔Chris Parnell 配音）- Summer和Morty的父亲，Beth的丈夫和Rick的女婿，强烈地反对Rick对Morty的影响。通常情况下，Jerry经常被描写成一个机会主义分子，并引发冲突。他通常不赞同Rick，他与Beth的婚姻往往被这些烦恼所震撼。Jerry在一家初级广告公司工作，直到他因为无能被解雇。剧集“Mortynight Run”揭示了有一个其他时空的Rick敏锐地意识到，不是每个Jerry都能从冒险中生存下来，从而创造了一个托儿所，当各种各样的维度上的Jerry试图和Rick和Morty一起冒险时，这些Jerry会被寄养在托儿所，在同一集中，Beth已经离开Jerry再婚，在某些方面也揭示了这一点。Beth认为自己会在Jerry对自己的吹嘘和温柔中软弱，最终害怕对抗。一些Jerry被他们的Rick遗弃，或是因为他们宇宙的Rick死了，实际上被无限期地留在了托儿所。在主线剧情的宇宙中，Beth和Jerry的婚姻据说是为了孩子而维系的。但是，尽管彼此有问题，但Beth和Jerry却是情感上依赖的。然而，在第3季开始之后，Rick摧毁了宇宙联邦经济使他们离开地球，于是Jerry要让Beth在他还是Rick中做出选择。Beth选了Rick，并决定要和Jerry离婚。在S3E2中，Jerry搬出了房子。S3E10,Jerry回归了家庭。")];

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 0.8, //显示区域宽高相等
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Column(children: [
              Image.asset(list[index].img),
          Text(list[index].name),
          ]),
          onTap: (){
            Get.toNamed(RouterName.chartpage,arguments: list[index]);
          },
        );

      },
    );
  }
}
