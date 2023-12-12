package com.imchat.chanttyai.utils;

import android.widget.Toast;

import com.imchat.chanttyai.base.App;
import com.imchat.chanttyai.utils.thread.ThreadManager;

public class ToastUtils {
    public static void toast(String msg){
        if (ThreadManager.getInstance().isMainThread()){
            Toast.makeText(App.getApplication(), msg, Toast.LENGTH_SHORT).show();
            return;
        }
        ThreadManager.getInstance().runOnMainThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(App.getApplication(), msg, Toast.LENGTH_SHORT).show();
            }
        });
    }
}
