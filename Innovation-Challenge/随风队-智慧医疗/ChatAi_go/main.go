package main

import (
	"ChatAi_go/mysql"
	"ChatAi_go/router"
	"ChatAi_go/setting"
	"fmt"
	"net/http"
	"time"
)

func main() {

	s := &http.Server{
		Addr:           fmt.Sprintf(":%d", setting.Conf.Port),
		Handler:        router.NewRouter(),
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	mysql.GetDB()
	err := s.ListenAndServe()
	if nil != err {
		print(err)
	}
}
