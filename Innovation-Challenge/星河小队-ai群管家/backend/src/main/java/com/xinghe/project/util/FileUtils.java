package com.xinghe.project.util;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.xinghe.project.common.ErrorCode;
import com.xinghe.project.exception.BusinessException;
import com.xinghe.project.model.entity.Message;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
public class FileUtils {

    /**
     * 读取excel文件，生成对象列表
     * @return
     */
    public static List<Message> excelToMessageList(MultipartFile multipartFile) {

        // 读取excel数据
        List<Map<Integer, String>> list = null;
        try {
            list = EasyExcel.read(multipartFile.getInputStream())
                    .excelType(ExcelTypeEnum.XLSX)
                    .sheet()
                    .headRowNumber(0)
                    .doReadSync();
        } catch (Exception e) {
            log.error("表格处理错误");
        }

        System.out.println(list);

        List<Message> messageList = new ArrayList<>();
        for (int i = 1; i < list.size(); i++) {
            Map<Integer, String> map = list.get(i);
            Message message = new Message();
            message.setGroupOrOwn(Integer.parseInt(map.get(0)));
            message.setContent(map.get(1));
            message.setContentType(Integer.parseInt(map.get(2)));
            message.setGroupId(map.get(3));
            message.setUserId(map.get(4));
            messageList.add(message);
        }
        return messageList;
    }

}
