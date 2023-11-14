package com.xinghe.project.model.entity;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class MessageBody {
    private String from;

    private List<String> to;

    private String type;

    private Map<String, String> body;
}
