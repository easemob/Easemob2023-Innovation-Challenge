import WebIM from "./WebIM";

export function SendMessage(content, groupId, userId) {
  return WebIM.backendApi.post("/message/sendMessage", {
    groupOrOwn: 0,
    content: content,
    contentType: 0,
    groupId: groupId,
    userId: userId,
  }).then((res) => {
    return res.data;
  });
}

export function GroupSummary(groupId) {
  return WebIM.backendApi.post("/bot/summary", {
    groupId: groupId,
  }).then((res) => {
    return res.data;
  });
}

export function RequestBot(groupId, userId) {
  return WebIM.backendApi.post("/bot/add", {
    groupId: groupId,
    userId: userId,
  }).then((res) => {
    return res.data;
  })
}

export function PromptList() {
  return WebIM.backendApi.get("/ai_prompt/list").then((res) => {
    return res.data;
  })
}

export function AskBot(content, promptId, userId, chatId) {
  return WebIM.backendApi.post("/bot/ask", {
    msg: content,
    promptId: promptId,
    toUserId: userId,
    chatId: chatId,
  }).then((res) => {
    return res.data;
  })
}

