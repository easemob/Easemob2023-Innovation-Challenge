<template>
  <view>
    <view class="login">
      <view class="login-panel">
        <view class="logo">欢迎体验</view>
        
        <uni-section title="温馨提醒" type="line" v-show="isRegister == true">
          <uni-notice-bar style="text-align: left;" text="用户名，长度不可超过 64 个字节。不可设置为空。支持以下字符集：\n☛ 26 个小写英文字母 a-z；\n☛ 26 个大写英文字母 A-Z；\n☛ 10 个数字 0-9；\n☛ “_”, “-”, “.”。" />
        </uni-section>
        <view><input class="login-userInfo" v-model="username" :maxLength="64" placeholder="用户名" /></view>
        <view>
          <input class="login-userInfo" v-model="password" :maxLength="64" :type="showPassword?'text':'password'" @longpress="showPassword=!showPassword" placeholder="密码,长按显示" />
        </view>
        <view><input class="login-userInfo" v-model="nickname" :maxLength="64" placeholder="昵称" v-show="isRegister == true" /></view>
        <button type="primary" @click="loginOrRegister(isRegister)">{{isRegister?'注册并登录':'登录'}}</button>
        <view class="tip">
          {{isRegister?'已有账号?':'没有账号?'}}
          <span class="green" @click="isRegister=!isRegister">{{isRegister?'登录':'注册'}}</span>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  import WebIM from "../../utils/WebIM.js"

  export default {
    data() {
      return {
        username:'',
        password:'',
        nickname:'',
        isRegister:false,
        showPassword:false
      }
    },
    onLoad() {
      if(uni.getStorageSync('accessToken') && uni.getStorageSync('loginUser')){
        // （补充校验accessToken有效性）
        uni.switchTab({
          url:'/pages/index/index?id=0'
        })
      }
    },
    methods: {
      loginOrRegister(reg){
        if(!this.username || !this.password){
          uni.showModal({
            title:'请输入用户名、密码！',
            showCancel:false,
            mask:true
          })
          return
        }
        if(reg && !this.nickname){
          uni.showModal({
            title:'请输入用户昵称，这个也很重要！',
            showCancel:false,
            mask:true
          })
          return
        }
        let _this = this
        let options = {
          grant_type: 'password',
          username: this.username,
          password: this.password,
          nickname: this.nickname
        };
        let headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
        uni.request({
          url: reg?WebIM.myconf.apiHost+'users':WebIM.myconf.apiHost+'token',
          method: 'POST',
          data: options,
          header: headers,
          success(res) {
              console.log(res)
              if (res.statusCode == 200) {
                uni.showToast({
                    title:reg?'注册成功':'登录成功'
                })
                if(reg){
                  _this.loginOrRegister(false)
                  return
                }
                uni.setStorageSync('accessToken',res.data.access_token)
                _this.getUserInfo(res.data.access_token)
              } else {
                uni.removeStorageSync('loginUser')
                uni.showModal({
                    title:res.data.error,
                    content:res.data.error_description,
                    showCancel:false,
                    mask:true
                })
              }
            },
            fail(err) {
              console.log(err)
              uni.showToast({
                  title:'网络请求异常'
              })
              uni.removeStorageSync('loginUser')
            }
              
        })
      },
      getUserInfo(token){
        let _this = this
        let headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer '+token
        }
        uni.request({
          url: WebIM.myconf.apiHost+'users/'+_this.username,
          method: 'GET',
          header: headers,
          success(res) {
              console.log(res)
              if (res.statusCode == 200) {
                uni.setStorageSync('loginUser',res.data.entities[0])
                uni.switchTab({
                  url:'/pages/index/index?id=0'
                })
              } else {
                uni.showModal({
                    title:res.data.error,
                    content:res.data.error_description,
                    showCancel:false,
                    mask:true
                })
              }
            },
            fail(err) {
              console.log(err)
              uni.showToast({
                  title:'网络请求异常'
              })
            }
        })
      },
    }
  }
</script>

<style>
.login{
	width: 100%;
	height: 100%;
	background-color: #ffffff;
	position: fixed;
	background-size: contain;
}
.login-panel{
  position: absolute;
  text-align: center;
  top: 40%;
  left: 50%;
  width: 80%;
  transform: translate(-50%, -50%);
}
.logo{
  text-align: center;
  cursor: pointer;
  margin-bottom: 30px;
  vertical-align: text-bottom;
  font-size: 36px;
  display: inline-block;
  font-weight: bold;
  line-height: 1;
}
.login-userInfo{
  height: 96rpx;
  background-color: #ffffff;
  border: 2rpx solid #999999;
  border-radius: 8rpx;
  box-sizing: border-box;
  padding: 0 32rpx;
  font-size: 34rpx;
  color: #000;
  width: 100%;
  display: inline-block;
  flex: 1;
}
.tip{
  color: #cccccc;
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
}
.tip .green{
  color: #00ba6e;
  margin-left: 5px;
  cursor: pointer;
}
</style>
