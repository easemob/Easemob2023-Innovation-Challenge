package setting

import "gopkg.in/ini.v1"

var Conf = new(AppConfig)

// AppConfig 应用程序配置
type AppConfig struct {
	Port         int `ini:"port"`
	*MySQLConfig `ini:"mysql"`
}

// MySQLConfig 数据库配置
type MySQLConfig struct {
	User     string `ini:"user"`
	Password string `ini:"password"`
	DB       string `ini:"db"`
	Host     string `ini:"host"`
	Port     int    `ini:"port"`
}

func init() {
	c, err := ini.Load("./conf/config.ini")
	err = c.MapTo(&Conf)
	if err != nil {
		panic("加载配置失败, error=" + err.Error())
	}
}
