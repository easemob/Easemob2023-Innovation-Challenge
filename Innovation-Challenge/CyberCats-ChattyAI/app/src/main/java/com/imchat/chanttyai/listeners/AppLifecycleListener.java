package com.imchat.chanttyai.listeners;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

public class AppLifecycleListener implements Application.ActivityLifecycleCallbacks {
    private int foregroundActivities = 0;

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
    }

    @Override
    public void onActivityStarted(Activity activity) {
        foregroundActivities++;
    }

    @Override
    public void onActivityResumed(Activity activity) {
    }

    @Override
    public void onActivityPaused(Activity activity) {
    }

    @Override
    public void onActivityStopped(Activity activity) {
        foregroundActivities--;
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
    }

    public boolean isAppInForeground() {
        return foregroundActivities > 0;
    }
}
