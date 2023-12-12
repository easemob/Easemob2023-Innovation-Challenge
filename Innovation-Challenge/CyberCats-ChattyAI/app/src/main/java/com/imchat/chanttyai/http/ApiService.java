package com.imchat.chanttyai.http;


import com.imchat.chanttyai.beans.UserBean;

import java.util.List;
import java.util.Map;

import io.reactivex.Observable;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.QueryMap;
import retrofit2.http.Url;

public interface ApiService {
    @GET
    Call<ResponseBody> getUsers(@Url String url);
}
