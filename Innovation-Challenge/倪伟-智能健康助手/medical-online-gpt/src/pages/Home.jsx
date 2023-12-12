import '../App.css';
import WebIM from 'easemob-websdk'
import '@chatui/core/es/styles/index.less';
// 引入组件
import Chat, { Bubble, useMessages, toast } from '@chatui/core';
// 引入样式
import '@chatui/core/dist/index.css';
import { useHistory } from "react-router-dom";
import {
  useLocation
} from "react-router-dom";
import axios from "axios";
import { useState } from 'react';
const initialMessages = [
  {
    type: 'text',
    content: { text: '主人好，我是基于您的智能健康管家，您有什么问题都可以咨询我～' },
    user: { avatar: './ChatGPT_logo.png' },
  },
];

const initialRobotMessages = [
  {
    type: 'text',
    content: { text: '智能健康管家您好，希望您能为大家提供帮助～' },
    user: { avatar: './ChatGPT_logo.png' },
  },
];

// 默认快捷短语，可选
const defaultQuickReplies = [
  {
    icon: "keyboard-circle",
    name: '健康评估',
    isNew: true
  },
  {
    name: '用药咨询',
  },
  {
    name: '养身指南',
  },

];

export default function () {

  // 输入Key
  var key = "sk-pdPGVLSxPToYVAhXE34a61A027Bc4d3185Af8a926d33C976";
  var baseUrl = "https://emilygpt.fly.dev";
  let location = useLocation();
  const { messages, appendMsg } = location.query.userid !== 'robot' ? useMessages(initialMessages) : useMessages(initialRobotMessages);

  // 判断红点
  if (localStorage.getItem('clickFlag')) {
    defaultQuickReplies[0].isNew = false
  } else {
    defaultQuickReplies[0].isNew = true
  }
  const [chatMessage, setChatMessage] = useState([]);
  const [peerId, setPeerId] = useState('');
  const placeHolder = location.query.userid !== 'robot' ? '有问题尽管问我~' : '您有更好的建议～';
  let history = useHistory();
  WebIM.conn.addEventHandler('connection&message', {
    onConnected: () => {
      console.log('connected')
    },
    onDisconnected: () => {
      console.log('disconnected')
    },
    onTextMessage: (message) => {
      let userid = location.query.userid;
      if(userid === 'robot'){
        setPeerId(message?.from);
        appendMsg({
          type: 'text',
          content: { text: message?.msg },
          user: { avatar: './ChatGPT_logo.png' },
        });
        var apiKey = key
        axios
          .post(
            // 'https://api.openai.com/v1/chat/completions',
            baseUrl + '/api/openai/v1/chat/completions', // 基本地址
            {
              messages: [...chatMessage, { content: message?.msg, role: 'user' }],
              max_tokens: 2048,
              n: 1,
              temperature: 0.5,
              //   stop: ['\n'],
              model: 'gpt-3.5-turbo',
            },
            {
              headers: {
                'Content-Type': 'application/json',
                Authorization: 'Bearer ' + apiKey,
              },
            },
          )
          .then((res) => {
            const response = res.data.choices[0].message.content.trim();
            const newMessages = [
              ...chatMessage,
              { content: message?.msg, role: 'user' },
              { content: response, role: 'system' },
            ];
            // setChatMessage(newMessages as any);
            setChatMessage(newMessages);
            // appendMsg({
            //   type: 'text',
            //   content: { text: response },
            //   user: { avatar: './ChatGPT_logo.png' },
            // });
            let peerMessage = response
            let option = {
              chatType: 'singleChat',    // 会话类型，设置为单聊。
              type: 'txt',               // 消息类型。
              to: peerId,                // 消息接收方（用户 ID)。
              msg: peerMessage           // 消息内容。
            }
            let msg = WebIM.message.create(option);
            WebIM.conn.send(msg).then((res) => {
              console.log('send private text success');
            }).catch((err) => {
              console.log('send private text fail');
            })
          }).catch((err) => {
            console.log('send private text fail');
          })
          .catch ((err) => {
            console.log(err)
            toast.fail("出错啦！请稍后再试")
          }
          );
      }else{
        setPeerId('robot');
        appendMsg({
          type: 'text',
          content: { text: message?.msg },
          user: { avatar: './ChatGPT_logo.png' },
        });
      }
    },
    onError: (error) => {
      console.log('on error', error)
    }
  })

  // 发送回调
  function handleSend(type, val) {
    let userid = location.query.userid;
    if (userid !== 'robot') {
      let peerId = 'robot';
      let peerMessage = val
      let option = {
        chatType: 'singleChat',    // 会话类型，设置为单聊。
        type: 'txt',               // 消息类型。
        to: peerId,                // 消息接收方（用户 ID)。
        msg: peerMessage           // 消息内容。
      }
      let msg = WebIM.message.create(option);
      WebIM.conn.send(msg).then((res) => {
        console.log('send private text success');
      }).catch((err) => {
        console.log('send private text fail');
      })
      appendMsg({
        type: 'text',
        content: { text: val },
        position:'right',
        user: { avatar: './ChatGPT_logo.png' },
      });
    }else{
      let peerMessage = val
      let option = {
        chatType: 'singleChat',    // 会话类型，设置为单聊。
        type: 'txt',               // 消息类型。
        to: peerId,                // 消息接收方（用户 ID)。
        msg: peerMessage           // 消息内容。
      }
      let msg = WebIM.message.create(option);
      WebIM.conn.send(msg).then((res) => {
        console.log('send private text success');
      }).catch((err) => {
        console.log('send private text fail');
      })
      appendMsg({
        type: 'text',
        content: { text: val },
        position:'right',
        user: { avatar: './ChatGPT_logo.png' },
      });
    }
  }

// 快捷短语回调，可根据 item 数据做出不同的操作，这里以发送文本消息为例
function handleQuickReplyClick(item) {
  handleSend('text', item.name);
}


function renderMessageContent(msg) {
  const { type, content } = msg;

  // 根据消息类型来渲染
  switch (type) {
    case 'text':
      return <Bubble content={content.text} />;
    case 'image':
      return (
        <Bubble type="image">
          <img src={content.picUrl} alt="" />
        </Bubble>
      );
    default:
      return null;
  }
}

function clear() {
  WebIM.conn.close();
  history.push({pathname:'./login',query:{}});
}

return (
  [
    <div className='head'>
      <div className='head-set'><img src={process.env.PUBLIC_URL + '/set.png'} alt="设置" /></div>
      <div className='head-title'>智能健康管家</div>
      <div className='head-clear' onClick={() => clear()}><img src={process.env.PUBLIC_URL + '/clear.png'} alt="退出" /></div>
    </div>,
    <Chat
      // navbar={{ title: 'chatBot' }}
      placeholder={placeHolder}
      messages={messages}
      renderMessageContent={renderMessageContent}
      quickReplies={location.query.userid !== 'robot' ? defaultQuickReplies : []}
      onQuickReplyClick={handleQuickReplyClick}
      onSend={handleSend}
    />,
  ]
);
}