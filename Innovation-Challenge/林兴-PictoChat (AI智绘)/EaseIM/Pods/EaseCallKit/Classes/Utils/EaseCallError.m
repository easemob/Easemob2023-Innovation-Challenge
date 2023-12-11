//
//  EaseCallError.m
//  EaseIM
//
//  Created by lixiaoming on 2021/1/29.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import "EaseCallError.h"

@implementation EaseCallError
+(instancetype)errorWithType:(EaseCallErrorType)aType code:(NSInteger)aErrCode description:(NSString*)aDescription
{
    EaseCallError* error = [[EaseCallError alloc] init];
    if(error) {
        error.aErrorType = aType;
        error.errCode = aErrCode;
        error.errDescription = aDescription;
    }
    return error;
}
@end
