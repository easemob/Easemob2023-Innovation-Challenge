package model

type User struct {
	Id         uint64 `json:"id,omitempty" gorm:"primary_key;comment:'主键ID'"`
	Hid        string `json:"hid,omitempty" gorm:"type:varchar(150);not null;comment:'环信ID'"`
	Name       string `json:"name,omitempty" gorm:"type:varchar(50);not null;comment:'姓名'"`
	Role       string `json:"role,omitempty" gorm:"type:varchar(1);not null;comment:'角色 0用户 1医生'"`
	Department string `json:"department,omitempty" gorm:"type:varchar(50);comment:'科室'"`
	Info       string `json:"info,omitempty" gorm:"type:varchar(1024);comment:'个人信息'"`
	Status     string `json:"status,omitempty" gorm:"type:varchar(1);not null;comment:'上班状态 0不上班 1上班'"`
	Gender     string `json:"gender,omitempty" gorm:"type:varchar(4);not null;comment:'性别'"`
	Birth      string `json:"birth,omitempty" gorm:"type:varchar(10);not null;comment:'出生年'"`
	Timestamp  uint64 `json:"timestamp,omitempty" gorm:"comment:'时间搓'"`
}
