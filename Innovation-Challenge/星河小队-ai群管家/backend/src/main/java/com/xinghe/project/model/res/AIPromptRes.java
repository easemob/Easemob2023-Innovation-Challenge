package com.xinghe.project.model.res;

import com.xinghe.project.model.entity.AiPrompt;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AIPromptRes {
    private Long id;

    /**
     * prompt描述
     */
    private String description;

    public static AIPromptRes toModel(AiPrompt aiPrompt) {
        return AIPromptRes.builder()
                .id(aiPrompt.getId())
                .description(aiPrompt.getDescription())
                .build();
    }
}
