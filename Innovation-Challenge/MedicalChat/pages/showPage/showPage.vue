<template>
	<view class="page">
		
		<view class="infoBox">
			<view class="headInfo">
				<text class="title">自助提问</text>
				<view class="searchBox">
					<uni-search-bar class="uni-mt-10" radius="100" placeholder="搜索医生,疾病" clearButton="none"
						cancelButton="none" @confirm="search" />
				</view>
				<view class="info">
					<image class="headImage" src="../../static/img/robot.png" image>
						<view class="center">
							<view class="title">
								<text class="name">医疗咨询机器人</text>
							</view>
							<view class="doctorInfo">
								<text class="intro">
									主治：白癜风，黑癜风，蓝癜风，癫痫。
								</text>
								<text class="from">
									主治
								</text>
							</view>
						</view>
						<view class="but" @click="goToPerson()">咨询一下</view>
				</view>
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
				<view class="	"></view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				items: ['按科室', '按疾病'],
				currentIndex: 0,
				doctorList:[],
				
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
		
			gotoShowPage(pageId){
				uni.navigateTo({
					url:'/pages/showPage/showPage'
				})
			},
			onClickItem(e) {
				if (this.currentIndex != e.currentIndex) {
					this.currentIndex = e.currentIndex;
				}
			}
		}
	}
</script>

<style lang="less">
	.page {
		width: 100vw;
		height: 100vh;
		// background-color: aliceblue;
		
		display: flex;
		flex-direction: column;
		align-items: center;

		// justify-content: center;
		view {
			width: 96vw;
			display: flex;
			// margin-left: 2vw;
		}

		

		.infoBox {
			height: auto;
			width: 96vw;
			// margin-top: 20px;
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
