//
//  LLMError.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>
#import <SparkChain/LLMBaseOutput.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMError : LLMBaseOutput

@property (nonatomic, assign, readonly) int errCode;

@property (nonatomic, copy, readonly) NSString * errMsg;

@end

NS_ASSUME_NONNULL_END
