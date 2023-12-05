package api

import (
	"ChatAi_go/model"
	"ChatAi_go/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ResponseMsg struct {
	Code int         `json:"code"`
	Msg  string      `json:"msg"`
	Data interface{} `json:"data"`
}

func SuccessMsg(data interface{}) *ResponseMsg {
	msg := &ResponseMsg{
		Code: 200,
		Data: data,
	}
	return msg
}

func FailMsg(msg string) *ResponseMsg {
	msgObj := &ResponseMsg{
		Code: -1,
		Msg:  msg,
	}
	return msgObj
}
func GetUserDetails(c *gin.Context) {
	hid := c.Param("hid")
	err, m := service.UserService.GetUserDetails(hid)
	if err != nil {
		c.JSON(http.StatusOK, FailMsg(err.Error()))
		return
	}
	c.JSON(http.StatusOK, SuccessMsg(m))
}
func GetDoctorDetails(c *gin.Context) {
	err, m := service.UserService.GetDoctorDetails()
	if err != nil {
		c.JSON(http.StatusOK, FailMsg(err.Error()))
		return
	}
	c.JSON(http.StatusOK, SuccessMsg(m))
}
func AddUserInfo(c *gin.Context) {
	var user model.User
	err := c.ShouldBindJSON(&user)
	err = service.UserService.AddUserInfo(user)
	if err != nil {
		c.JSON(http.StatusOK, FailMsg(err.Error()))
		return
	}
	c.JSON(http.StatusOK, SuccessMsg(""))
}

func GetRecordDetails(c *gin.Context) {
	hid := c.Param("hid")
	err, m := service.UserService.GetRecordDetails(hid)
	if err != nil {
		c.JSON(http.StatusOK, FailMsg(err.Error()))
		return
	}
	c.JSON(http.StatusOK, SuccessMsg(m))
}
func AddRecordInfo(c *gin.Context) {
	var record model.Record
	err := c.ShouldBindJSON(&record)
	err = service.UserService.AddRecordInfo(record)
	if err != nil {
		c.JSON(http.StatusOK, FailMsg(err.Error()))
		return
	}
	c.JSON(http.StatusOK, SuccessMsg(""))
}
