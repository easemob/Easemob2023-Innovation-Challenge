package model

type Record struct {
	Id        uint64 `json:"id,omitempty" gorm:"primary_key;comment:'主键ID'"`
	Hid       string `json:"hid,omitempty" gorm:"type:varchar(150);not null;comment:'环信ID'"`
	ToHid     string `json:"to_hid,omitempty" gorm:"type:varchar(150);not null;comment:'对方环信ID'"`
	Name      string `json:"name,omitempty" gorm:"type:varchar(50);not null;comment:'对方姓名'"`
	Detail    string `json:"detail,omitempty" gorm:"type:varchar(4096);comment:'详情'"`
	Timestamp uint64 `json:"timestamp,omitempty" gorm:"comment:'时间搓'"`
}
