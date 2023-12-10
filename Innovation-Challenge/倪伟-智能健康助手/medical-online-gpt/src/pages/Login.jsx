import React, { useState } from "react";
import WebIM from 'easemob-websdk'
import { useHistory } from "react-router-dom";
import './Login.css';
export default function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  let history = useHistory();
  WebIM.conn = new WebIM.connection({
        //注意这里的 "K" 需大写。
        appKey: '1139221107140394#medical-online-gpt',
    })
  const handleLogin = () => {
    WebIM.conn
            .open({ user: username, pwd: password })
            .then((res) => {
               let userid = username;
               history.push({pathname:'./home',query:{userid:userid}});
            })
            .catch((e) => {
                alert('登陆失败');
            });
  };

  const handleRegiter = ()=>{
    WebIM.conn
            .registerUser({ username: username, password: password })
            .then((res) => {
                alert("注册成功，请登陆!")
            })
            .catch((e) => {
                alert("注册失败!")
            });
  }



  return (
    <div className="login-container">
      <div className="subContainer">
      <h2>智能健康管家</h2>
      <form style={{display:"flex",marginTop:'20px',alignItems:'center',flexDirection:'column'}}>
        <div className="form-group">
          <label>用户名:</label>
          <input
            type="text"
            style={{width:'180px'}}
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
        </div>
        <div className="form-group">
          <label>密 码 :</label>
          <input
            type="text"
            style={{width:'180px'}}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <div style={{display:'flex', flexDirection:'row'}}>
            <button style={{width:"120px",borderRadius:'4px'}} onClick={handleRegiter}>注 册</button>
            <button style={{width:"120px",borderRadius:'4px',marginLeft:'20px'}} onClick={handleLogin}>登 陆</button>
        </div>
      </form>
      </div>
    </div>
  );
}