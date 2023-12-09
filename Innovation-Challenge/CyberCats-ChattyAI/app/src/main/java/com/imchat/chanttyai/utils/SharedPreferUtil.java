package com.imchat.chanttyai.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.imchat.chanttyai.base.App;
import com.imchat.chanttyai.beans.UserBean;

import java.util.List;
import java.util.stream.Collectors;

public class SharedPreferUtil {
    private static final SharedPreferUtil ourInstance = new SharedPreferUtil();
    private static final String KEY_ACCOUNT = "key_account";
    private static final String KEY_USERS = "key_user";

    public static final String psw = "1234567890!@#";

    public static SharedPreferUtil getInstance() {
        return ourInstance;
    }

    private SharedPreferUtil() {
    }

    private final SharedPreferences mSharedPreference = App.getApplication().getSharedPreferences("chatty_config", Context.MODE_PRIVATE);


    public void setAccount(String account) {
        mSharedPreference.edit().putString(KEY_ACCOUNT, account).commit();
    }

    public String getAccount() {
        return mSharedPreference.getString(KEY_ACCOUNT, "");
    }

    public void saveUsers(String json) {
        mSharedPreference.edit().putString(KEY_USERS, json).commit();
    }

    public List<UserBean> getUsers(){
        String str = mSharedPreference.getString(KEY_USERS, "");
        return GsonUtils.toList(str, UserBean.class);
    }
    public UserBean getUserByAccount(String account){
        List<UserBean> users = getUsers();
        if (users != null && users.size() > 0){
            List<UserBean> list = users.stream().filter(bean -> TextUtils.equals(account, bean.getAccount())).collect(Collectors.toList());
            if (list.size() > 0){
                return list.get(0);
            }
        }
        return new UserBean();
    }
}
