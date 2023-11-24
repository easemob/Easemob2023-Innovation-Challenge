const MENTION_ALL = 'ALL'
const BOT_NAME = 'user_bot'

const COMMAND_LIST = [
    { name: "summary", desc: "bot总结群历史消息", isGroup: true },
    { name: "add", desc: "向群中添加bot(如果已经存在则自动忽略)", isGroup: true },
    { name: "list", desc: "获取当前支持的ai助手角色", isGroup: false },
    { name: "use", desc: "使用ai助手角色", isGroup: false },
    { name: "ask", desc: "向ai助手提问", isGroup: false },
    { name: "help", desc: "显示帮助", isGroup: false },
    { name: "help", desc: "显示帮助", isGroup: true },
  ];

export {
    MENTION_ALL,
    BOT_NAME,
    COMMAND_LIST
}
