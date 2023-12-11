<template>
	<view class="page">
		<view class="infor">
			<image class="headImage" src="../../static/img/robot.png"></image>
			<view class="infoBox">
				<text class="doName">机器人诊断</text>
			<text class="intro">在线智能回答问题</text>
			<view class="bottonBox">
				<text>回答评价:</text>
				<uni-rate size="18" :value="5" />
			</view>
				
			</view>
		</view>
		<scroll-view class="showBox" scroll-y>
			<!-- <view class="message">
				<image class="headImage" src="../../static/img/adlaba.png"></image>
				<view class="msgArae">
					<text class="name">广告推荐</text>
					<view class="msgBox adClass">
						<text class="title">热门推荐</text>
						<text>为您精选本期最受欢迎的人气商品，欢迎游览和选购！</text>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
					</view>
				</view>
				<image class="headImage"></image>
			</view> -->
			<view class="message" v-for="(item,index) in msgList">
				<view v-if="item.type=='textMsg'" style="display: flex;flex-direction: row;">
					<image class="headImage" :src="item.isSelf?'':item.headImage"></image>
					<view :class="item.isSelf?'msgArae myMsg':'msgArae'">
						<text class="name">{{item.userName}}</text>
						<view class="msgBox">
							<text class="text" :style="{'background-color':item.isSelf?'rgb(222, 231, 40)':'rgb(28, 232, 21)'}">
								{{item.textData}}
							</text>
						</view>
					</view>
					<image class="headImage" :src="item.isSelf?item.headImage:''"></image>
				</view>


				<view v-if="item.type=='imgMsg'" style="display: flex;flex-direction: row;">
					<image class="headImage" :src="item.isSelf?'':item.headImage"></image>
					<view :class="item.isSelf?'msgArae myMsg':'msgArae'">
						<text class="name">{{item.userName}}</text>
						<view class="msgBox">
							<image class="image" :src="item.imgData"></image>
						</view>
					</view>
					<image class="headImage" :src="item.isSelf?item.headImage:''"></image>
				</view>

			</view>


			<!-- <view class="message">
				<image class="headImage" src="../../static/img/adlaba.png"></image>
				<view class="msgArae">
					<text class="name">广告推荐</text>
					<view class="msgBox adClass">
						<text class="title">热门推荐</text>
						<text>为您精选本期最受欢迎的人气商品，欢迎游览和选购！</text>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
						<view class="showIamge">
							<image src="../../static/logo.png"></image>
							<view class="rightBox">
								<text class="info">大促销，新鲜的水果方便使用</text>
							</view>
						</view>
					</view>
				</view>
				<image class="headImage"></image>
			</view> -->


		</scroll-view>
		<view class="funBox">
			<view class="inputBox">
				<view>语音</view>
				<view class="input"><input v-model="message" /></view>
				<view @click="sendMsg()">发送</view>
			</view>
			<view class="funList">
				<image class="fun" src="../../static/img/ad.png" @click="sendAD"></image>
				<image class="fun" src="../../static/img/img.png" @click="sendImage"></image>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				message: "",
				userId: "123123",
				groupname: '',
				msgList: [
					{
						type:"textMsg",
						userId:"123123",
						userName:"体验用户1",
						headImage:'../../static/img/robot.png',
						textData:"你好有什么需要帮助的吗",
						isSelf:false
					},
					// {
					// 	type:"textMsg",
					// 	userId:"123",
					// 	userName:"体验用户2",
					// 	headImage:'../../static/logo.png',
					// 	textData:"测试消息,测试消息,测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息测试消息",
					// 	isSelf:true
					// }
				]
			}
		},
		onLoad(option) {
			console.log(option.groupid)
			var group = JSON.parse(option.group)
			this.groupid = group.groupid
			this.groupname = group.groupname
			console.log(group)
			this.userId = this.$WebIM.user.userId
			this.nikename = this.$WebIM.user.nikename
			this.headImage = this.$WebIM.user.headImage

			var msgEven = "groupChat_" + this.groupid
			this.listenEven(msgEven)
		},
		onUnload() {
			var msgEven = "groupChat_" + this.groupid
			uni.$off(msgEven)
		},
		methods: {
			listenEven(msgEven) {
				var _this = this
				uni.$on(msgEven, res => {
					console.log("监听的事件")
					console.log(res)
					if (res.type == 'txt') {
						var msg = {
							type: "textMsg",
							userId: res.from,
							userName: res.ext.nikename,
							headImage: res.ext.headImage,
							textData: res.msg,
							isSelf: false
						}
						_this.msgList.push(msg)
					}
				})
			},
			sendImage() {
				uni.chooseImage({
					count: 1, //默认9
					sizeType: 'compressed', //可以指定是原图还是压缩图，默认二者都有
					//从相册选择
					success: function(res) {
						var path = res.tempFilePaths[0]
					}

				})
			},
			sendMsg() {

				let WebIM = this.$WebIM
				var _this = this
				console.log("进入", this.message, this.groupid)
				if (this.message == '') {
					return
				}
				if (this.groupid == null || this.groupid == '') {
					return
				}

				let option = {
					// 消息类型。
					type: "txt",
					msg: this.message,
					// 消息接收方：单聊为对方用户 ID，群聊和聊天室分别为群组 ID 和聊天室 ID。
					to: this.groupid,
					// 会话类型：单聊、群聊和聊天室分别为 `singleChat`、`groupChat` 和 `chatRoom`。
					chatType: "groupChat",

				};

				// 创建一条自定义消息。
				let msg = WebIM.message.create(option);
				// 调用 `send` 方法发送该自定义消息。
				msg.ext = {
					nikename: _this.nikename,
					headImage: _this.headImage
				}
				console.log("dddddd", msg)
				WebIM.conn
					.send(msg)
					.then((res) => {
						console.log("Success", res);

					})
					.catch((e) => {
						// 消息发送失败回调。
						console.log("Fail");
					});
				var textMsg = {
					type: "textMsg",
					userId: _this.userId,
					userName: _this.nikename,
					headImage: _this.headImage,
					textData: _this.message,
					isSelf: true
				}
				_this.msgList.push(textMsg)
				_this.message = ''
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
		.infor {

			display: flex;
			flex-direction: row;
			width: 100vw;
			height: 20vh;
			// background-color: gainsboro;
			display: flex;
			flex-direction: row;
			justify-content: center;
			align-items: center;
			border-bottom:1px black solid;
			
			.headImage{
				width: 20vw;
				height: 20vw;
			
			}
			.infoBox{
				width: 61vw;
				height: 12vh;
				// background-color: rgb(68, 171, 186);
				// border: 1px red solid;
				display: flex;
				flex-direction: column;
				align-items: flex-start;
				justify-content: space-around;
				padding-left: 4vw;
				
				.doName{
					font-weight: bold;
					font-size: larger;
				}
				.intro{
					color: rgb(171, 171, 171);
				}
				.bottonBox{
					display: flex;
					flex-direction: row;
					justify-content: space-between;
					width: 100%;
				}
			}

			.item {
				width: 10vw;

				image {
					width: 30px;
					height: 30px;
				}
			}

			.name {
				width: 80vw;
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: center;
			}
		}

		.showBox {
			width: 100vw;
			height: 70vh;
			display: flex;
			flex-direction: column;
			align-items: center;
			// background-color: gainsboro;

			.message {

				width: 90vw;
				display: flex;
				flex-direction: row;
				justify-content: center;
				margin: 20px 5vw 20px 5vw;
				
				.headImage {
					width: 10vw;
					height: 10vw;
					border-radius: 10px;
				}

				.msgArae {
					width: 66vw;
					// border: 1px red solid;
					margin: 0 2vw 0 2vw;

					padding: 0 10px 10px 10px;
					height: auto;
					display: flex;
					flex-direction: column;
					
					.name {
						font-size: small;
						color: gray;
						margin-bottom: 5px;

					}

					.msgBox {
						padding: 5px;
						white-space: pre-wrap;
						display: flex;
						flex-direction: row;
						.text {
							display: inline-block;
							background-color: white;
							border-radius: 5px;
							padding: 7px;
						}

						.image {
							width: 180px;
							height: 180px;
						}
					}

					.otherMsg {
						background-color: white;
					}

					.adClass {
						background-color: rgb(244, 244, 244);
						border-radius: 10px;
						display: flex;
						flex-direction: column;
						padding: 0 10px 0 10px;

						.title {
							font-weight: bold;
							font-size: large;
							margin: 5px 0 4px 0;

						}

						.showIamge {
							display: flex;
							flex-direction: row;
							margin: 10px 0 10px 0;

							image {
								width: 120px;
								height: 100px;
								margin: 0 4px 0 4px;
							}

							.rightBox {
								flex-grow: 2;

								.info {
									font-size: small;
									color: rgb(152, 149, 162);
								}
							}
						}
					}

				}

				.myMsg {
					align-items: flex-end;

					.msgBox {}
				}

			}
		}

		.funBox {
			width: 100vw;
			height: 10vh;
			border: 1px black solid;
			display: flex;

			flex-direction: column;
			align-items: center;
			justify-content: space-around;

			.inputBox {
				display: flex;
				width: 100%;
				flex-direction: row;
				align-items: center;

				.input {
					flex-grow: 2;
					border: 1px black solid;
					border-radius: 20px;

					input {
						margin-left: 13px;
						width: 89%;

					}
				}

				view {
					margin: 0 10px 0 10px;
					border: 1px black solid;
					border-radius: 5px;

				}
			}

			.funList {
				width: 95vw;
				display: flex;
				flex-direction: row;

				.fun {
					width: 30px;
					height: 30px;
					margin-right: 10px;
				}
			}
		}
	}
</style>
