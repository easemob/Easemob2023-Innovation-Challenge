package com.imchat.chanttyai.livedatas;


import java.io.Serializable;

/**
 *
 */
public class LiveEvent implements Serializable {
    public String event;
    public String message;
    public boolean flag;

    public LiveEvent() {}

    public LiveEvent(String event) {
        this.event = event;
    }

    public LiveEvent(String event, String message) {
        this.event = event;
        this.message = message;
    }

    public LiveEvent(boolean flag) {
        this.flag = flag;
    }
}
