let customizeConfig = uni.getStorageSync('customizeConfig')
if(!customizeConfig){
  customizeConfig = {serverHost:"",serverApiYy:""}
}
else if(!customizeConfig.serverHost){
  customizeConfig.serverHost = http://101.126.29.188:8080'
}
var Config = {
  completion: customizeConfig.serverHost+'/completion',
  friendship: customizeConfig.serverHost+'/friendship',
  customizeConfig: customizeConfig
}
export default Config;