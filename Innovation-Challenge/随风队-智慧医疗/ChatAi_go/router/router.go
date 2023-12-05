package router

import (
	"ChatAi_go/api"
	"github.com/gin-gonic/gin"
	"net/http"
	"net/http/httputil"
	"net/url"
)

func NewRouter() *gin.Engine {
	gin.SetMode(gin.ReleaseMode)

	server := gin.Default()
	group := server.Group("")
	{
		group.GET("/user/:hid", api.GetUserDetails)
		group.GET("/user/doctor", api.GetDoctorDetails)

		group.POST("/user/add", api.AddUserInfo)
		group.GET("/record/:hid", api.GetRecordDetails)
		group.POST("/record/add", api.AddRecordInfo)
	}
	return server
}
func reverseProxy(target string) http.HandlerFunc {
	targetURL, _ := url.Parse(target)
	proxy := httputil.NewSingleHostReverseProxy(targetURL)
	return func(w http.ResponseWriter, r *http.Request) {
		r.URL.Host = targetURL.Host
		r.URL.Scheme = targetURL.Scheme
		r.Header.Set("X-Forwarded-Host", r.Header.Get("Host"))
		r.Host = targetURL.Host
		proxy.ServeHTTP(w, r)
	}
}
