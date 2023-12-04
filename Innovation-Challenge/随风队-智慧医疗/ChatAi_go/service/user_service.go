package service

import (
	"ChatAi_go/model"
	"ChatAi_go/mysql"
	"errors"
	"time"
)

type userService struct {
}

var UserService = new(userService)

func (u *userService) GetUserDetails(hid string) (error, *model.User) {
	var userModel model.User
	db := mysql.GetDB()
	res := db.First(&userModel, "hid = ?", hid)
	if res.RowsAffected == 0 {
		return errors.New("用户不存在"), nil
	}
	return nil, &userModel
}
func (u *userService) GetDoctorDetails() (error, *[]model.User) {
	var userModel []model.User
	db := mysql.GetDB()
	res := db.Find(&userModel, "role = ?", 1)
	if res.RowsAffected == 0 {
		return errors.New("用户不存在"), nil
	}
	return nil, &userModel
}

func (u *userService) AddUserInfo(model model.User) error {
	db := mysql.GetDB()
	model.Timestamp = uint64(time.Now().UnixMilli())
	res := db.Create(&model)
	if res.RowsAffected == 0 {
		return res.Error
	}
	return nil
}

func (u *userService) GetRecordDetails(hid string) (error, *[]model.Record) {
	var recordList []model.Record
	db := mysql.GetDB()
	res := db.Order("timestamp DESC").Find(&recordList, "hid = ?", hid)
	if res.RowsAffected == 0 {
		return errors.New("记录不存在"), nil
	}
	return nil, &recordList
}
func (u *userService) AddRecordInfo(model model.Record) error {
	db := mysql.GetDB()
	model.Timestamp = uint64(time.Now().UnixMilli())
	res := db.Create(&model)
	if res.RowsAffected == 0 {
		return res.Error
	}
	return nil
}
