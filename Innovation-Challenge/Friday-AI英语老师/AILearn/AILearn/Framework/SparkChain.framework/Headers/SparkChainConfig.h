//
//  SparkChainConfig.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define chainProperty(returnType,name) property(nonatomic, readonly, copy) returnType (^name)

@interface SparkChainConfig : NSObject

@chainProperty(SparkChainConfig *,appID)(NSString * appID);

@chainProperty(SparkChainConfig *,apiKey)(NSString * apiKey);

@chainProperty(SparkChainConfig *,apiSecret)(NSString * apiSecret);

@chainProperty(SparkChainConfig *,workDir)(NSString * workDir);

@chainProperty(SparkChainConfig *,uid)(NSString * uid);

@chainProperty(SparkChainConfig *,logLevel)(int logLevel);

@chainProperty(SparkChainConfig *,logPath)(NSString  * logPath);

@end

NS_ASSUME_NONNULL_END
