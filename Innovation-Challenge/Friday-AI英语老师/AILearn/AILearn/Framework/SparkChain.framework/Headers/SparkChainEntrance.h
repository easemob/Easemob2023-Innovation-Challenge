//
//  SparkChain.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>
@class SparkChainConfig;

NS_ASSUME_NONNULL_BEGIN

@interface SparkChain : NSObject

+ (SparkChain *)getInst;

- (int)init:(SparkChainConfig *)config;

- (int)unInit;

- (int)setConfig:(NSString *)key value:(void *)value;
@end

NS_ASSUME_NONNULL_END
