//
//  NETM.h
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/27.
//

#import <Foundation/Foundation.h>
#import "SparkMessage.h"

NS_ASSUME_NONNULL_BEGIN
#define kUD_DJ     @"un_dj"

@interface NETM : NSObject
+(instancetype)shareManger;
//-(void)requestWithMessage:(NSString *)message success:(void(^)(SparkMessage *resMessage))successB faile:(void (^)(LLMError *error))faile;
-(void)fanyi:(NSString *)yiwenS success:(void(^)(NSString *traS))successB faile:(void (^)(NSError *error))faile;
@end

NS_ASSUME_NONNULL_END
