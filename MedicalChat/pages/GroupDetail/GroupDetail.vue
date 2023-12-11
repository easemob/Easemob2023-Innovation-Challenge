<template>
	<view class="page">
		<view class="title">仁里真群聊</view>
		<image class="headImage" src="https://img2.baidu.com/it/u=881310448,2162246252&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"></image>
		<view class="infoBox">
			<view class="item">
				<view class="name">人数：</view>
				<view class="value">2</view>
			</view>
			<view class="item">
				<view class="name">管理员：</view>
				<view class="value">华强</view>
			</view>
			<view class="item">
				<view class="name">地区：</view>
				<view class="value">仁里镇灵山街</view>
			</view>
			
			
		</view>
		<view class="funBox">
			<view class="item">
				邀请人员
			</view>
			<view class="item">
				推出群
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				
			}
		},
		onLoad(option) {
			// uni.setNavigationBarTitle({
			// 	title:"仁里镇群聊"
			// })
		},
		methods: {
			
		}
	}
</script>

<style lang="less">
	.page{
		width: 100vw;
		height: 100vh;
		display: flex;
		flex-direction: column;
		background-color: rgba(188, 188, 188, 0.8);
		align-items: center;
		.title{
			font-size: large;
			font-weight: bold;
			margin: 10px 0 10px 0;
		}
		.headImage{
			height: 100px;
			width: 100px;
			border-radius: 50%;
		}
		.infoBox{
			margin-top: 40px;
			width: 96vw;
			border-radius: 15px;
			background-color: white;
			display: flex;
			flex-direction: column;
			align-items: center;
			.item{
				width: 80%;
				height: 40px;
				display: flex;
				font-size:large;
				align-items: center;
				.name{
					width: 50%;
					height: 100%;
					
					display: flex;
					justify-content: center;
					align-items: center;
				}
				.value{
					width: 50%;
					height: 100%;
					
					display: flex;
					justify-content: center;
					align-items: center;
					
				}
			}
		}
		
		.funBox{
			margin-top: 40px;
			width: 96vw;
			
			display: flex;
			flex-direction: column;
			align-items: center;
			.item{
				width: 100%;
				height: 40px;
				display: flex;
				font-size:large;
				border-radius: 15px;
				justify-content: center;
				background-color: white;
				align-items: center;
				margin: 5px 0 5px 0;
			}
		}
	}
</style>
