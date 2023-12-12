//
//  LLMResult.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>
#import <SparkChain/LLMBaseOutput.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMResult : LLMBaseOutput

@property (nonatomic, copy, readonly) NSString * _Nullable raw;

@property (nonatomic, copy, readonly) NSString * _Nullable role;

@property (nonatomic, copy, readonly) NSString * _Nullable content;

@property (nonatomic, assign, readonly) int status;

@property (nonatomic, assign, readonly) int completionTokens;

@property (nonatomic, assign, readonly) int promptTokens;

@property (nonatomic, assign, readonly) int totalTokens;


@end


@interface LLMOutput : LLMBaseOutput

@property (nonatomic, copy, readonly) NSString * _Nullable raw;

@property (nonatomic, copy, readonly) NSString * _Nullable role;

@property (nonatomic, copy, readonly) NSString *  _Nullable content;

@property (nonatomic, assign, readonly) int status;

@property (nonatomic, assign, readonly) int completionTokens;

@property (nonatomic, assign, readonly) int promptTokens;

@property (nonatomic, assign, readonly) int totalTokens;

@property (nonatomic, assign, readonly) int errCode;

@property (nonatomic, copy, readonly) NSString * _Nullable errMsg;

@end

NS_ASSUME_NONNULL_END
