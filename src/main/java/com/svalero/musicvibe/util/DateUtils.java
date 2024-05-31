package com.svalero.musicvibe.util;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import static com.svalero.musicvibe.util.Constants.DATE_PATTERN;

public class DateUtils {
    public static String format(Date date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_PATTERN);
        return dateFormat.format(date);
    }

    public static Date parse(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_PATTERN);
        return new Date(dateFormat.parse(date).getTime());
    }

    public static String convertSecondsToMinutes(int seconds) {
        int minutes = seconds / 60;
        int remainingSeconds = seconds % 60;
        return String.format("%02d:%02d", minutes, remainingSeconds);
    }

    public static int convertMinutesToSeconds(String minutes) {
        int mm = Integer.parseInt(minutes.split(":")[0]);
        int ss = Integer.parseInt((minutes.split(":")[1]));
        ss = mm * 60 + ss;
        return ss;
    }
}
