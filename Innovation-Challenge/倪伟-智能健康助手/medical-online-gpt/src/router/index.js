import React from 'react'
import {Switch,Route,Redirect,withRouter} from 'react-router-dom'
// 导入组件
import Home from '../pages/Home'
import LoginPage from '../pages/Login'
import NotFound from '../pages/404'


// 自定义路由规则
const  routes = [
    // 重定向规则
    {
        path:'/',//路径
        redirect:'/home',//重定向
        exact:true,//是否精准匹配  true:是  false:否
    },
    // 普通路由规则
    {
        path:'/home',//路径
        component:Home,//组件
        exact:true,//是否精准匹配 true:是  false:否
        isLogin:false,//是否需要做登录验证  true:是  false:否
        meta:{title:'智能健康管家'},//路由元信息
    },
    {
        path:'/login',//路径
        component:LoginPage,//组件
        exact:true,//是否精准匹配 true:是  false:否
        isLogin:false,//是否需要做登录验证  true:是  false:否
        meta:{title:'智能健康管家'},//路由元信息
    },
    {
        path:'*',//访问不存在的路径
        component:NotFound,
        exact:true,//是否精准匹配 true:是  false:否
        isLogin:false,//是否需要做登录验证  true:是  false:否
        meta:{title:'404页面'},//路由元信息
    }
]


// 声明函数组件
function RouterView(){
    return (
        <Switch>
            {routes.map(item=>{
                // 判断是否有component
                if(item.component){
                   return <Route key={item.path} path={item.path} exact={item.exact}
                   render={()=>{
                    //    render属性其目的是为了渲染组件  可以做条件判断
                    // component属性其目的也是为了渲染组件
                    
                    // 1.设置路由元信息
                    if(item.meta) document.title = item.meta.title
                    // 2.登录验证
                    if(item.isLogin){
                        // 需要登录
                        if(!sessionStorage.getItem('user')){
                            return <Redirect to="/login"></Redirect>
                        }
                    }
                    const Component= withRouter(item.component)
                    return <Component></Component>

                   }}></Route>    
                }

                // 此处没有componnet  即为路由重定向
                return <Redirect key={item.path} path={item.path} to={item.redirect} exact={item.exact}></Redirect>
            })}
        </Switch>
    )
}

// 导出组件
export default RouterView