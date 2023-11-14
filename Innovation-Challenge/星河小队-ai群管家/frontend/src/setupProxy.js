
const proxy = require('http-proxy-middleware');
// 这个玩意不用下，react里自己带了
 
module.exports = function(app) {
    app.use(
        proxy('/api', {  // 发送请求的时候 react会自动去找这个api1，匹配这个路径，然后去发送对的请求
            target: 'http://localhost:8001',
            changeOrigin: true, //控制服务器接收到的请求头中host字段的值
            pathRewrite: {'^/api': ''} // 跟上面匹配，这个api1只是找这个路径用的，实际接口中没有api1，所以找个目标地址后，要把api1给替换成空
        }),
        // changeOrigin设置为true时，服务器收到的请求头中的host为：localhost:5000
        // changeOrigin设置为false时，服务器收到的请求头中的host为：localhost:3000
        // 注意！！注意！！注意！！ changeOrigin默认值为false，需要我们自己动手把changeOrigin值设为true
        // proxy('/boot', {
        //     target: 'http://localhost:5001',
        //     changeOrigin: true,
        //     pathRewrite: {'^/api2': ''}
        // }),
    )
}
