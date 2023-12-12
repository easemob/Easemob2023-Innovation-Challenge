//
//  SparkViewController.m
//  AiEdgeDemo
//
//  Created by pcfang on 6.5.23.
//

#import "SparkViewController.h"
#import "SparkTableViewCell.h"
#import "SparkMessage.h"
#import <SparkChain/SparkChain.h>
#import<CoreTelephony/CTCellularData.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "NETM.h"
#import <iflyMSC/IFlyMSC.h>

#define APPID @"2a30e3a4"
#define APIKEY @"d3d8c27822664f3f9cf9f4c30312c5d6"
#define APISERECT @"MmQ5ZTlmMWQ1NDk5ZDg2YzEyZjJmNDg1"



@interface SparkViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LLMCallback,IFlySpeechSynthesizerDelegate>
{
    bool _isKeyboardDidShow;
    dispatch_semaphore_t _sema;
}
@property (nonatomic, strong) UITableView * tableview; // 消息列表
@property (nonatomic, strong) UIToolbar * toolbar; // 输入工具栏
@property (nonatomic, strong) UITextField * inputTF; // 输入框
@property (nonatomic, strong) NSMutableArray * dataSources; //数据列表
@property (nonatomic, strong) LLM * llm;

@property (nonatomic, strong) NSMutableString *result;

@property (nonatomic, strong) UIButton * buttonInit;

@property (nonatomic, strong) IFlySpeechSynthesizer* iFlySpeechSynthesizer;
@end

@implementation SparkViewController

- (void)dealloc {
    [self removeNotificationObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    	
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.title = @"SparkChain";
    
    // 键盘监听
    [self addNotificationObservers];
    
    // 请求网络，弹窗网络权限
    [self alertNetworkPermission];
    [self asyncSparkChain];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initSDK];
    });
}

- (void)alertNetworkPermission {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.iflyaicloud.com/portal/AIHub"]] resume];
}

-(void)initSDK{
    SparkChainConfig * config = [[SparkChainConfig alloc] init];
    config.appID(APPID)
        .apiKey(APIKEY)
        .apiSecret(APISERECT)
        .logLevel(0)
        .logPath(@"./aikit.log");
    int ret = [SparkChain.getInst init:config];
    if (ret != 0) {
        NSString * tip = [NSString stringWithFormat:@"SparkChain init failed:%d",ret];
        [self.buttonInit setTitle:tip forState:(UIControlStateNormal)];
        NSLog(@"%@", tip);
    } else {
        [self updateToolbar];
    }
    
   
    
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
     forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
    forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@"Ryan"
     forKey: [IFlySpeechConstant VOICE_NAME]];
    [_iFlySpeechSynthesizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@"tts.pcm"
     forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
}

- (void)syncSparkChain{
    LLMConfig * llmConfig = [[LLMConfig alloc] init];
    llmConfig.domain(@"generalv3");
    LLM *llm = [[LLM alloc] initWithConfig:llmConfig];
    NSString *result;
    //第一轮交互，如果不需要交互上下文，均可按照此方式调用
    NSString *query1 = @"上海有什么景点？";
    LLMOutput *output = [llm run:query1];
    if(output.errCode == 0){
        result = output.content;
        NSLog(@"result1 == %@",result);

    }else{
        NSLog(@"%@",output.errMsg);
    }
    //
    //第二轮交互，带历史上下文
    NSString *query2 = @"那帮我带一份旅游计划吧。";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *item1 = [[NSMutableDictionary alloc] init];
    [item1 setValue:@"user" forKey:@"role"];
    [item1 setValue:query1 forKey:@"content"];
    
    
    NSMutableDictionary *item2 = [[NSMutableDictionary alloc] init];
    [item2 setValue:@"assistant" forKey:@"role"];
    [item2 setValue:result forKey:@"content"];
    
    NSMutableDictionary *item3 = [[NSMutableDictionary alloc] init];
    [item3 setValue:@"user" forKey:@"role"];
    [item3 setValue:query2 forKey:@"content"];
    
    [array addObject:item1];
    [array addObject:item2];
    [array addObject:item3];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    output = [llm run:jsonString];
    if(output.errCode == 0){
        result = output.content;
        NSLog(@"result2 === %@",result);
    }else{
        NSLog(@"%@",output.errMsg);
    }

}


- (void)asyncSparkChain{
    _sema = dispatch_semaphore_create(0);
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 15);
//    NSString *myContext = @"myContext";
//    self.result = @"".mutableCopy;
//    
//    LLMConfig * llmConfig = [[LLMConfig alloc] init];
//    llmConfig.domain(@"generalv3");
//    LLM *llm = [[LLM alloc] initWithConfig:llmConfig];
//    llm.callback = self;//设置代理
//    //第一轮交互，如果不需要交互上下文，均可按照此方式调用
//    NSString *query1 = @"上海有什么景点？";
//    int ret = [llm arun:query1 usrContext:myContext];
//    
//    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"result1 == %@",self.result);
//    
//    
//    self.result = @"".mutableCopy;
//    NSString *query2 = @"那帮我带一份旅游计划吧。";
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSMutableDictionary *item1 = [[NSMutableDictionary alloc] init];
//    [item1 setValue:@"user" forKey:@"role"];
//    [item1 setValue:query1 forKey:@"content"];
//    
//    
//    NSMutableDictionary *item2 = [[NSMutableDictionary alloc] init];
//    [item2 setValue:@"assistant" forKey:@"role"];
//    [item2 setValue:self.result forKey:@"content"];
//    
//    NSMutableDictionary *item3 = [[NSMutableDictionary alloc] init];
//    [item3 setValue:@"user" forKey:@"role"];
//    [item3 setValue:query2 forKey:@"content"];
//    
//    [array addObject:item1];
//    [array addObject:item2];
//    [array addObject:item3];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    ret = [llm arun:jsonString usrContext:myContext];
//    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
//    NSLog(@"result2 == %@",self.result);
    
}




- (void)setupSubviews {
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.toolbar];
}



#pragma mark - LLM Delegate
- (void)llm:(LLM *)llm onResult:(LLMResult *)result usrContext:(id)usrContext {
    
    NSLog(@"result.content:%@",result.content);
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    });
    if (result.status == 0) {
        SparkMessage * message = [[SparkMessage alloc] initWithContent:result.content from:SPARK];
        [self.dataSources addObject:message];
        
    } else {
        SparkMessage * message = self.dataSources.lastObject;
        message.content = [message.content stringByAppendingString:result.content];
        if (result.status == 2) {
            [NETM.shareManger fanyi:message.content success:^(NSString * _Nonnull traS) {
                SparkMessage * message = self.dataSources.lastObject;
                message.content = traS;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self scrollToBottom];
                });
            } faile:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self scrollToBottom];
                });
            }];
            
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
//    关联上下文 异步调用时此代码需打开
    [self.result appendString:result.content];
    if(result.status == 2){
        dispatch_semaphore_signal(_sema);
    }
    
}

- (void)llm:(LLM *)llm onEvent:(LLMEvent *)event usrContext:(id)usrContext {
    
}

- (void)llm:(LLM *)llm onError:(LLMError *)error usrContext:(id)usrContext {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //关联上下文 异步调用时此代码需打开
    dispatch_semaphore_signal(_sema);
    NSLog(@"code:%d,msg:%@",error.errCode,error.errMsg);
}


- (void)scrollToBottom {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataSources.count - 1 inSection:0];
    [self.tableview performBatchUpdates:^{
        [self.tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    } completion:^(BOOL finished) {
        [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height) animated:YES];
    }];
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
    SparkMessage * message = self.dataSources[indexPath.row];
    [cell updateCell:(message.sender == SPARK) text:message.content];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SparkMessage * message = self.dataSources[indexPath.row];
    [_iFlySpeechSynthesizer startSpeaking: message.content];
}
-(void)onCompleted:(IFlySpeechError *)error{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputTF resignFirstResponder];
}

#pragma mark - Textfield Delgate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    SparkMessage * message = [[SparkMessage alloc] initWithContent:self.inputTF.text from:USER];
    [self.dataSources addObject:message];
    [self.llm arun:textField.text usrContext:nil];
    
    self.inputTF.text = @"";
    [self scrollToBottom];
    
    return true;
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

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillShow:(NSNotification *) notification {
    if (_isKeyboardDidShow) {
        return;
    }
    NSDictionary * userInfo = [notification userInfo];
    int height = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"keyboardheight%d",height);
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.toolbar.frame;
        frame.origin.y = frame.origin.y - height + 20;
        self.toolbar.frame = frame;
        
        frame = self.tableview.frame;
        frame.size.height = frame.size.height - height + 20;
        self.tableview.frame = frame;
        [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height) animated:YES];
    }];
    if(height > 100){
        _isKeyboardDidShow = true;
    }
}

- (void)keyboardWillHide:(NSNotification *) notification {
    NSDictionary * userInfo = [notification userInfo];
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.frame = CGRectMake(0, self.view.bounds.size.height - 84, self.view.bounds.size.width, 64);
        self.tableview.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88 - 84);
    }];
    _isKeyboardDidShow = false;
}

- (void)updateToolbar {
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.inputTF];
    _toolbar.items = @[item];
}


- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 84, self.view.bounds.size.width, 64)];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.buttonInit];
        _toolbar.items = @[item];
    }
    
    return _toolbar;
}

- (UIButton *)buttonInit {
    if (!_buttonInit) {
        _buttonInit = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buttonInit.frame = CGRectMake(0, 0, self.view.bounds.size.width - 80, 44);
        [_buttonInit setTitle:@"SparkChain初始化" forState:(UIControlStateNormal)];
        [_buttonInit setTitleColor:[UIColor systemBlueColor] forState:(UIControlStateNormal)];
        _buttonInit.backgroundColor = UIColor.whiteColor;
        _buttonInit.layer.cornerRadius = 5;
        [_buttonInit addTarget:self action:@selector(initSDK) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    return _buttonInit;
}


- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 80, 44)];
        _inputTF.layer.cornerRadius = 5;
        _inputTF.delegate = self;
        _inputTF.returnKeyType = UIReturnKeySend;
        _inputTF.enablesReturnKeyAutomatically = true;
        _inputTF.backgroundColor = UIColor.whiteColor;
        [_inputTF setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
        [_inputTF setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    }
    return _inputTF;
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88 - 84) style:(UITableViewStylePlain)];
        [_tableview registerClass:[SparkTableViewCell class] forCellReuseIdentifier:@"reuseId"];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 88;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (LLM *)llm {
    if (!_llm) {
        LLMConfig * llmConfig = [[LLMConfig alloc] init];
        llmConfig.domain(@"generalv3");
//        llmConfig.url(@"ws(s)://spark-api.xf-yun.com/v3.1/chat");
        _llm = [[LLM alloc] initWithConfig:llmConfig];
        _llm.callback = self;
    }
    return _llm;
}

@end
