package com.imchat.chanttyai.utils;

import android.text.TextUtils;

import com.imchat.chanttyai.R;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class UserUtil {

    private static UserUtil userUtil;
    public static UserUtil getInstance(){
        if (userUtil == null){
            userUtil = new UserUtil();
        }
        return userUtil;
    }
    private static final List<ShowUser> showUserList = new ArrayList<>();

    private UserUtil(){
        showUserList.add(new ShowUser("boy0", R.mipmap.bg_male_0,R.mipmap.avatar_male_0));
        showUserList.add(new ShowUser("boy1", R.mipmap.bg_male_1,R.mipmap.avatar_male_1));
        showUserList.add(new ShowUser("boy2", R.mipmap.bg_male_2,R.mipmap.avatar_male_2));
        showUserList.add(new ShowUser("boy3", R.mipmap.bg_male_3,R.mipmap.avatar_male_3));

        showUserList.add(new ShowUser("girl0", R.mipmap.bg_female_0,R.mipmap.avatar_female_0));
        showUserList.add(new ShowUser("girl1", R.mipmap.bg_female_1,R.mipmap.avatar_female_1));
        showUserList.add(new ShowUser("girl2", R.mipmap.bg_female_2,R.mipmap.avatar_female_2));
        showUserList.add(new ShowUser("girl3", R.mipmap.bg_female_3,R.mipmap.avatar_female_3));
    }

    public int getBgRes(String account){
        List<ShowUser> list = showUserList.stream().filter(showUser -> TextUtils.equals(account, showUser.account)).collect(Collectors.toList());
        if (list.size() > 0){
            return list.get(0).bgRes;
        }
        return -1;
    }

    public int getAvatarRes(String account){
        List<ShowUser> list = showUserList.stream().filter(showUser -> TextUtils.equals(account, showUser.account)).collect(Collectors.toList());
        if (list.size() > 0){
            return list.get(0).avatarRes;
        }
        return -1;
    }

    static class ShowUser{
        private String account;
        private int bgRes;
        private int avatarRes;

        public ShowUser(String account, int bgRes, int avatarRes) {
            this.account = account;
            this.bgRes = bgRes;
            this.avatarRes = avatarRes;
        }

        public String getAccount() {
            return account;
        }

        public void setAccount(String account) {
            this.account = account;
        }

        public int getBgRes() {
            return bgRes;
        }

        public void setBgRes(int bgRes) {
            this.bgRes = bgRes;
        }

        public int getAvatarRes() {
            return avatarRes;
        }

        public void setAvatarRes(int avatarRes) {
            this.avatarRes = avatarRes;
        }
    }
}
