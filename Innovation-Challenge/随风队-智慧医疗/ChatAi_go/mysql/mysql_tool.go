package mysql

import (
	"ChatAi_go/model"
	"ChatAi_go/setting"
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gorm.io/gorm/schema"
	"log"
	"os"
	"time"
)

var _db *gorm.DB

func init() {
	cfg := setting.Conf.MySQLConfig
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		cfg.User, cfg.Password, cfg.Host, cfg.Port, cfg.DB)

	var err error
	//_db, err = gorm.Open("mysql", dsn)

	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // io writer
		logger.Config{
			SlowThreshold:             200 * time.Millisecond, // 慢 SQL 阈值, 200ms
			LogLevel:                  logger.Info,            // 日志级别
			IgnoreRecordNotFoundError: true,                   // 忽略ErrRecordNotFound（记录未找到）错误
			Colorful:                  true,                   // 彩色打印
		})

	_db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{
		Logger: newLogger,
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true, //成功取消表明被加s
		},
	})

	if err != nil {
		panic("连接数据库失败, error=" + err.Error())
	}
	println("连接数据库成功")
	//设置数据库连接池参数
	sqlDB, err := _db.DB()
	sqlDB.SetMaxOpenConns(100) //设置数据库连接池最大连接数
	sqlDB.SetMaxIdleConns(20)  //连接池最大允许的空闲连接数，如果没有sql任务需要执行的连接数大于20，超过的连接会被连接池关闭。
	// 模型绑定
	err = _db.AutoMigrate(&model.User{}, &model.Record{})
	if err != nil {
		panic("模型绑定失败, error=" + err.Error())
	}
}
func GetDB() *gorm.DB {
	return _db
}
