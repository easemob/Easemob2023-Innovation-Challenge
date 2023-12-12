package com.imchat.chanttyai.utils;

import android.annotation.SuppressLint;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtils {

    public static String formatTimestamp(long timestamp, boolean showTime) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(timestamp);

        String timeFormat = showTime ? " HH:mm" : "";

        Calendar currentCalendar = Calendar.getInstance();

        if (isSameDay(calendar, currentCalendar)) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm", Locale.getDefault());
            return dateFormat.format(new Date(timestamp));
        }
        if (isYesterday(calendar, currentCalendar)) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("昨天" + timeFormat, Locale.getDefault());
            return dateFormat.format(new Date(timestamp));
        }
        if (isYesterday(calendar, currentCalendar)) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("前天" + timeFormat, Locale.getDefault());
            return dateFormat.format(new Date(timestamp));
        }
        if (isWithinOneWeek(calendar, currentCalendar)) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE" + timeFormat, Locale.getDefault());
            return dateFormat.format(new Date(timestamp));
        }
        if (isWithinOneYear(calendar, currentCalendar)) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("M月d日" + timeFormat, Locale.getDefault());
            return dateFormat.format(new Date(timestamp));
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年M月d日" + timeFormat, Locale.getDefault());
        return dateFormat.format(new Date(timestamp));
    }

    private static boolean isSameDay(Calendar calendar1, Calendar calendar2) {
        return calendar1.get(Calendar.YEAR) == calendar2.get(Calendar.YEAR) &&
                calendar1.get(Calendar.MONTH) == calendar2.get(Calendar.MONTH) &&
                calendar1.get(Calendar.DAY_OF_MONTH) == calendar2.get(Calendar.DAY_OF_MONTH);
    }

    private static boolean isYesterday(Calendar calendar1, Calendar calendar2) {
        calendar2.add(Calendar.DAY_OF_MONTH, -1);
        return isSameDay(calendar1, calendar2);
    }

    private static boolean isTwoDaysAgo(Calendar calendar1, Calendar calendar2) {
        calendar2.add(Calendar.DAY_OF_MONTH, -2);
        return isSameDay(calendar1, calendar2);
    }

    private static boolean isWithinOneWeek(Calendar calendar1, Calendar calendar2) {
        calendar2.add(Calendar.DAY_OF_MONTH, -6);
        return calendar1.after(calendar2);
    }

    private static boolean isWithinOneYear(Calendar calendar1, Calendar calendar2) {
        calendar2.add(Calendar.YEAR, -1);
        return calendar1.after(calendar2);
    }

    public static String format(long timestamp) {
        // 创建一个SimpleDateFormat对象，指定日期时间的格式
        @SuppressLint("SimpleDateFormat") SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        // 将时间戳转换为Date对象
        Date date = new Date(timestamp);
        // 使用SimpleDateFormat格式化Date对象为字符串
        return sdf.format(date);
    }
}
