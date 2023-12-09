<template>
	<view class="wrap">
		<uni-indexed-list :options="list"  @click="chat" />
	</view>
</template>

<script>
  import Config from '../../utils/Config.js'
	export default {
		data() {
			return {
				list: [],
        friendship:{},
        friendsList: []
			}
		},
		mounted() {
      let _this = this
      uni.request({
        url: Config.friendship,
        method: "GET",
        timeout: 50000,
        success: res => {
          console.log(res);
          if(200==res.statusCode){
            _this.friendship = res.data
            Object.keys(_this.friendship).forEach(function(item, index){
              let tempGroup = {'letter':item,data:[]}
              let tempData = []
              Object.keys(_this.friendship[item]).forEach(function(i){
                tempData.push(_this.friendship[item][i].nickname)
                _this.friendsList.push(_this.friendship[item][i])
              })
              tempGroup.data = tempData
              _this.list.push(tempGroup)
            })
          }else{
            uni.showToast({
              title: '服务错误，请联系开发人员!',
              icon:'none'
            })
          }
        },
        fail: () => {
          uni.showModal({
            title: '提示',
            content: '服务连接失败，请重试或更新服端配置',
            showCancel:false
          })
        },
        complete: () => {
        }
      })
		},
		methods: {
      chat(e){
        if('群组'==e.item.key){
          uni.showToast({
            title: '开发中……',
            icon:'none'
          })
          return
        }
        uni.navigateTo({
          url:"/pages/chat/chat?chatWith="+ e.item.name+"&username="+this.friendsList[e.item.itemIndex].username
        })
      }
		}
	}
</script>

<style>

</style>
