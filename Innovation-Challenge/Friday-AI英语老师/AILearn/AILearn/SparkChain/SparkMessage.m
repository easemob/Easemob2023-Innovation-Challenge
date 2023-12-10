//
//  SparkMessage.m
//  AiEdgeDemo
//
//  Created by pcfang on 7.5.23.
//

#import "SparkMessage.h"

@implementation SparkMessage

- (instancetype)initWithContent:(NSString *)text from:(MessageSender)sender {
    self = [super init];
    if (self) {
        self.content = text;
        self.sender = sender;
    }
    
    return self;
}

@end
