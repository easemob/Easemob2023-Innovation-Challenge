<script>
	import initApp from '@/common/appInit.js';
	import openApp from '@/common/openApp.js';
	// #ifdef H5
		openApp() //创建在h5端全局悬浮引导用户下载app的功能
	// #endif
	import checkIsAgree from '@/pages/uni-agree/utils/uni-agree.js';
	import uniIdPageInit from '@/uni_modules/uni-id-pages/init.js';
	export default {
		globalData: {
			searchText: '',
			appVersion: {},
			config: {},
			$i18n: {},
			$t: {}
		},
		onLaunch: function() {
			console.log('App Launch')
			this.globalData.$i18n = this.$i18n
			this.globalData.$t = str => this.$t(str)
			initApp();
			uniIdPageInit()
			this.initIM()
			// #ifdef APP-PLUS
			//checkIsAgree(); APP端暂时先用原生默认生成的。目前，自定义方式启动vue界面时，原生层已经请求了部分权限这并不符合国家的法规
			// #endif

			// #ifdef H5
			// checkIsAgree(); // 默认不开启。目前全球，仅欧盟国家有网页端同意隐私权限的需要。如果需要可以自己去掉注视后生效
			// #endif

			// #ifdef APP-PLUS
			//idfa有需要的用户在应用首次启动时自己获取存储到storage中
			/*var idfa = '';
			var manager = plus.ios.invoke('ASIdentifierManager', 'sharedManager');
			if(plus.ios.invoke(manager, 'isAdvertisingTrackingEnabled')){
				var identifier = plus.ios.invoke(manager, 'advertisingIdentifier');
				idfa = plus.ios.invoke(identifier, 'UUIDString');
				plus.ios.deleteObject(identifier);
			}
			plus.ios.deleteObject(manager);
			console.log('idfa = '+idfa);*/
			// #endif
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		},
	
		methods:{
			async initIM(){
				var nikename
				var headImage
				var options = {
				    user: 'pTang',
				    pwd: '1234',
				    appKey: '1107230401163269#chatroom',
				    success: function (res) {
						console.log("登录成功。。。。。。。。。。。")
				      var token = res.access_token
					  
				    },
				    error: function(res){
						console.log(res)
				    }
				}
				nikename="测试用户1"
				headImage="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F20%2F20200320234526_VNsRH.thumb.1000_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1688282252&t=e719a45a2ffd42d887236e87a583778e"
				console.log("ddddddddddddd")
				var t=await this.$WebIM.conn.open(options)
				console.log("ttttttttttttttt",t)
				this.$WebIM.user={
					userId:options.user,
					nikename:nikename,
					headImage:headImage
				}
			}
		}
	}
</script>

<style>
	/*每个页面公共css */
</style>
