<template>
  <view>
    <view class="header-logo">
    	<image class="avatar" src="/static/bot.png"></image>
    </view>
    <view v-if="accessToken">
      <uni-section title="用户信息" type="line">
        <uni-card :title="loginUser.nickname?loginUser.nickname:loginUser.username" :isFull="true" :sub-title="line" :extra="loginUser.nickname?loginUser.username:loginUser.type" thumbnail="/static/human.png">
          <view class="title">
            <text>用户类型:</text>
            <uni-tag :inverted="inverted" style="margin-left: 30rpx;" :text="loginUser.type" type="primary" @click="inverted=!inverted"/>
          </view>
          <view class="title"><text class="uni-form-item__title">用户uuid:</text></view>
          <text>{{loginUser.uuid}}</text>
          <view class="title"><text class="uni-form-item__title">用户accessToken:</text></view>
          <input class="uni-input" :password="!showToken" disabled="true" :value="accessToken"/>
          <uni-icons :type="showToken?'eye':'eye-slash'" @click="showToken=!showToken" class="passwd"></uni-icons>
        </uni-card>
      </uni-section>
    </view>
    <view style="text-align: center;">
      <uni-section title="服务配置" type="line">
        <view class="example">
          <uni-forms ref="baseForm" :modelValue="alignmentFormData" :label-position="alignment">
            <uni-forms-item label="Host">
              <uni-easyinput v-model="customizeConfig.serverHost" placeholder="自定义服务器地址,留空则默认" />
            </uni-forms-item>
            <uni-forms-item label="国密">
              <uni-easyinput v-model="customizeConfig.serverApiYy" placeholder="自定义国密算法,留空则默认" />
            </uni-forms-item>
          </uni-forms>
        </view>
        <button type="warn" size="mini" style="width: 30%;" @click="sysconfig">提交</button>
      </uni-section>
    </view>
    <view class="logout" v-if="accessToken">
      <button @click='logout' type="default" >退出登录</button>
    </view>
  </view>
</template>

<script>
  import WebIM from "../../utils/WebIM.js"
  export default {
    data() {
      return {
        inverted: true,
        loginUser: null,
        accessToken: null,
        showToken: false,
        line: '春有约，花不误，岁岁年年，不相负',
        customizeConfig:{
          serverHost:'',
          serverApiYy:''
        }
      }
    },
    onLoad(options){
      this.loginUser = uni.getStorageSync('loginUser')
      this.accessToken = uni.getStorageSync('accessToken')
      this.customizeConfig = uni.getStorageSync('customizeConfig')
      if(!this.accessToken){
        uni.redirectTo({
          url:'/pages/login/login'
        })
      }
    },
    methods: {
        logout(){
          WebIM.conn.close()
          uni.removeStorageSync('loginUser')
          uni.removeStorageSync('accessToken')
          uni.showToast({
            title:'已退出'
          })
          uni.redirectTo({
            url:'/pages/login/login'
          })
        },
        sysconfig(key){
          uni.showModal({
            title: '提示',
            content: '更改服务配置可能导致无法使用，如果您不知道该怎么改请留空。\n是否仍修改？',
            success: function(res) {
              if (res.confirm) {
                uni.setStorageSync('customizeConfig',this.customizeConfig)
                uni.showToast({
                  title: '已更新自定义配置',
                  icon:'none'
                })
              } else if (res.cancel) {
              }
            }
          })
        }
    }
  }
</script>

<style>
page {
  height: auto;
}
.header-logo{
  padding: 15px 15px;
  flex-direction: column;
  justify-content: center;
  text-align: center;
}
.avatar{
  width: 100rpx;
  height: 100rpx;
}
.title{
  font-weight: bold;
}
.uni-input {
    display: inline-block;
    width: 90%;
    height: 45rpx;
    line-height: 45rpx;
    padding: 0px;
    flex: 1;
    background-color: #FFFFFF;
}
.uni-input-wrapper{
  color: aqua;
}
.passwd{
  display: inline-block;
  float: right;
  padding-right: 10rpx;
  width: 45rpx;
  height: 45rpx;
  font-size: 40rpx;
}
.logout{
  position: fixed;
  bottom: 0;
  width: 100%;
}
</style>
