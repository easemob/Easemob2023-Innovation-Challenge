import websdk from "easemob-websdk";

let WebIM = websdk;
WebIM.myconf = {
  orgName: '1182231114210382',
  appName: 'aigc',
  host: 'https://a1.easecdn.com',
  apiHost: 'https://a1.easecdn.com/1182231114210382/aigc/'
  
}
WebIM.conn = new WebIM.connection({
    appKey: '1182231114210382#aigc',
    apiUrl: 'https://a1.easecdn.com'//'http://im-api-wechat.easemob.com'//'http://47.95.246.247'//'https://im-api-wechat.easemob.com'
})

// 添加回调函数。
WebIM.conn.addEventHandler('connection&message', {
    onConnected: () => {
        // document.getElementById("log").appendChild(document.createElement('div')).append("Connect success !")
        console.log('Connect success !')
    },
    onDisconnected: () => {
        // document.getElementById("log").appendChild(document.createElement('div')).append("Logout success !")
        console.log('Logout success !')
    },
    onTextMessage: (message) => {
        console.log(message)
        // document.getElementById("log").appendChild(document.createElement('div')).append("Message from: " + message.from + " Message: " + message.msg)
    },
    onError: (error) => {
        console.log('on error', error)
    }
})
export default WebIM;