//
//  LLMBaseOutput.h
//  SparkChain
//
//  Created by pcfang on 15.9.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMBaseOutput : NSObject

@property (nonatomic, copy, readonly) NSString * sid;


- (instancetype)initWithSid:(NSString *)sid;
@end

NS_ASSUME_NONNULL_END
