import App from './App'
import i18n from './lang/i18n'
import WebIM from 'utils/WebIM.js'
import RequestUtil from 'utils/RequestUtils'

import Vue from 'vue'
Vue.config.productionTip = false
Vue.prototype.$WebIM=WebIM.default


WebIM.default.conn.addEventHandler("eventName", {
  // SDK 与环信服务器连接成功。
  onConnected: function (message) {
	  console.log("连接成功",message)

  },
  // SDK 与环信服务器断开连接。
  onDisconnected: function (message) {
	  console.log("断开连接",message)
  },
  
  // 当前用户收到文本消息。
  onTextMessage: function (message) {
	  console.log("文本消息",message)
	  if(message.chatType=='groupChat'){
		  var evenId="groupChat_"+message.to
		  uni.$emit(evenId,message)
	  }
  },
  
  // 当前用户收到图片消息。
  onImageMessage: function (message) {
	  console.log("图片消息",message)
  },
  
  // 当前用户收到透传消息。
  onCmdMessage: function (message) {},
  // 当前用户收到语音消息。
  onAudioMessage: function (message) {},
  // 当前用户收到位置消息。
  onLocationMessage: function (message) {},
  // 当前用户收到文件消息。
  onFileMessage: function (message) {},
  // 当前用户收到自定义消息。
  onCustomMessage: function (message) {
	  console.log("自定义消息",message)
  },
  // 当前用户收到视频消息。
  onVideoMessage: function (message) {},
  // 当前用户订阅的其他用户的在线状态更新。
  onPresence: function (message) {},
  // 当前用户收到好友邀请。
  onContactInvited: function (msg) {},
  // 联系人被删除。
  onContactDeleted: function (msg) {},
  // 新增联系人。
  onContactAdded: function (msg) {},
  // 当前用户发送的好友请求被拒绝。
  onContactRefuse: function (msg) {},
  // 当前用户发送的好友请求被同意。
  onContactAgreed: function (msg) {},
  // 当前用户收到群组邀请。
  onGroupEvent: function (message) {},
  // 本机网络连接成功。
  onOnline: function () {},
  // 本机网络掉线。
  onOffline: function () {},
  // 调用过程中出现错误。
  onError: function (message) {},
  // 当前用户收到的消息被消息发送方撤回。
  onRecallMessage: function (message) {},
  // 当前用户发送的消息被接收方收到。
  onReceivedMessage: function (message) {},
  // 当前用户收到消息送达回执。
  onDeliveredMessage: function (message) {},
  // 当前用户收到消息已读回执。
  onReadMessage: function (message) {},
  // 当前用户收到会话已读回执。
  onChannelMessage: function (message) {},
});
console.log(RequestUtil)
const requestUtil = new RequestUtil('http://localhost:5000');
// App.prototype=requestUtil
Vue.prototype.$requestUtil = requestUtil;

App.mpType = 'app'
const app = new Vue({
	i18n,
	...App
})
app.$mount()
