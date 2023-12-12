/**
 *  \~chinese
 *  @header IEMChatManager.h
 *  @abstract 聊天相关操作代理协议。
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatManager.h
 *  @abstract This protocol defines the operations of chat.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCommonDefs.h"
#import "EMChatManagerDelegate.h"
#import "EMConversation.h"

#import "EMChatMessage.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMCmdMessageBody.h"
#import "EMFileMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"
#import "EMCustomMessageBody.h"
#import "EMCombineMessageBody.h"
#import "EMCursorResult.h"

#import "EMGroupMessageAck.h"
#import "EMTranslateLanguage.h"
#import "EMFetchServerMessagesOption.h"

/**
 *  \~chinese
 *  漫游消息的拉取方向枚举类型。
 *
 *  \~english
 *  The directions in which historical messages are retrieved from the server.
 */
typedef NS_ENUM(NSUInteger, EMMessageFetchHistoryDirection) {
    EMMessageFetchHistoryDirectionUp  = 0,    /** \~chinese SDK 按消息中的时间戳的逆序查询。  \~english The SDK retrieves messages in the descending order of the timestamp included in them.*/
    EMMessageFetchHistoryDirectionDown        /** \~chinese SDK 按消息中的时间戳的正序查询。 \~english The SDK retrieves messages in the ascending order of the timestamp included in them. 
 **/
};


@class EMError;

/**
 *  \~chinese
 *  聊天相关操作代理协议。
 * 
 *  消息都是从本地数据库中加载，不是从服务端加载。
 *
 *  \~english
 *  This protocol that defines the operations of chat.
 * 
 *  Messages are loaded from the local database, not from the server.
 */
@protocol IEMChatManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \~chinese
 *  添加回调代理。
 *
 *  @param aDelegate  实现代理协议的对象。
 *  @param aQueue     执行代理方法的队列。若在主线程上运行 app，将该参数设置为空。
 *
 *  \~english
 *  Adds a delegate.
 *
 *  @param aDelegate  The object that implements the protocol.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<EMChatManagerDelegate> _Nullable)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \~chinese
 *  移除回调代理。
 *
 *  @param aDelegate  要移除的代理。
 *
 *  \~english
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id<EMChatManagerDelegate> _Nonnull)aDelegate;

#pragma mark - Conversation

/**
 *  \~chinese
 *  获取本地所有会话。
 * 
 * 该方法会先从内存中获取，如果未找到任何会话，从本地数据库获取。
 *
 *  @result 会话列表，NSArray<EMConversation *> * 类型。
 *
 *  \~english
 *  Gets all local conversations. 
 * 
 * The SDK loads the conversations from the memory first. If no conversation is found in the memory, the SDK loads from the local database.
 *
 *  @result The conversation list of the NSArray<EMConversation *> * type.
 */
- (NSArray<EMConversation *> * _Nullable)getAllConversations;

/**
 *  \~chinese
 *  获取本地所有会话。
 *
 *  该方法会先从内存中获取，如果未找到任何会话，SDK 从本地数据库获取。
 *
 *  @param isSort 是否对会话排序。
 *          - YES: YES。SDK 按照最近一条消息的时间戳的倒序返回会话，置顶会话在前，非置顶会话在后。
 *          - NO: NO
 *  @result 会话列表，NSArray<EMConversation *> * 类型。
 *
 *  \~english
 *  Gets all local conversations.
 * 
 *  The SDK loads the conversations from the memory first. If there is no conversation is in the memory, the SDK loads from the local database.
 *
 *  @param isSort Whether to sort the conversations. 
 *          - YES: Yes. The SDK returns conversations in the descending order of the timestamp of the latest message in them, with the pinned ones at the top of the list and followed by the unpinned ones.
 *          - NO: No.
 *  @result The conversation list of the NSArray<EMConversation *> * type.
 */
- (NSArray<EMConversation *> * _Nullable)getAllConversations:(BOOL)isSort;

/**
 *  \~chinese
 *  从服务器获取所有会话。
 * 
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets all conversations from the server.
 * 
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)getConversationsFromServer:(void (^_Nullable)(NSArray<EMConversation *> * _Nullable aConversations, EMError * _Nullable aError))aCompletionBlock EM_DEPRECATED_IOS(4_0_0, "Use -IEMChatManager getConversationsFromServerWithCursor:pageSize:completion");

/**
 *  \~chinese
 *  从服务器分页获取会话。
 *
 *  @param pageNumber 当前页码，从 1 开始。
 *  @param pageSize 每页获取的的会话数。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets conversations from the server with pagination.
 *
 *  @param pageNumber The current page number, starting from 1.
 *  @param pageSize The number of conversations that you expect to get on each page.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)getConversationsFromServerByPage:(NSUInteger)pageNumber
                                pageSize:(NSUInteger)pageSize
                              completion:(void (^_Nullable)(NSArray<EMConversation *> * _Nullable aConversations, EMError * _Nullable aError))aCompletionBlock EM_DEPRECATED_IOS(4_0_0, "Use -IEMChatManager getConversationsFromServerWithCursor:pageSize:completion");
/**
 *  \~chinese
 * 分页从服务器获取获取会话列表。
 * 
 * SDK 按照会话活跃时间（会话的最后一条消息的时间戳）倒序返回会话列表。
 * 
 * 若会话中没有消息，则 SDK 按照会话创建时间的倒序返回会话列表。
 *
 *  @param cursor 查询的开始位置。若传入 `nil` 或 `@""`，SDK 从最新活跃的会话开始获取。
 *  @param pageSize 每页期望返回的会话数量。取值范围为 [1,50]。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 * Get the list of conversations from the server with pagination.
 * 
 * The SDK retrieves the list of conversations in the reverse chronological order of their active time (the timestamp of the last message). 
 *
 * If there is no message in the conversation, the SDK retrieves the list of conversations in the reverse chronological order of their creation time.
 *
 *  @param cursor The position from which to start getting data. If you pass in `nil` or `@""`, the SDK retrieves conversations from the latest active one.
 *  @param pageSize The number of conversations that you expect to get on each page. The value range is [1,50].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)getConversationsFromServerWithCursor:(nullable NSString *)cursor pageSize:(UInt8)pageSize completion:(nonnull void (^)(EMCursorResult<EMConversation *> * _Nullable result, EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  分页从服务器获取置顶会话。
 * 
 *  SDK 按照会话的置顶时间的倒序返回会话列表。
 *
 *  @param cursor 查询的开始位置。若传 `nil` 或 `@""`，SDK 从最新置顶的会话开始查询。
 *  @param pageSize 每页期望返回的会话数量。取值范围为 [1,50]。
 *  @param completionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Gets the list of pinned conversations from the server with pagination.
 * 
 *  The SDK returns the pinned conversations in the reverse chronological order of their pinning.
 *
 *  @param cursor The position from which to start getting data. If you pass in `nil` or `@""`, the SDK retrieves conversations from the latest pinned one.
 *  @param pageSize The number of conversations that you expect to get on each page. The value range is [1,50].
 *  @param completionBlock The completion block, which contains the error message if the method fails.
 */
- (void)getPinnedConversationsFromServerWithCursor:(nullable NSString *)cursor pageSize:(UInt8)limit completion:(nonnull void (^)(EMCursorResult<EMConversation *> * _Nullable result, EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  设置是否置顶会话。
 * 
 *  @param conversationId 会话 ID。
 *  @param isPinned 是否置顶会话：
 *       - YES：置顶；
 *       - NO：取消置顶。
 *  @param callback 设置是否置顶会话的结果回调。
 *
 *  \~english
 *  Sets whether to pin a conversation.
 *
 *  @param conversationId  The conversation ID.
 *  @param isPinned Whether to pin a conversation: 
	 *                - `true`：Yes. 
	 *              	- `false`: No. The conversation is unpinned.
 *  @param completionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)pinConversation:(nonnull NSString *)conversationId isPinned:(BOOL)isPinned completionBlock:(nullable void(^)(EMError * _Nullable error))completionBlock;

/**
 *  \~chinese
 *  从本地数据库中获取一个已存在的会话。
 *
 *  @param aConversationId  会话 ID。
 *
 *  @result 会话对象。
 *
 *  \~english
 *  Gets a conversation from the local database. 
 *
 *  @param aConversationId  The conversation ID.
 *
 *  @result The conversation object.
 */
- (EMConversation *_Nullable)getConversationWithConvId:(NSString * _Nullable)aConversationId;

/**
 *  \~chinese
 *  获取一个会话。
 *
 *  @param aConversationId  会话 ID。
 *  @param aType            会话类型。
 *  @param aIfCreate        若该会话不存在是否创建：
 *                          - `YES`：是；
 *                          - `NO`：否。
 *
 *  @result 会话对象。
 *
 *  \~english
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aType            The conversation type. 
 *  @param aIfCreate        Whether to create the conversation if it does not exist:
 *                          - `YES`: Yes;
 *                          - `NO`: No.
 * 
 *  @result The conversation object.
 */
- (EMConversation *_Nullable)getConversation:(NSString *_Nonnull)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/**
 *  \~chinese
 *  获取一个会话。
 *
 *  @param aConversationId  会话 ID。
 *  @param aType            会话类型。
 *  @param aIfCreate        若该会话不存在是否创建。
 *                          - `YES`：是；
 *                          - `NO`：否。
 *  @param isThread         是否是子区会话，即是否为 `threadChat` 类型的会话。
 * - `YES`: 是；
 * - `NO`: 否。
 *  @result 会话对象。
 *
 *  \~english
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aType            The conversation type.
 *  @param aIfCreate        Whether to create the conversation if it does not exist.
 *                          - `YES`: Yes;
 *                          - `NO`: No.
 *  @param isThread         Whether it is thread conversation. That is, whether the conversation is of the `threadChat` type.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @result The conversation object. 
 */
- (EMConversation *_Nullable)getConversation:(NSString *_Nonnull)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate isThread:(BOOL)isThread;

/**
 *  \~chinese
 *  从本地数据库中删除一个会话。
 *
 *  @param aConversationId      会话 ID。
 *  @param aIsDeleteMessages    是否删除会话中的消息。
 * - `YES`: 是；
 * - `NO`: 否。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Deletes a conversation from the local database.
 * 
 *  @param aConversationId      The conversation ID.
 *  @param aIsDeleteMessages    Whether to delete the messages in the conversation.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)deleteConversation:(NSString * _Nonnull)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^_Nullable)(NSString * _Nullable aConversationId, EMError *_Nullable aError))aCompletionBlock;

/*!
  *  \~chinese
  *  删除服务器会话。
  *
  *  @param aConversationId      会话 ID。
  *  @param aConversationType    会话类型。
  *  @param aIsDeleteMessages    是否同时删除会话中的消息。
  *   - `YES`: 是；
  *   - `NO`: 否。
  *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
  *
  *  \~english
  *  Deletes a conversation from the server.
  *
  *  @param aConversationId      The conversation ID.
  *  @param aConversationType    The conversation type.
  *  @param aIsDeleteMessages    Whether to delete the related messages with the conversation.
  *                          - `YES`: Yes;
  *                          - `NO`: No.
  *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
  *
  */
 - (void)deleteServerConversation:(NSString * _Nonnull)aConversationId
                 conversationType:(EMConversationType)aConversationType
           isDeleteServerMessages:(BOOL)aIsDeleteServerMessages
                       completion:(void (^_Nullable)(NSString * _Nullable aConversationId, EMError * _Nullable aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除一组会话。
 *
 *  @param aConversations       会话列表。
 *  @param aIsDeleteMessages    是否删除会话中的消息。
 *   - `YES`: 是；
 *   - `NO`: 否。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Deletes multiple conversations.
 *
 *  @param aConversations       The conversation list.
 *  @param aIsDeleteMessages    Whether to delete the messages with the conversations.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)deleteConversations:(NSArray<EMConversation *> * _Nullable)aConversations
           isDeleteMessages:(BOOL)aIsDeleteMessages
                 completion:(void (^_Nullable)(EMError * _Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  导入一组会话到本地数据库。
 *
 *  @param aConversations   会话列表。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Imports multiple conversations to the local database.
 *
 *  @param aConversations       The conversation list.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)importConversations:(NSArray<EMConversation *> * _Nullable)aConversations
                 completion:(void (^ _Nullable)(EMError * _Nullable aError))aCompletionBlock;

#pragma mark - Message

/**
 *  \~chinese
 *  获取指定的消息。
 * 
 *  @param  aMessageId   消息 ID。
 * 
 *  @result   获取到的消息。
 *
 *  \~english
 *  Gets the specified message.
 *
 *  @param aMessageId    The message ID.
 *  @result EMChatMessage     The message content.
 */
- (EMChatMessage * _Nullable)getMessageWithMessageId:(NSString * _Nonnull)aMessageId;

/**
 *  \~chinese
 *  获取一个会话中消息附件的本地路径。
 *  
 *  删除会话时，会话中的消息附件也会被删除。
 *
 *  @param aConversationId  会话 ID。
 *
 *  @result 附件路径。
 *
 *  \~english
 *  Gets the local path of message attachments in a conversation. 
 * 
 *  When a conversation is deleted, the message attachments in the conversation will also be deleted.
 *
 *  @param aConversationId  The conversation ID.
 *
 *  @result The attachment path.
 */
- (NSString * _Nullable)getMessageAttachmentPath:(NSString * _Nonnull)aConversationId;

/**
 *  \~chinese
 *  导入一组消息到本地数据库。
 *
 *  @param aMessages        消息列表。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Imports multiple messages to the local database.
 *
 *  @param aMessages            The message list.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)importMessages:(NSArray<EMChatMessage *> * _Nonnull)aMessages
            completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  更新消息到本地数据库。
 * 
 *  该方法会同时更新本地内存和数据库中的消息，消息 ID 不会更新。
 *
 *  @param aMessage         消息。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Updates a message in the local database. 
 * 
 *  This method updates the message in both the memory and the local database at the same time.
 * 
 *  The message ID cannot be updated.
 *
 *  @param aMessage             The message instance.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateMessage:(EMChatMessage *_Nonnull)aMessage
           completion:(void (^_Nullable)(EMChatMessage * _Nullable aMessage, EMError * _Nullable aError))aCompletionBlock;
/**
 *  \~chinese
 *  修改本地以及服务端的消息内容。
 *
 *  你只能调用该方法修改单聊和群聊中的文本消息，不能修改聊天室消息。
 *  @param messageId         消息实例id。
 *  @param body                    文本消息体实例（EMTextMessageBody）。
 *  @param completionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。成功则error为空，message不为空
 *
 *  \~english
 *  Modifies a local message or a message at the server side.
 *
 * You can call this method to only modify a text message in one-to-one chats or group chats, but not in chat rooms.
 *
 *  @param message            The ID of the message to modify.
 *  @param body                   The modified message body(EMTextMessageBody).
 *  @param completionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)modifyMessage:(NSString *_Nonnull)messageId body:(EMMessageBody *_Nonnull)body completion:(void (^_Nonnull)(EMError * _Nullable error,EMChatMessage *_Nullable message))completionBlock;

/**
 *  \~chinese
 *  发送消息已读回执。
 *
 *  异步方法。
 *
 *  @param aMessage             消息 ID。
 *  @param aUsername            已读回执的接收方。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends the read receipt for a message.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID.
 *  @param aUsername            The user ID of the recipient of the read receipt.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)sendMessageReadAck:(NSString * _Nonnull)aMessageId
                    toUser:(NSString * _Nonnull)aUsername
                completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;


/**
 *  \~chinese
 *  发送群消息已读回执。
 *
 *  异步方法。
 *
 *  @param aMessageId           消息 ID。
 *  @param aGroupId             群组 ID。
 *  @param aContent             消息内容。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends the read receipt for a group message.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID.
 *  @param aGroupId             The group ID.
 *  @param aContent             The message content.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)sendGroupMessageReadAck:(NSString * _Nonnull)aMessageId
                        toGroup:(NSString * _Nonnull)aGroupId
                        content:(NSString * _Nullable)aContent
                     completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  发送会话已读回执。
 *  
 *  该方法仅适用于单聊会话。
 *  
 *  发送会话已读回执会通知服务器将指定的会话未读消息数置为 0。调用该方法后对方会收到 onConversationRead 回调。
 * 
 *  对话方（包含多端多设备）将会在回调方法 EMChatManagerDelegate onConversationRead(String, String) 中接收到回调。
 *
 *  为了减少调用次数，我们建议在进入聊天页面有大量未读消息时调用该方法，在聊天过程中调用 `sendMessageReadAck` 方法发送消息已读回执。
 *  
 *
 *  异步方法。
 *
 *  @param conversationId         会话 ID。
 *  @param aCompletionBlock       该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends the conversation read receipt to the server.
 * 
 *  This method applies to one-to-one chats only.
 * 
 *  This method call notifies the server to set the number of unread messages of the specified conversation as 0, and triggers the onConversationRead callback on the recipient's client.
 *
 *  To reduce the number of method calls, we recommend that you call this method when the user enters a conversation with many unread messages, and call `sendMessageReadAck` during a conversation to send the message read receipts.
 * 
 *  This is an asynchronous method.
 * 
 *  @param conversationId          The conversation ID.
 *  @param aCompletionBlock        The completion block, which contains the error message if the method fails.
 * 
 */
- (void)ackConversationRead:(NSString * _Nonnull)conversationId
                 completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;

/**
 *  \~chinese
 *  撤回一条消息。
 *
 *  异步方法。
 *
 *  @param aMessageId           消息 ID。
 *  @param aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Recalls a message.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)recallMessageWithMessageId:(NSString *_Nonnull)aMessageId
                        completion:(void (^_Nullable)(EMError *_Nullable aError))aCompletionBlock;


/**
 *  \~chinese
 *  发送消息。
 * 
 *  异步方法。
 *
 *  @param aMessage         消息。
 *  @param aProgressBlock   附件上传进度回调 block。进度值范围为 [0,100]。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Sends a message.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMessage             The message instance.
 *  @param aProgressBlock       The callback block of attachment upload progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)sendMessage:(EMChatMessage *_Nonnull)aMessage
           progress:(void (^_Nullable)(int progress))aProgressBlock
         completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  重新发送消息。
 *
 *  @param aMessage         消息对象。
 *  @param aProgressBlock   附件上传进度回调 block。进度值范围为 [0,100]。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Resends a message.
 *
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment upload progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)resendMessage:(EMChatMessage *_Nonnull)aMessage
             progress:(void (^_Nullable)(int progress))aProgressBlock
           completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  下载缩略图（图片缩略图或视频的第一帧图片）。
 * 
 *  SDK 会自动下载缩略图。如果自动下载失败，你可以调用该方法下载缩略图。
 *
 *  @param aMessage            消息对象。
 *  @param aProgressBlock      附件下载进度回调 block。进度值的范围为 [0,100]。
 *  @param aCompletionBlock    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Downloads the message thumbnail (the thumbnail of an image or the first frame of a video).
 * 
 *  The SDK automatically downloads the thumbnail. If the auto-download fails, you can call this method to manually download the thumbnail.
 *
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageThumbnail:(EMChatMessage *_Nonnull)aMessage
                        progress:(void (^_Nullable)(int progress))aProgressBlock
                      completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  下载消息附件（语音、视频、图片原图、文件）。
 * 
 *  SDK 会自动下载语音消息。如果自动下载失败，你可以调用该方法。
 *
 *  异步方法。
 *
 *  @param aMessage            消息。
 *  @param aProgressBlock      附件下载进度回调 block。进度值的范围为 [0,100]。
 *  @param aCompletionBlock    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Downloads message attachment (voice, video, image or file). 
 *  
 *  The SDK automatically downloads voice messages. If the automatic download fails, you can call this method to download voice messages manually.
 *
 *  This is an asynchronous method.
 * 
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageAttachment:(EMChatMessage *_Nonnull)aMessage
                         progress:(void (^_Nullable)(int progress))aProgressBlock
                       completion:(void (^_Nullable)(EMChatMessage *_Nullable message, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  下载并解析合并消息中的附件。
 *
 *  异步方法。
 *
 *  @param aMessage            合并消息对象。
 *  @param aCompletionBlock    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Download and parse the attachment in a combined message.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessage            The combined message object.
 *  @param aCompletionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)downloadAndParseCombineMessage:(EMChatMessage* _Nonnull)aMessage
                            completion:(void (^_Nullable)(NSArray<EMChatMessage *>*_Nullable messages, EMError *_Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  从服务器获取指定会话的消息。
 *
 *  @param  aConversationId     会话 ID。
 *  @param  aConversationType   会话类型。
 *  @param  aStartMessageId     查询的起始消息 ID。若该参数为空，SDK 从最新一条消息开始获取。
 *  @param  direction           消息搜索方向。详见 {@link EMMessageFetchHistoryDirection}。
 *  @param  aPageSize           每页期望获取的消息条数。
 *  @param  pError              错误信息。
 *
 *  @result     获取的消息内容列表。
 *
 *
 *  \~english
 *  Gets messages in a conversation from the server.
 
 *  @param aConversationId      The conversation ID.
 *  @param aConversationType    The conversation type.
 *  @param aStartMessageId      The starting message ID for query. If you set this parameter as `nil` or "", the SDK gets messages from the latest one.
 *  @param direction            The message search direction. See {@link EMMessageFetchHistoryDirection}.                     
 *  @param aPageSize            The number of messages that you expect to get on each page.
 *  @param pError               The error information if the method fails: Error.
 *
 *  @result    The list of retrieved messages.
 */
- (EMCursorResult<EMChatMessage*> *_Nullable)fetchHistoryMessagesFromServer:(NSString *_Nonnull)aConversationId
                                  conversationType:(EMConversationType)aConversationType
                                    startMessageId:(NSString *_Nullable)aStartMessageId
                                       fetchDirection:(EMMessageFetchHistoryDirection)direction
                                          pageSize:(int)aPageSize
                                             error:(EMError **_Nullable)pError;
/**
 *  \~chinese
 *  从服务器获取指定会话的消息。
 *
 *  @param  aConversationId     会话 ID。
 *  @param  aConversationType   会话类型。
 *  @param  aStartMessageId     查询的起始消息 ID。若该参数为空，SDK 从最新一条消息开始获取。
 *  @param  aPageSize           每页期望获取的消息条数。
 *  @param  pError              错误信息。
 *
 *  @result     获取的消息内容列表。
 *
 *
 *  \~english
 *  Gets messages in a conversation from the server.
 
 *  @param aConversationId      The conversation ID.
 *  @param aConversationType    The conversation type.
 *  @param aStartMessageId      The starting message ID for query. If you set this parameter as `nil` or "", the SDK gets messages from the latest one.
 *  @param aPageSize            The number of messages that you expect to get on each page. 
 *  @param pError               The error information if the method fails: Error.
 *
 *  @result    The list of retrieved messages.
 */
- (EMCursorResult<EMChatMessage*> *_Nullable)fetchHistoryMessagesFromServer:(NSString *_Nonnull)aConversationId
                                  conversationType:(EMConversationType)aConversationType
                                    startMessageId:(NSString *_Nullable)aStartMessageId
                                          pageSize:(int)aPageSize
                                             error:(EMError **_Nullable)pError;


/**
 *  \~chinese
 *  从服务器获取指定会话的消息。
 *
 *  异步方法。
 *
 *  @param  aConversationId     会话 ID。
 *  @param  aConversationType   会话类型。
 *  @param  aStartMessageId     查询的起始消息 ID。
 *  @param  aPageSize           每页期望获取的消息条数。
 *  @param  aCompletionBlock    该方法完成调用的回调。
 *
 *
 *  \~english
 *  Gets messages in a conversation from the server.
 * 
 *  This is an asynchronous method.
 * 
 *  @param aConversationId      The conversation ID.
 *  @param aConversationType    The conversation type.
 *  @param aStartMessageId      The starting message ID for query. If you set this parameter as `nil` or "", the SDK gets messages from the latest one.
 *  @param aPageSize            The number of messages that you expect to get on each page.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)asyncFetchHistoryMessagesFromServer:(NSString *_Nonnull)aConversationId
                           conversationType:(EMConversationType)aConversationType
                             startMessageId:(NSString *_Nullable)aStartMessageId
                                   pageSize:(int)aPageSize
                                 completion:(void (^_Nullable)(EMCursorResult<EMChatMessage*> *_Nullable aResult, EMError *_Nullable aError))aCompletionBlock;
/**
 *  \~chinese
 *  从服务器获取指定会话的消息。
 *
 *  异步方法。
 *
 *  @param  aConversationId     会话 ID。
 *  @param  aConversationType   会话类型。
 *  @param  aStartMessageId     查询的起始消息 ID。若该参数为空，SDK 从最新一条消息开始获取。
 *  @param direction            消息搜索方向。详见 {@link EMMessageFetchHistoryDirection}。
 *  @param  aPageSize           每页期望获取的消息条数。取值范围为 [1,50]。
 *  @param  aCompletionBlock    该方法完成调用的回调。
 *
 *
 *  \~english
 *  Fetches conversation messages from server.
 *
 *  This is an asynchronous method.
 *
 *  @param aConversationId      The conversation ID.
 *  @param aConversationType    The conversation type.
 *  @param aStartMessageId      The starting message ID for query. If you set this parameter as `nil` or "", the SDK gets messages from the latest one.
 *  @param direction            The message search direction. See {@link EMMessageFetchHistoryDirection}.
 *  @param aPageSize            The number of messages that you expect to get on each page. The value range is [1,50].
 *  @param aCompletionBlock     The callback block, which contains the error message if the method fails.
 */
- (void)asyncFetchHistoryMessagesFromServer:(NSString *_Nonnull)aConversationId
                           conversationType:(EMConversationType)aConversationType
                             startMessageId:(NSString *_Nullable)aStartMessageId
                             fetchDirection:(EMMessageFetchHistoryDirection)direction
                                   pageSize:(int)aPageSize
                                 completion:(void (^_Nullable)(EMCursorResult<EMChatMessage*> *_Nullable aResult, EMError *_Nullable aError))aCompletionBlock;

 


/**
 *  \~chinese
 *  从服务器获取指定群消息的已读回执。
 * 
 * 可调用该方法了解有多少群成员阅读了指定的群消息。
 *
 *  异步方法。
 *
 *  @param  aMessageId           要获取已读回执的消息 ID。
 *  @param  aGroupId             群组 ID。
 *  @param  aGroupAckId          群消息已读回执 ID。
 *  @param  aPageSize            每页期望获取的回执条数。
 *  @param  aCompletionBlock     该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Gets the read receipts of a specified group message from the server.
 * 
 *  By getting the read receipts of a group message, you can see how many group members have read this message.
 * 
 *  This is an asynchronous method.
 * 
 *  @param  aMessageId           The message ID.
 *  @param  aGroupId             The group ID.
 *  @param  aGroupAckId          The ID of the read receipt to get from the server.
 *  @param  aPageSize            The number of read receipts that you expect to get on each page.
 *  @param  aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)asyncFetchGroupMessageAcksFromServer:(NSString *_Nonnull)aMessageId
                                     groupId:(NSString *_Nonnull)aGroupId
                             startGroupAckId:(NSString *_Nonnull)aGroupAckId
                                    pageSize:(int)aPageSize
                                  completion:(void (^_Nullable)(EMCursorResult<EMGroupMessageAck *> *_Nullable aResult, EMError *_Nullable error, int totalCount))aCompletionBlock;

/**
 *  \~chinese
 *  举报违规消息。
 *
 *  异步方法。
 *
 *  @param  aMessageId           非法消息的 ID。
 *  @param  aTag                 非法消息的标签。你需要填写自定义标签，例如`涉政`或`广告`。该字段对应控制台的消息举报记录页面的`词条标记`字段。

 *  @param  aReason              举报原因。你需要自行填写举报原因。该字段对应控制台的消息举报记录页面的`举报原因`字段。
 *  @param  aCompletion          该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *
 *  \~english
 *  Reports an inappropriate message.
 * 
 *  This is an asynchronous method.
 
 *  @param  aMessageId              The ID of the inappropriate message.
 *  @param  aTag                   The tag of the illegal message. You need to type a custom tag, like `porn` or `ad`.  This parameter corresponds to the "Label" field on the message reporting history page of the console.
 *  @param  aReason                 he reporting reason. You need to type a specific reason. This parameter corresponds to the "Reason" field on the message reporting history page of the console.
 *  @param  aCompletion             The completion block, which contains the error message if the method fails.
 */
- (void)reportMessageWithId:(NSString *_Nonnull )aMessageId
                        tag:(NSString *_Nonnull)aTag
                     reason:(NSString *_Nonnull)aReason
                 completion:(void(^_Nullable)(EMError* _Nullable error))aCompletion;

/*!
 *  \~chinese
 *  删除指定时间戳之前的本地历史消息。
 *
 *  异步方法。
 *
 *  @param aTimestamp            指定的消息时间戳，单位为毫秒。时间戳之前的本地消息会被删除。
 *  @param aCompletion           该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Deletes local historical messages with a Unix timestamp before a specified one.
 *
 *  @param aTimestamp            The specified Unix timestamp in miliseconds. Messages with a Unix timestamp before the specified one will be deleted.
 *  @param aCompletion           The completion block, which contains the error message if the method fails.
 *
 */
- (void)deleteMessagesBefore:(NSUInteger)aTimestamp
                  completion:(void(^)(EMError*error))aCompletion;



/**
 *  \~chinese
 *  从会话中删除消息（包括本地存储和服务器存储）。
 * 
 *  @param conversation 会话对象 EMConversation
 *  @param messageIds   要删除消息 ID 字符串数组。
 *  @param completion   该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Removes messages in a conversation (from both local storage and the server).
 * 
 *  @param conversation The EMConversation object.
 *  @param messageIds   A string array of message IDs to delete.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithConversation:(EMConversation *_Nonnull)conversation messageIds:(NSArray <__kindof NSString*>*_Nonnull)messageIds completion:(void (^ _Nullable)(EMError * _Nullable aError))aCompletionBlock;
/**
 *  \~chinese
 *  从会话中删除消息（包括本地存储和服务器）。
 * 
 *  @param conversation 会话对象 EMConversation。
 *  @param beforeTimeStamp   指定的时间戳，单位为毫秒。该时间戳之前的消息会被删除。
 *  @param completion    该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Removes messages in a conversation (from both local storage and the server).
 *
 *  @param conversation The EMConversation object.
 *  @param messageIds   The specified Unix timestamp in miliseconds. Messages with a timestamp before the specified one will be removed from the conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithConversation:(EMConversation *_Nonnull)conversation timeStamp:(NSTimeInterval)beforeTimeStamp completion:(void (^ _Nullable)(EMError * _Nullable aError))aCompletionBlock;


/*!
 *  \~chinese
 *  翻译消息。
 *
 *  @param aMessage         消息对象。
 *  @param aLanguages       目标语言代码列表。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Translates a message.
 *
 *  @param aMessage             The message object.
 *  @param aLanguages           The list of target language codes.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)translateMessage:(EMChatMessage * _Nonnull)aMessage
         targetLanguages:(NSArray<NSString*>* _Nonnull)aLanguages
              completion:(void (^_Nullable)(EMChatMessage * _Nullable message, EMError * _Nullable error))aCompletionBlock;

/*!
 *  \~chinese
 *  获取翻译服务支持的语言。
 * 
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *
 *  Gets all languages supported by the translation service.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)fetchSupportedLanguages:(void(^_Nullable)(NSArray<EMTranslateLanguage*>* _Nullable languages,EMError* _Nullable error))aCompletionBlock;

/**
 *  \~chinese
 *  通过关键词从数据库获取消息。
 * 
 *  该方法返回的消息按时间顺序排列。
 * 
 *  同步方法，会阻塞当前线程。
 *
 *  @param aType            消息类型。
 *  @param aTimestamp       参考时间戳。如果该参数设置的时间戳为负数，则从最新消息向前获取。
 *  @param aCount           获取的消息条数。如果设为小于等于 0，SDK 会获取一条消息。
 *  @param aUsername        消息发送方。设为 `nil` 表示忽略该参数。
 *  @param aDirection       消息搜索方向。详见 {@link EMMessageSearchDirection}。
 *                          - `UP`：按消息时间戳的逆序获取。
 *                          - `DOWN`：按消息时间戳的顺序获取。
 *
 *  @result 消息列表。返回的消息列表为数组类型，数组中元素详见 {@link EMChatMessage}。
 *
 *  \~english
 *  Loads messages with the specified keyword from the local database.
 * 
 *  This method returns messages in chronological order.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aType            The message type to load.
 *  @param aTimestamp       The message timestamp threshold for loading. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load. If you set this parameter to a value less than 1, the SDK gets one message from the local database.
 *  @param aUsername        The message sender. It is optional. If you set this parameter as `nil`, the SDK gets messages while ignoring this parameter.
 *  @param aDirection       The message search direction. See {@link EMMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them. 
 *
 *  @result The list of retrieved messages. The message list is of the array type. For elements in the array, see {@link EMChatMessage}.
 *
 */
- (NSArray<EMChatMessage *> * _Nullable)loadMessagesWithType:(EMMessageBodyType)aType
                                                   timestamp:(long long)aTimestamp
                                                       count:(int)aCount
                                                    fromUser:(NSString* _Nullable)aUsername
                                             searchDirection:(EMMessageSearchDirection)aDirection;

/**
 *  \~chinese
 *  通过关键词从数据库获取消息。
 * 
 *  该方法返回的消息按时间顺序排列。
 *
 *  @param aType            消息类型。
 *  @param aTimestamp       参考时间戳。如果该参数设置的时间戳为负数，则 SDK 从最新消息开始获取。
 *  @param aCount           获取的消息条数。如果设为小于等于 0，SDK 会获取一条消息。
 *  @param aUsername        消息发送方。设为 `nil` 表示忽略该参数。
 *  @param aDirection       消息搜索方向，详见 {@link MessageSearchDirection}。
 *                          - `UP`：按消息时间戳的逆序获取。
 *                          - `DOWN`：按消息时间戳的顺序获取。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Loads messages with the specified keyword from the local database.
 * 
 *  This method returns messages in chronological order.
 *
 *  @param aType            The message type to load.
 *  @param aTimestamp       The message timestamp threshold for loading. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load. If you set this parameter to a value less than 1, the SDK gets one message from the local database.
 *  @param aUsername        The message sender. It is optional. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link EMMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesWithType:(EMMessageBodyType)aType
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString*)aUsername
             searchDirection:(EMMessageSearchDirection)aDirection
                  completion:(void (^)(NSArray<EMChatMessage *> *aMessages, EMError *aError))aCompletionBlock;

/**
 *  \~chinese
 *  通过关键词从数据库获取消息。
 * 
 *  该方法返回的消息按时间顺序排列。
 * 
 *  同步方法，会阻塞当前线程。
 *
 *  @param aKeywords        搜索关键词。设为 `nil` 表示忽略该参数。
 *  @param aTimestamp       参考时间戳。如果该参数设置的时间戳为负数，则从最新消息向前获取。
 *  @param aCount           获取的消息条数。如果设为小于等于 0，SDK 会获取一条消息。
 *  @param aSender          消息发送方。设为 `nil` 表示忽略该参数。
 *  @param aDirection       消息搜索方向，详见 {@link MessageSearchDirection}。
 *                          - `UP`：按消息时间戳的逆序获取。
 *                          - `DOWN`：按消息时间戳的顺序获取。
 *
 *  @result 消息列表。返回的消息列表为数组类型，数组中元素详见 {@link EMChatMessage}。
 *
 *  \~english
 *  Loads messages with the specified keyword from the local database.
 *
 *  This method returns messages in chronological order.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aKeyword         The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The message timestamp threshold for loading. If you set this parameter as a negative value, the SDK loads messages from the latest.
 *  @param aCount           The number of messages to load. If you set this parameter less than 1, the SDK gets one message from the local database.
 *  @param aSender          The message sender. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link EMMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *
 *  @result The list of retrieved messages. The message list is of the array type. For elements in the array, see {@link EMChatMessage}.
 *
 */
- (NSArray<EMChatMessage *> *)loadMessagesWithKeyword:(NSString*)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection;

/**
 *  \~chinese
 *  通过关键词从数据库获取消息。
 * 
 *  该方法返回的消息按时间顺序排列。
 *
 *  @param aKeywords        搜索关键词，设为 `nil` 表示忽略该参数。
 *  @param aTimestamp       参考时间戳。如果该参数设置的时间戳为负数，则从最新消息向前获取。
 *  @param aCount           获取的消息条数。如果设为小于等于 0，SDK 会获取一条消息。
 *  @param aSender          消息发送方。设为 `nil` 表示忽略该参数。
 *  @param aDirection       消息搜索方向，详见 {@link EMMessageSearchDirection}。
 *                          - `UP`：按消息时间戳的逆序获取。
 *                          - `DOWN`：按消息时间戳的顺序获取。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *  Loads messages with the specified keyword from the local database.
 * 
 *  This method returns messages in chronological order.
 *
 *  @param aKeyword         The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The message timestamp threshold for loading. If you set this parameter as a negative value, the SDK loads messages from the latest.
 *  @param aCount           The number of messages to load. If you set this parameter less than 1, the SDK gets one message from the local database.
 *  @param aSender          The sender of the message. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link EMMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aCompletionBlock  The completion block which contains the error code and error information if the method fails.
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(EMMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray<EMChatMessage *> *aMessages, EMError *aError))aCompletionBlock;

NS_ASSUME_NONNULL_BEGIN
/*!
 *  \~chinese
 *  添加 Reaction。
 *
 *  @param reaction  Reaction 内容。
 *  @param messageId  消息 ID。
 *  @param completion  该方法完成的回调。如果有错误会包含错误信息。
 *
 *  \~english
 *  Adds a Reaction.
 *
 *  @param reaction  The Reaction content.
 *  @param messageId  The message ID.
 *  @param completion  The completion block which contains the error code and error information if the method fails.
 */
- (void)addReaction:(NSString *)reaction toMessage:(NSString *)messageId completion:(nullable void(^)(EMError * _Nullable))completion;

/*!
 *  \~chinese
 *  删除 Reaction。
 *
 *  @param reaction  Reaction 内容。
 *  @param messageId  消息 ID。
 *  @param completion  该方法完成的回调。如果有错误会包含错误信息。
 *
 *  \~english
 *  Removes a Reaction.
 *
 *  @param reaction  The Reaction content.
 *  @param messageId  The message ID.
 *  @param completion  The completion block which contains the error code and error information if the method fails.
 */
- (void)removeReaction:(NSString *)reaction fromMessage:(NSString *)messageId completion:(nullable void(^)(EMError * _Nullable))completion;

/*!
 *  \~chinese
 *  获取消息的 Reaction 列表。
 *
 *  @param messageId  消息 ID。
 *  @param groupId  群组 ID，该参数只在群聊生效。
 *  @param chatType  会话类型，仅支持单聊（{@link EMChatTypeChat}）和群聊（{@link EMChatTypeGroupChat}）。
 *  @param completion  该方法完成的回调。如果有错误会包含错误信息。
 *
 *  \~english
 *  Gets the Reaction list.
 *
 *  @param messageId  The message ID.
 *  @param groupId  The group ID. This parameter is invalid only for group chat.
 *  @param chatType  The chat type. Only one-to-one chat ({@link EMChatTypeChat} and group chat ({@link EMChatTypeGroupChat}) are allowed.
 *  @param completion The completion block which contains the error code and error information if the method fails.
 */
- (void)getReactionList:(NSArray <NSString *>*)messageIds
                groupId:(nullable NSString *)groupId
               chatType:(EMChatType)chatType
             completion:(void (^)(NSDictionary <NSString *, NSArray<EMMessageReaction *> *> *, EMError * _Nullable))completion;

/*!
 *  \~chinese
 *  分页获取群聊消息的 Reaction 详细列表。
 *
 *  @param messageId  消息 ID。
 *  @param reaction  Reaction 内容。
 *  @param cursor  查询的开始位置。首次调用该方法可传 `nil` 或 `@""` 以 Reaction 创建时间的正序获取。
 *  @param pageSize  每页期望返回的 Reaction 数量。取值范围为 [1,100]。
 *  @param completion  该方法完成的回调，返回 Reaction 列表和用于继续获取数据的 cursor。当 cursor 为 `nil` 时表示已获取全部数据。
 *
 *  \~english
 *  Uses the pagination to get the Reaction detail list of a chat group message.
 *
 *  @param messageId  The message ID.
 *  @param reaction  The Reaction content.
 *  @param cursor  The position from which to start getting data. If it is set to `nil` or `@""` at the first call, the SDK retrieves Reactions in the chronological order of their creation time.
 *  @param pageSize   The number of Reactions that you expect to get on each page. The value range is [1,100].
 *  @param completion  The completion block, which contains the Reaction list and the cursor for the next query. When the cursor is `nil`, all data is already fetched.
 */
- (void)getReactionDetail:(NSString *)messageId
                 reaction:(NSString *)reaction
                    cursor:(nullable NSString *)cursor
                 pageSize:(uint64_t)pageSize
               completion:(void (^)(EMMessageReaction *, NSString * _Nullable cursor, EMError * _Nullable))completion;

/**
 *  \~chinese
 *  根据消息拉取参数配置接口（`EMFetchServerMessagesOption`）从服务器分页获取指定会话的历史消息。
 *
 *  @param conversationId 会话 ID。
 *  @param type 会话类型，只支持单聊（`EMConversationTypeChat`）和群组（`EMConversationTypeGroupChat`）。
 *  @param cursor 查询的起始游标位置。
 *  @param pageSize 每页期望获取的消息条数。取值范围为 [1,50]。
 *  @param option  查询历史消息的参数配置接口，详见 {@link EMFetchServerMessagesOption}。
 *  @param aCompletionBlock 该方法完成调用的回调。如果该方法调用失败，会包含调用失败的原因。
 *
 *  \~english
 *
 *  @param conversationId The conversation ID, which is the user ID of the peer user for one-to-one chat, but the group ID for group chat.
 *  @param type The conversation type. You can set this parameter only to `EMConversationTypeChat` (one-to-one chat) or `EMConversationTypeGroupChat` (group chat).
 *  @param cursor The cursor position from which to start querying data.
 *  @param pageSize The number of messages that you expect to get on each page. The value range is [1,50].
 *  @param option  The parameter configuration class for pulling historical messages from the server. See {@link EMFetchServerMessagesOption}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)fetchMessagesFromServerBy:(NSString* )conversationId
                 conversationType:(EMConversationType)type
                           cursor:(NSString* _Nullable)cursor
                         pageSize:(NSUInteger)pageSize
                           option:(EMFetchServerMessagesOption* _Nullable)option
                       completion:(void (^_Nullable)(EMCursorResult<EMChatMessage*>* _Nullable result, EMError* _Nullable aError))aCompletionBlock;
NS_ASSUME_NONNULL_END

@end
