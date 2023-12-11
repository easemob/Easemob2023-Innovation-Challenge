<template>
	<view class="page">
		<view class="headBox">
			
			<text class="title">消息</text>
			<image src="../../static/img/add.png" @click="showFunBox"></image>
		</view>
		<view class="searchBox">
			<image src="../../static/img/search.png"></image>
			<view class="line"></view>
			<input placeholder="搜索" />
		</view>
		<scroll-view class="contentBox" scroll-y>
			<view class="item-box" @click="sendCustomMsg">
				<image class="headImage" src="../../static/img/messageInfo.png"></image>
				<view class="left-box">
					<text class="name">系统消息</text>
					<text class="reMsg">系统：订单已经通过</text>
				</view>
					
			</view>

			<view class="item-box">
				<image class="headImage" src="../../static/img/noticeInfo.png"></image>
				<view class="left-box">
					<text class="name">好友通知</text>
					<text class="reMsg"></text>
				</view>

			</view>

			
			<view class="item-box" @click="navigatorTo(item)" v-for="(item,index) in userList">
				<image class="headImage" src="/static/index/doctorImage.png"></image>
				<view class="left-box">
					<text class="name">张三</text>
					<text class="reMsg"></text>
				</view>
				<view class="tail-box">
					23/03/03
				</view>
			</view>


		</scroll-view>
		
		
		<view v-if="showPopup" class="popupBox " @click="closePopUp">
			<view class="funBox">
				<!-- <view class="funItem">发起群聊</view> -->
				<view class="funItem" @click="scanEV">扫一扫</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				groupList:[],
				userList:[],
				showPopup:false
			}
		},
		onLoad() {
			console.log(":::::")
			console.log(this.$WebIM)
			this.getUserFriends()
			this.getUserGroupList()
		},
		methods: {
		
			closePopUp(){
				this.showPopup=false
			},
			showFunBox(){
				this.showPopup=true
			},
			getUserGroupList() {
				var _this=this
				this.$WebIM.conn.getContacts({}).then(res=>{
					// console.log(res)
					_this.userList=res.data;
					// console.log(res)
					
				})
				// this.$WebIM.conn.getJoinedGroups({
				// 	pageNum: 1,
				// 	pageSize: 500,
				// 	needAffiliations: false,
				// 	needRole: false
				// }).then(res => {
				// 	console.log("这",res)
				// 	_this.groupList=res.data
				// })

			},
			getUserFriends(){
				// var firends=this.$Webconsole.getAllContacts()
				// console.log(firends)
				var _this=this
				console.log("开始")
				this.$WebIM.conn.getContacts({}).then(res=>{
					// console.log(res)
					_this.userList=res.data;
					// console.log(res)
					
				})
			},
			navigatorTo(item) {
				uni.navigateTo({
					url: '/pages/groupChat/groupChat?group='+JSON.stringify(item)
				})
			},
			scanEV(){
				this.showPopup=false
				uni.scanCode({
					success: function (res) {
						console.log('条码类型：' + res.scanType);
						console.log('条码内容：' + res.result);
					}
				});
			}
			

		}
	}
</script>

<style lang="less">
	.page {
		width: 100vw;
		height: 100vh;
		display: flex;
		flex-direction: column;
		align-items: center;
		background-color: rgb(233, 235, 222);
		.popupBox{
			position: absolute;
			top: 0;
			left: 0;
			width: 100vw;
			height: 100vh;
			// background-color: white;
			z-index: 9999;
			.funBox{
				width: 140px;
				
				background-color: rgba(24, 24, 24, 0.8);
				position: absolute;
				top:6vh;
				border-radius: 4px;
				right: 10px;
				display: flex;
				flex-direction: column;
				padding: 10px 0 10px 0;
				.funItem{
					display: flex;
					justify-content: flex-start;
					align-items: center;
					color: white;
					font-size: large;
					height: 30px;
					width: 140px;
					padding: 0 0 0 10px;
					// border-bottom: 1px white solid;
					margin: 5px 0 5px 0;
				}
			}
		}
		.headBox {
			width: 95%;
			height: 6vh;
			display: flex;
			flex-direction: row;
			justify-content: space-between;
			align-items: center;

			.title {
				font-size: 20px;
				font-weight: 540;
			}

			image {
				width: 30px;
				height: 30px;
			}
		}

		.searchBox {
			width: 95%;
			height: 4vh;
			background-color: white;
			border-radius: 20px;
			margin-bottom: 20px;
			display: flex;
			flex-direction: row;
			justify-content: flex-start;
			align-items: center;

			image {
				height: 25px;
				width: 25px;
				margin-left: 20px;
			}

			.line {
				height: 70%;
				width: 4px;
				background-color: darkgray;
				border-radius: 3px;
				margin: 0 10px 0 10px;
			}

			input {
				font-size: large;
				color: lightgray;
				width: 80%;
			}

		}

		.contentBox {
			width: 100vw;
			height: 85vh;

			background-color: white;
			border-radius: 20px 2 0px 0 0;
			display: flex;
			flex-direction: column;
			align-items: center;

			.item-box {
				width: 100%;
				display: flex;
				flex-direction: row;
				justify-content: center;
				align-items: center;
				margin: 10px 0 10px 0;

				.headImage {
					height: 48px;
					width: 48px;
					margin: 0 10px 0 10px;
					border-radius: 50%;
					border: 1px gainsboro solid;
				}

				.left-box {

					display: flex;
					flex-direction: column;

					flex-grow: 2;

					.name {
						font-size: large;
						font-weight: 520;
					}

					.reMsg {
						margin-top: 5px;
						font-size: smaller;
						color: gray;
					}
				}
			}

		}
	}
</style>
