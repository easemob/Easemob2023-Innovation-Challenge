//
//  NETM.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/27.
//

#import "NETM.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>



#define APPID @"20210413000775485"
//#define APIKEY @"d3d8c27822664f3f9cf9f4c30312c5d6"
#define APISERECT @"3ebYuboNcfZ6PBJHKhm7"
#define KURL @"https://fanyi-api.baidu.com/api/trans/vip/translate"

typedef void(^successBlock)(SparkMessage *reMessage);
//typedef void(^faileBlock)(LLMError *error);

static NETM *_net = nil;

@interface NETM ()
//@property (nonatomic, strong) LLM * llm;
@property (nonatomic, strong) successBlock successB;
//@property (nonatomic, strong) faileBlock faileB;
@end

@implementation NETM{
//    LLMConfig *_llC;
    NSString *_lastQ;
}

+(instancetype)shareManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _net = [[self alloc] init];
    });
    return _net;
}
-(instancetype)init{
    self = [super init];
    if(self){
        _lastQ = @"";
//        SparkChainConfig * config = [[SparkChainConfig alloc] init];
//        config.appID(APPID)
//            .apiKey(APIKEY)
//            .apiSecret(APISERECT)
//            .logLevel(0)
//            .logPath(@"./aikit.log");;
//        int ret = [SparkChain.getInst init:config];
//        
//       // _isInited = (ret == 0);
//        if (ret != 0) {
//            NSLog(@"初始化失败");
//          
//        }else{
//            //初始化成功
//            NSLog(@"初始化成功");
//        }
    }
    return self;
}
-(void)fanyi:(NSString *)yiwenS success:(void (^)(NSString * _Nonnull))successB faile:(void (^)(NSError * _Nonnull))faile{
    
    NSString *qurl = [self keyStrWithTr:yiwenS];
    // 创建 AFHTTPSessionManager 实例
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // 设置响应数据的解析格式，默认是JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // 设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30;

    // 发起 GET 请求
    [manager GET:qurl parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = responseObject;
        if ([res.allKeys containsObject:@"trans_result"]) {
            NSString *tras = [[res objectForKey:@"trans_result"][0] objectForKey:@"dst"];
            successB ? successB(tras) : nil;
        }else{
            faile ? faile(nil) : nil;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile ? faile(nil) : nil;
    }];
}
-(NSString *)keyStrWithTr:(NSString *)q{
//    appid+q+salt+密钥的顺序拼接得到字符串 1
    NSString *key = @"";
    key = [key stringByAppendingString:APPID];
    key = [key stringByAppendingString:q];
    NSString *sa = [NSString stringWithFormat:@"%u",arc4random_uniform(10000)];
    key = [key stringByAppendingString:sa];
    key = [key stringByAppendingString:APISERECT];
    key = md5(key);
    NSString *qUrl = [NSString stringWithFormat:@"%@?q=%@&from=zh&to=en&appid=%@&salt=%@&sign=%@",KURL,q,APPID,sa,key];
    return qUrl;
}
// 计算MD5的函数
NSString* md5(NSString *input) {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
//-(void)requestWithMessage:(NSString *)message success:(void (^)(SparkMessage * _Nonnull))successB faile:(void (^)(LLMError * _Nonnull))faile{
//    NSLog(@"问题：%@",message);
//    successB = self.successB;
//    faile = self.faileB;
//    SparkMessage * spmessage = [[SparkMessage alloc] initWithContent:message from:USER];
//    int ret = [self.llm arun:message usrContext:nil];
//    if(ret != 0){
////        LLMError *error = [[LLMError alloc] initWithSid:self.llm.];
//        self.faileB(nil);
//    }
//    
//}
#pragma mark - LLM Delegate
//- (void)llm:(LLM *)llm onResult:(LLMResult *)result usrContext:(id)usrContext {
//    
//    NSLog(@"result.content:%@",result.content);
////    if (result.status == 0) {
////        SparkMessage * message = [[SparkMessage alloc] initWithContent:result.content from:SPARK];
////        [self.dataSources addObject:message];
////    } else {
////        SparkMessage * message = self.dataSources.lastObject;
////        message.content = [message.content stringByAppendingString:result.content];
////
////        if (result.status == 2) {
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [self scrollToBottom];
////            });
////        }
////    }
////    
////    //关联上下文 异步调用时此代码需打开
//////    [self.result appendString:result.content];
//////    if(result.status == 2){
//////        dispatch_semaphore_signal(_sema);
//////    }
//    
//}
//
//- (void)llm:(LLM *)llm onEvent:(LLMEvent *)event usrContext:(id)usrContext {
//    
//}
//
//- (void)llm:(LLM *)llm onError:(LLMError *)error usrContext:(id)usrContext {
//    //关联上下文 异步调用时此代码需打开
//    //dispatch_semaphore_signal(_sema);
//    NSLog(@"code:%d,msg:%@",error.errCode,error.errMsg);
//}
//- (LLM *)llm {
//    if (!_llm) {
//        LLMConfig * llmConfig = [[LLMConfig alloc] init];
//        llmConfig.domain(@"generalv3");
////        llmConfig.url(@"ws(s)://spark-api.xf-yun.com/v3.1/chat");
//        _llm = [[LLM alloc] initWithConfig:llmConfig];
//        _llm.callback = self;
//    }
//    return _llm;
//}
@end
