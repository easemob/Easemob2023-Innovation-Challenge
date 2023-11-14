package com.xinghe.project.util;

import com.alibaba.fastjson.JSONObject;
public class FastJsonUtils {

//    public static String unescape(String json) {
//        Pattern pattern = Pattern.compile("\\\\([\"\\\\/bfnrt])");
//        Matcher matcher = pattern.matcher(json);
//        while (matcher.find()) {
//            String escapeSequence = matcher.group(1);
//            String unescaped = null;
//            if (escapeSequence.equals("\"")) {
//                unescaped = "\"";
//            } else if (escapeSequence.equals("\\")) {
//                unescaped = "\\\\";
//            } else if (escapeSequence.equals("/")) {
//                unescaped = "/";
//            } else if (escapeSequence.equals("b")) {
//                unescaped = "\b";
//            } else if (escapeSequence.equals("f")) {
//                unescaped = "\f";
//            } else if (escapeSequence.equals("n")) {
//                unescaped = "\n";
//            } else if (escapeSequence.equals("r")) {
//                unescaped = "\r";
//            } else if (escapeSequence.equals("t")) {
//                unescaped = "\t";
//            }
//            if (unescaped != null) {
//                jsonStr = jsonStr.replace("\\\\" + escapeSequence, unescaped);
//            }
//        }
//    }

    /**
     * 解析json数据
     */
    public static JSONObject parse(String json){

        //最顶层的JSON对象
        JSONObject root = JSONObject.parseObject(json);
        System.out.println("json数据："+root);
        return root;
        //获得整型数据
//        int code = root.getInteger("code");
//        boolean success = root.getBoolean("success");
//        if(!success) {
//            log.warn("");
//        }
//        //获得字符串型数据
//        String body = root.getString("body");
//        System.out.println(body);
//        return body;
    }
}
