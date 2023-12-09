package com.imchat.chanttyai.utils;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;

import com.imchat.chanttyai.R;
import com.imchat.chanttyai.ui.activity.MainActivity;

public class NotificationHelper {
    private static final String CHANNEL_ID = "chatty_channel";
    private static final String CHANNEL_NAME = "Chatty Channel";
    private static final String CHANNEL_DESCRIPTION = "Chatty Channel Description";
    private static final int NOTIFICATION_ID = 1;
    @SuppressLint("NewApi")
    public static void showNotification(Context context, String title, String message) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        // 创建通知渠道（适用于 Android 8.0 及以上版本）
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH);
            channel.setDescription(CHANNEL_DESCRIPTION);
            channel.enableLights(true);
            channel.setLightColor(Color.RED);
            notificationManager.createNotificationChannel(channel);
        }

        // 创建通知点击后的跳转意图
        Intent intent = new Intent(context, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE);

        // 创建通知
        Notification.Builder builder = new Notification.Builder(context, CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(message)
                .setSmallIcon(R.mipmap.logo)
                .setAutoCancel(true) // 点击通知后自动取消
                .setContentIntent(pendingIntent);

        // 显示通知
        notificationManager.notify(NOTIFICATION_ID, builder.build());
    }
}
