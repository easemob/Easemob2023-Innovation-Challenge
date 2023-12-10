//
//  LLMEvent.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>
#import <SparkChain/LLMBaseOutput.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMEvent : LLMBaseOutput

@property (nonatomic, assign, readonly) int eventID;

@property (nonatomic, copy, readonly) NSString * eventMsg;

@end

NS_ASSUME_NONNULL_END
