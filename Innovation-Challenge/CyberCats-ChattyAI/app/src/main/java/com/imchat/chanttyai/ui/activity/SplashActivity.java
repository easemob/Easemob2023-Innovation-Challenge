package com.imchat.chanttyai.ui.activity;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.hyphenate.EMCallBack;
import com.hyphenate.chat.EMClient;
import com.imchat.chanttyai.base.App;
import com.imchat.chanttyai.base.AppManager;
import com.imchat.chanttyai.base.BaseActivity;
import com.imchat.chanttyai.databinding.ActivitySplashBinding;
import com.imchat.chanttyai.utils.SharedPreferUtil;
import com.imchat.chanttyai.utils.ToastUtils;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SplashActivity extends BaseActivity<ActivitySplashBinding> {

    private static final int WHAT_LOGIN = 0;
    private static final int WHAT_MAIN = 1;
    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(@NonNull Message msg) {
            switch (msg.what) {
                case WHAT_LOGIN:
                    AppManager.getInstance().finishActivity(SplashActivity.this);
                    LoginActivity.start(SplashActivity.this);
                    break;
                case WHAT_MAIN:
                    AppManager.getInstance().finishActivity(SplashActivity.this);
                    MainActivity.start(mContext);
                    break;
                default:
                    break;
            }

        }
    };

    @Override
    protected ActivitySplashBinding getViewBinding() {
        return ActivitySplashBinding.inflate(getLayoutInflater());
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initData() {
        getUsers();
    }

    private void login(String account) {
        if (EMClient.getInstance().isLoggedIn()) {
            gotoMain();
            return;
        }
        EMClient.getInstance().login(account, SharedPreferUtil.psw, new EMCallBack() {
            // 登录成功回调
            @Override
            public void onSuccess() {
                gotoMain();
            }

            // 登录失败回调，包含错误信息
            @Override
            public void onError(final int code, final String error) {
                ToastUtils.toast(error);
            }

            @Override
            public void onProgress(int i, String s) {

            }

        });
    }

    private void getUsers() {
        App.getApi().getUsers("http://119.3.158.229/getBotUsers")
                .enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                        try {
                            SharedPreferUtil.getInstance().saveUsers(response.body().string());
                            String account = SharedPreferUtil.getInstance().getAccount();
                            if (TextUtils.isEmpty(account)) {
                                gotoLogin();
                                return;
                            }
                            login(account);
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {

                    }
                });
    }

    private void gotoMain() {
        mHandler.sendEmptyMessageDelayed(WHAT_MAIN, 2000);
    }

    private void gotoLogin() {
        mHandler.sendEmptyMessageDelayed(WHAT_LOGIN, 2000);
    }

    @Override
    protected void initListener() {

    }
}
