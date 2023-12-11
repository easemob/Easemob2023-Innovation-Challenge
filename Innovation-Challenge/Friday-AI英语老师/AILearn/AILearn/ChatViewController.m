//
//  ChatViewController.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/29.
//

#import "ChatViewController.h"
#import "UIColor+FFColor.h"
#import "NETM.h"
#import "SparkMessage.h"
#import "SparkTableViewCell.h"
#import <HyphenateChat/HyphenateChat.h>

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight; //df.80
@property (weak, nonatomic) IBOutlet UIButton *shengboBtn;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;
@property (nonatomic, strong) NSMutableArray* dataSources;
@property (nonatomic, strong) EMConversation* conversion;
@end

@implementation ChatViewController{
    bool _isKeyboardDidShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
    [self addNotificationObservers];
}
-(void)makeView{
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor hexColor:@"#999999"].CGColor;
    self.textView.delegate = self;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [_chatTableView registerClass:[SparkTableViewCell class] forCellReuseIdentifier:@"reuseId"];
    _chatTableView.estimatedRowHeight = 88;
    _chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.dataSources = @[].mutableCopy;
    self.conversion = [EMClient.sharedClient.chatManager getConversation:@"learnAIUser" type:EMConversationTypeChat createIfNotExist:YES];
    EMChatMessage *latestMessage = [self.conversion latestMessage];
    self.dataSources = [self.conversion loadMessagesStartFromId:latestMessage.messageId count:50 searchDirection:EMMessageSearchDirectionUp].mutableCopy;
    [self.chatTableView reloadData];

}
- (IBAction)actionForLeftBtn:(UIButton *)sender {
    self.leftBtn.selected = !self.leftBtn.selected;
    self.shengboBtn.hidden = !self.leftBtn.selected;
    self.textView.hidden = self.leftBtn.selected;
}
- (IBAction)longPressShengBo:(UILongPressGestureRecognizer *)sender {
    if([sender state] == UIGestureRecognizerStateBegan){
        NSLog(@"长按事件");
    }else if(sender.state == UIGestureRecognizerStateEnded){
        NSLog(@"长按事件结束");
    }{

    }
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SparkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    EMChatMessage *chatMe = self.dataSources[indexPath.row];
//    SparkMessage * message = [[SparkMessage alloc] initWithChatMessage:chatMe];
//    [cell updateCell:(message.sender == SPARK) text:message.content];
    return cell;
}

#pragma mark - Notification

- (void)addNotificationObservers {
    // show notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // hiden notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                    object:nil];
}
- (void)keyboardWillShow:(NSNotification *) notification {
    if (_isKeyboardDidShow) {
        return;
    }
    NSDictionary * userInfo = [notification userInfo];
    int height = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomViewBottom.constant = height;
    }];
    _isKeyboardDidShow = true;
}

- (void)keyboardWillHide:(NSNotification *) notification {
    NSDictionary * userInfo = [notification userInfo];
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int height = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:duration animations:^{
        self.bottomViewBottom.constant = 0;
    }];
    _isKeyboardDidShow = false;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSString *messageS = textView.text;
        // 发送消息。
        EMChatMessage *mess = [self messageWithMessage:messageS from:YES];
        [self.conversion insertMessage:mess error:nil];
        [self.dataSources addObject:mess];
        [self scrollToBottom];
        return NO;
    }

    return YES;
}
- (void)scrollToBottom {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataSources.count - 1 inSection:0];
    [self.chatTableView performBatchUpdates:^{
        [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    } completion:^(BOOL finished) {
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height) animated:YES];
    }];
}
-(EMChatMessage *)messageWithMessage:(NSString *)messageS from:(BOOL)sender{
    EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:messageS];
    // 消息接收方，单聊为对端用户的 ID，群聊为群组 ID，聊天室为聊天室 ID。
    EMChatMessage *message = [[EMChatMessage alloc] initWithConversationID:self.conversion.conversationId
                                                          body:textMessageBody
                                                                       ext:@{@"sender":sender?@"1":@"0"}];
    // 会话类型，单聊为 `EMChatTypeChat`，群聊为 `EMChatTypeGroupChat`，聊天室为 `EMChatTypeChatRoom`，默认为单聊。
    message.chatType = EMChatTypeChat;
    return message;
}
@end
