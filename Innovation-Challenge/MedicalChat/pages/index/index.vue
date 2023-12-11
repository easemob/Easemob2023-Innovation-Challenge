<template>
	<view class="page">
		<view class="headBox" @click="gotoRobotView">
			<view class="title">快速问医生</view>
			<view class="info">
				<image class="headImage" src="../../static/app-plus/sharemenu/qq.png"></image>
				<view class="center">
					<text class="text1">智能机器人在线问诊</text>
					<text class="text2">快速回复，不限次数</text>
				</view>
				<view class="but">
					快速咨询
				</view>
			</view>
		</view>
		<view class="funBox">
			<image src="../../static/index/ad.png" class="ad"></image>
			<view class="control">
				<uni-segmented-control :current="currentIndex" :values="items" @clickItem="onClickItem" />
			</view>
			<view class="funList">
				<view v-if="currentIndex==0" class="fun" v-for="item in keshiList" @click="gotoShowPage()">
					<image :src="'../../static/index/'+item.title+'.png'"></image>
					<text>{{item.title}}</text>
				</view>
				<view v-if="currentIndex==1" class="fun" v-for="item in jibingList">
					<image :src="'../../static/index/'+item.title+'.png'"></image>
					<text>{{item.title}}</text>
				</view>
			</view>
		</view>
		<view class="infoBox">
			<view class="headInfo">
				<uni-notice-bar show-icon scrollable text="在线医生咨询病情,可靠答疑,针对治疗,提供有用的医疗咨询服务." />
				<text class="title">自助提问</text>
				<view class="searchBox">
					<uni-search-bar class="uni-mt-10" radius="100" placeholder="搜索医生,疾病" clearButton="none"
						cancelButton="none" @confirm="search" />
				</view>
				<!-- <view class="info" v-for="item in keshiList">
					<image class="headImage" src="../../static/index/doctorImage.png" image>
						<view class="center">
							<view class="title">
								<text class="name">李医生</text>
								<text class="intro">主治医生 副教授</text>
							</view>
							<view class="doctorInfo">
								<text class="intro">
									主治：白癜风，黑癜风，蓝癜风，癫痫。
								</text>
								<text class="from">
									安徽科技大学第三附属医院
								</text>
							</view>
						</view>
						<view class="but" @click="goToPerson()">咨询一下</view>
				</view> -->
				<view class="info" v-for="item in doctorList">
					<image class="headImage" src="../../static/index/doctorImage.png" image>
						<view class="center">
							<view class="title">
								<text class="name">{{item.user.nikename}}</text>
								<text class="intro">主治医生 副教授</text>
							</view>
							<view class="doctorInfo">
								<text class="intro">
									主治：{{item.specialization}}。
								</text>
								<text class="from">
									{{item.introduction}}
								</text>
							</view>
						</view>
						<view class="but" @click="goToPerson(item.id)">咨询一下</view>
				</view>
				<view class="info"></view>
			</view>
		</view>
	</view>
</template>

<script>
	const user = {
		username: "pTang",
		password: "123456"
	}

	export default {
		data() {
			return {
				items: ['按科室', '按疾病'],
				currentIndex: 0,
				keshiList: [{
						title: "中医科",
						src: ""
					},
					{
						title: "外科",
						src: ""
					},
					{
						title: "内科",
						src: ""
					},
					{
						title: "儿科",
						src: ""
					},
					{
						title: "产科",
						src: ""
					},
					{
						title: "眼科",
						src: ""
					}
				],
				jibingList: [{
						title: "高血脂",
						src: ""
					},
					{
						title: "肺慢阻",
						src: ""
					},
					{
						title: "高血压",
						src: ""
					},
					{
						title: "皮肤疾病",
						src: ""
					},
					{
						title: "胃炎",
						src: ""
					},
					{
						title: "耳鼻喉科",
						src: ""
					}
				],
				styles: [{
						value: 'button',
						text: '按钮',
						checked: true
					},
					{
						value: 'text',
						text: '文字'
					}
				],
				doctorList:[]
			}
		},
		onLoad() {
			this.getDoctorsList()
		},
		methods: {
			goToPerson(uId) {
			uni.navigateTo({
				url: '/pages/personChat/personChat?doctorId='+uId
			})
			},
			getDoctorsList() {
				var _this=this
				this.$requestUtil.get('/medical/doctor/list')
					.then((res) => {
						// 处理请求成功的响应
						if(res.code==200){
							this.doctorList=res.data
						}
						console.log("输出结构",res);
					})
			},
			gotoShowPage(pageId) {
				uni.navigateTo({
					url: '/pages/showPage/showPage'
				})
			},
			onClickItem(e) {
				if (this.currentIndex != e.currentIndex) {
					this.currentIndex = e.currentIndex;
				}
			},
			gotoRobotView() {
				uni.navigateTo({
					url: "/pages/robotChat/robotChat"
				})
			}
		}
	}
</script>

<style lang="less">
	.page {
		width: 100vw;
		height: 100vh;
		// background-color: aliceblue;
		background-image: url("../../static/index/back.jpg");
		display: flex;
		flex-direction: column;
		align-items: center;

		// justify-content: center;
		view {
			width: 96vw;
			display: flex;
			// margin-left: 2vw;
		}

		.headBox {
			height: 12vh;
			width: 96vw;
			background-color: white;
			border-radius: 10px;
			flex-direction: column;
			justify-content: space-around;
			align-items: center;
			margin-top: 1vh;

			.title {
				// font-size: ;
				font-size: small;
				font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
				font-weight: bolder;
				margin: 1px 0 1px 20px;
			}

			.info {
				width: 90vw;
				display: flex;
				flex-direction: row;
				justify-content: space-between;
				align-items: center;
				margin: 10px 0 10px 0;

				.headImage {
					width: 40px;
					height: 40px;
					border-radius: 50%;
				}

				.center {
					width: 50%;
					display: flex;
					flex-direction: column;

					.text1 {
						font-weight: bold;
					}

					.text2 {
						font-size: small;
						color: rgb(162, 162, 164);
						font-weight: bold;

					}
				}

				.but {
					width: 90px;
					margin-left: 30px;
					height: 30px;
					display: flex;
					flex-direction: row;
					justify-content: center;
					align-items: center;
					background-color: rgb(236, 250, 251);
					border-radius: 4px;
					font-weight: bold;
					color: rgb(149, 210, 215);
				}

			}

		}

		.funBox {
			height: 38vh;
			width: 96vw;
			margin-top: 20px;
			background-color: white;
			border-radius: 10px;
			flex-direction: column;
			align-items: center;

			.ad {
				width: 100%;
				height: 60px;
				border-radius: 10px 10px 0 0;
				border-bottom: 1px solid;
			}

			.funList {
				flex-grow: 2;
				display: flex;
				// flex-direction: column;
				justify-content: space-around;
				flex-wrap: wrap;

				.fun {
					display: flex;
					width: 100px;
					flex-direction: column;
					justify-content: center;
					align-items: center;

					image {
						width: 30px;
						height: 30px;
						border-radius: 50%;
						background-color: rgb(244, 245, 244);
						border: rgb(244, 245, 244) 2px solid;
					}

					text {
						margin-top: 10px;
						// font-weight: bold;
						font-size: 0.1em;
						font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
					}
				}
			}
		}

		.infoBox {
			height: auto;
			width: 96vw;
			margin-top: 20px;
			background-color: white;
			border-radius: 10px;
			flex-direction: column;
			align-items: center;

			.headInfo {
				display: flex;
				flex-direction: column;

				.title {
					margin: 5px 0 5px 3vw;
					font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
					font-weight: bold;
					font-size: small;
				}


			}

			.info {
				// background-color: ba;
				display: flex;
				flex-direction: row;
				width: 94vw;
				height: 120px;
				margin-left: 1vw;
				// background-color: antiquewhite;
				box-shadow: 2px 2px 2px #888;
				/* 水平偏移量 垂直偏移量 模糊半径 阴影颜色 */
				border-radius: 10px;
				align-items: center;
				justify-content: center;

				.headImage {
					width: 100px;
					height: 100px;
					background-color: rgba(101, 202, 215, 0.6);
					border-radius: 10px;
				}

				.center {

					width: 60%;
					display: flex;
					flex-direction: column;
					// flex-grow: 2;
					justify-content: space-between;

					.title {
						display: flex;
						flex-direction: row;
						align-items: center;

						// background-color: black;
						// width:30vw;
						.name {
							font-size: large;
							margin-right: 20px;
						}

						.intro {

							font-size: small;
							color: rgb(184, 184, 184);
						}

					}

					.doctorInfo {
						display: flex;
						flex-direction: column;
						width: 100%;

						.intro {
							font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
							color: rgb(184, 184, 184);
							margin-left: 10px;
							font-size: small;

						}

						.from {
							color: rgb(184, 184, 184);
							margin-left: 10px;
						}
					}

				}

				.but {
					// flex-grow: 1;
					width: 10vw;
					height: 100px;
					background-color: aquamarine;
					display: flex;
					justify-content: center;
					align-items: center;
					text-align: center;
					writing-mode: vertical-rl;
					/* 从上到下的垂直排列 */
					text-orientation: mixed;
					/* 设置文字方向 */
					font-weight: bold;
					color: #888;
					border-radius: 10px;
				}
			}

		}
	}
</style>
