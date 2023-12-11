<template>
  <view>
    <scroll-view style="width:100%;" scroll-with-animation :scroll-y="true">
          <view id="okk"  scroll-with-animation :scroll-y="true">
            <block v-for="(x, i) in msgList" :key="x.i">
              <view class="row">
                <block v-if="x.my">
                  <view class="userInfo">
                    <view class="chat-img">
                      <image style="height:100%;width:100%;" src="../../static/human.png" mode="aspectFit"></image>
                    </view>
                    <view class="flex justify-end">
                      <view class="usermsg"><text :user-select="true" style="word-break:break-all;">{{x.msg}}</text></view>
                    </view>
                  </view>
                </block>
                <block v-if="!x.my">
                  <view class="aiInfo">
                    <view class="chat-img ">
                      <image style="height:100%;width:100%;" src="../../static/bot.png" mode="aspectFit"></image>
                    </view>
                    <view class="flex">
                      <view class="aimsg"><text :user-select="true" style="word-break:break-all;">{{x.msg}}</text></view>
                    </view>
                  </view>
                </block>
              </view>
            </block>
            <view style="height:130rpx;"></view>
          </view>
        </scroll-view>
        <block>
          <view class="flex-column-center">
            <view class="inpubut">
              <input class="dh-input" type="text" confirm-type="search" placeholder-class="my-neirong-sm" :placeholder="chatWith=='花花'?'女神说的啥':''" v-model="msg" @value="msg" />
              <button :disabled="msg&&!waiting?false:true" @click="sendMsg" @tap="sendMsg">{{sendText}}</button>
            </view>
          </view>
        </block>
        <view>
            <uni-fab :pattern="fabPattern" :content="fabContent" horizontal="right" :vertical="fabTop?'top':'bottom'" @trigger="trigger"></uni-fab>
        </view>
  </view>
</template>

<script>
  import Config from '../../utils/Config.js'
  export default {
    data() {
      return {
        loginUser: null,
        accessToken: null,
        chatWith: "",
        chatUserId: "",
        msgLoad: false,
        sendText: "发送",
        anData: {},
        animationData: {},
        showTow: false,
        msgList: [{ my: false, msg: "你好呀,想问什么就问吧" }],
        parentMessageId: "",
        msgContent: [],
        msg: "",
        waiting:false,
        isInit: true,
        date: new Date().toISOString().slice(0, 10),
        fabTop:true,
        fabContent: [
          {
            iconPath: '/static/to_bottom.png',
            selectedIconPath: '/static/to_top.png',
            text: '换位置',
            active: false
          },
          {
            iconPath: '/static/cleanup.png',
            selectedIconPath: '/static/cleanup.png',
            text: '清空记录',
            active: false
          }
        ],
        fabPattern: {
          width:'50rpx',
          height:'50rpx',
          color: '#7A7E83',
          backgroundColor: '#fff',
          selectedColor: '#007AFF',
          buttonColor: '#fff',
          iconColor: '#aaa'
        },
      }
    },
    onLoad(options){
      this.loginUser = uni.getStorageSync('loginUser')
      this.accessToken = uni.getStorageSync('accessToken')
      if(!this.accessToken || !this.loginUser){
        uni.redirectTo({
          url:'/pages/login/login'
        })
      }
      this.chatWith = options.chatWith
      this.chatUserId = options.username
      let msgListOld = uni.getStorageSync('msgList_'+this.chatUserId)
      if(msgListOld){
        this.msgList = msgListOld
      }
      if(!this.chatWith){
        uni.showToast({
          title: '请选择对象',
          icon: 'none'
        })
        uni.navigateBack()
      }
      uni.setNavigationBarTitle({
        title:this.chatWith
      })
    },
    methods: {
      closePopup() {
        this.isInit = false;
        this.isLimited = false;
      },
      sendMsg() {
        let t = this;
        if ("" == this.msg) return 0;
        this.waiting = true
        let tempMsg = this.msg
        let localDate = uni.getStorageSync(this.date);
        
        this.sentext = "请求中";
        this.msgList.push({
          msg: this.msg,
          my: true
        });
        this.msgContent.push({'role': 'user', 'content': this.msg})
        console.log(this.msgContent)
        this.msgLoad = true
        this.msg = "";
        let jdata = JSON.stringify({
          message: this.msgContent,
          request_id:'',
          chatUserId: this.chatUserId,
          username: this.loginUser.username
        });
        uni.request({
          url: Config.completion,
          data: jdata,
          method: "POST",
          timeout: 50000,
          success: res => {
            console.log(res);
            if(200 == res.data.status_code){
              uni.setStorageSync(t.date, localDate + 1)
              t.msgList.push({msg: res.data.output.choices[0].message.content,my: false})
              t.msgContent.push({'role': 'assistant', 'content': res.data.output.choices[0].message.content})
              t.msgLoad = false
              t.sentext = "发送"
            }else{
              uni.showModal({
                content: res.data.message
              })
              this.msg = tempMsg
              t.msgList.pop()
              this.msgContent.pop()
            }
          },
          fail: () => {},
          complete: () => {
            this.waiting = false
          }
        })
      },
      trigger(e) {
        let _this = this
        this.fabContent[e.index].active = !e.item.active
        if(0==e.index){
          this.fabTop = !this.fabTop
        }else if(1==e.index){
          uni.showModal({
            title: '提示',
            content: '确认清空该会话历史，清空历史更有利于'+this.chatWith+'理解您的新新话题！',
            success: function(res) {
              if (res.confirm) {
                uni.removeStorageSync('msgList_'+_this.chatUserId)
                _this.msgList = [{ my: false, msg: "你好呀,想问什么就问吧" }]
              } else if (res.cancel) {
              }
            }
          })
        }
      },
    },
    beforeDestroy(){
      console.log('chat exit')
      uni.setStorageSync('msgList_'+this.chatUserId,this.msgList)
    }
  }
</script>

<style>
page {
  background: #ebebeb
}

.row {
  margin-bottom: 30rpx
}

.userInfo {
  -webkit-animation: oneshow .8s ease 1;
  animation: oneshow .8s ease 1;
  display: flex;
  flex-direction: row-reverse;
  align-items: flex-start;
  justify-content: flex-start;
  padding-right: 20rpx
}

.usermsg {
  min-height: 80rpx;
  box-sizing: border-box;
  margin-right: 20rpx;
  padding: 14rpx 30rpx;
  border-radius: 35rpx;
  background: #edfaff;
  border: 1px solid #bbd4ff;
  border-radius: 10rpx;
  font-size: 16px;
  color: #222;
  max-width: 65vw
}

.aiInfo {
  align-items: flex-start;
  margin-left: 20rpx;
  margin-top: 20rpx;
  -webkit-animation: oneshow .8s ease 1;
  animation: oneshow .8s ease 1
}

.aiInfo,
.chat-img {
  display: flex;
  flex-direction: row
}

.chat-img {
  width: 80rpx;
  height: 80rpx;
  /* background-color: #f7f7f7; */
  justify-content: center;
  align-items: center
}

.aimsg {
  margin-left: 20rpx;
  padding: 14rpx 30rpx;
  min-height: 80rpx;
  box-sizing: border-box;
  border: 1px solid #cfcfcf;
  border-radius: 10rpx;
  font-size: 16px;
  color: #222;
  max-width: 65vw
}

.aimsg,
.flex-column-center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: #fff
}

.flex-column-center {
  align-items: center;
  position: fixed;
  bottom: 0;
  width: 100%;
  padding-bottom: 10rpx
}

.inpubut {
  width: 100%;
  height: 110rpx;
  font-size: 40rpx;
  padding: 0 30rpx
}

.inpubut,
.tips {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  background-color: #f9f9f9
}

.tips {
  background: #ebebeb;
  width: calc(100% - 60rpx);
  font-size: 16px;
  margin: 30rpx;
  color: #666
}

.dh-input,
.tips {
  height: 80rpx;
  border-radius: 10rpx
}

.dh-input {
  width: calc(100% - 200rpx);
  background-color: #f0f0f0;
  margin-right: 20rpx;
  padding-left: 24rpx
}

.my-neirong-sm {
  font-size: 14px;
  color: #616161
}

.btn {
  height: 80rpx;
  width: 120rpx;
  line-height: 80rpx;
  color: #fff;
  border-radius: 10rpx;
  background: #409eff;
  border-radius: 8px;
  margin: 0;
  padding: 0;
  font-size: 14px
}

.popup {
  width: 76vw;
  position: fixed;
  top: 50%;
  left: 50%;
  -webkit-transform: translate(-50%, -60%);
  transform: translate(-50%, -60%);
  background: #fff;
  border-radius: 20rpx;
  display: flex;
  flex-direction: column;
  justify-items: center;
  align-items: flex-start;
  padding: 40rpx;
  border: 1px solid #eee;
  box-shadow: 0 5px 10px rgba(0, 0, 0, .2)
}

.popup.small {
  -webkit-transform: translate(-50%, -55%);
  transform: translate(-50%, -55%)
}

.popup.small .title {
  margin-bottom: 10rpx;
  font-size: 14px
}

.popup.small .text {
  font-size: 12px;
  margin-bottom: 20rpx
}

.popup .title {
  font-size: 18px;
  color: #10a37f;
  font-weight: 700;
  margin-bottom: 24rpx
}

.popup .text {
  font-size: 13px;
  color: #222;
  margin-bottom: 40rpx
}

.popup .button {
  width: 100%;
  text-align: center;
  font-size: 16px;
  color: #fff;
  background: #409eff;
  border-radius: 8rpx;
  box-sizing: border-box;
  padding: 20rpx 20rpx
}

.popup .close {
  width: 50rpx;
  height: 50rpx;
  position: absolute;
  right: 40rpx;
  top: 40rpx
}
</style>
