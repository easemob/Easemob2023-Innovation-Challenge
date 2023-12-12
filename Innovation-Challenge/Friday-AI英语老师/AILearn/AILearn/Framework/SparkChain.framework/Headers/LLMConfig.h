//
//  LLMConfig.h
//  SparkChain
//
//  Created by pcfang on 12.9.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define chainProperty(returnType,name) property(nonatomic, readonly, copy) returnType (^name)

@interface LLMConfig : NSObject

@chainProperty(LLMConfig *,uid)(NSString * uid);

@chainProperty(LLMConfig *,domain)(NSString * domain);

@chainProperty(LLMConfig *,auditing)(NSString * auditing);

@chainProperty(LLMConfig *,chatID)(NSString * chatID);

@chainProperty(LLMConfig *,temperature)(float temperature);

@chainProperty(LLMConfig *,topK)(int topK);

@chainProperty(LLMConfig *,maxToken)(int maxToken);

@chainProperty(LLMConfig *,url)(NSString * url);

@chainProperty(LLMConfig *,addString)(NSString * key, NSString * param);

@chainProperty(LLMConfig *,addDouble)(NSString * key,double param);

@chainProperty(LLMConfig *,addInt)(NSString * key,int param);

@chainProperty(LLMConfig *,addBool)(NSString * key,BOOL param);

@end

NS_ASSUME_NONNULL_END
