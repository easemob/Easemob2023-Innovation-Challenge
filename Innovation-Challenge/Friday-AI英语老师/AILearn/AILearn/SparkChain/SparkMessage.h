//
//  SparkMessage.h
//  AiEdgeDemo
//
//  Created by pcfang on 7.5.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SPARK,
    USER,
} MessageSender;

@interface SparkMessage : NSObject
@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) MessageSender sender;

- (instancetype)initWithContent:(NSString *)text from:(MessageSender)sender;
@end

NS_ASSUME_NONNULL_END
