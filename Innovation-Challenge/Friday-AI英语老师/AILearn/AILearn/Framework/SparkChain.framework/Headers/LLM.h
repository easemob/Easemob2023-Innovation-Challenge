//
//  LLM.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>
@class LLM;
@class LLMEvent;
@class LLMError;
@class LLMResult;
@class LLMConfig;
@class LLMOutput;

NS_ASSUME_NONNULL_BEGIN

@protocol LLMCallback <NSObject>

- (void)llm:(LLM *)llm onResult:(LLMResult * _Nullable)result usrContext:(id _Nullable)usrContext;

- (void)llm:(LLM *)llm onEvent:(LLMEvent * _Nullable)event usrContext:(id _Nullable)usrContext;

- (void)llm:(LLM *)llm onError:(LLMError * _Nullable)error usrContext:(id _Nullable)usrContext;

@end


@interface LLM : NSObject

@property(nonatomic, weak) id<LLMCallback> callback;

@property(nonatomic, strong, readonly) LLMConfig * config;

- (instancetype)init;

- (instancetype)initWithConfig:(LLMConfig * _Nullable)config;

- (instancetype)initWithCallback:(id<LLMCallback> _Nullable)callback;

- (instancetype)initWithConfig:(LLMConfig * _Nullable)config callback:(id<LLMCallback> _Nullable)callback;

- (LLMOutput *)run:(NSString *)query;

- (int)arun:(NSString *)query;

- (int)arun:(NSString *)query usrContext:(id _Nullable)usrContext;

@end

NS_ASSUME_NONNULL_END
