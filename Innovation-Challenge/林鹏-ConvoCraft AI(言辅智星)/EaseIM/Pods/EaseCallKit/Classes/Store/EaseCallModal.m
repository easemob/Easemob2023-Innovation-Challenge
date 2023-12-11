//
//  EaseCallModal.m
//  EaseIM
//
//  Created by lixiaoming on 2021/1/8.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import "EaseCallModal.h"

@implementation ECCall

- (NSMutableDictionary*)allUserAccounts
{
    if(!_allUserAccounts) {
        _allUserAccounts = [NSMutableDictionary dictionary];
    }
    return _allUserAccounts;
}
@end

@interface EaseCallModal ()
@property (nonatomic,weak) id<EaseCallModalDelegate> delegate;
@end

@implementation EaseCallModal
@synthesize state = _state;
- (instancetype)initWithDelegate:(id<EaseCallModalDelegate>)delegate
{
    self = [super init];
    if(self) {
        self.delegate = delegate;
        self.currentCall = nil;
        self.hasJoinedChannel = NO;
    }
    return self;
}
- (NSMutableDictionary*)recvCalls
{
    if(!_recvCalls) {
        _recvCalls = [NSMutableDictionary dictionary];
    }
    return _recvCalls;
}

- (NSString*)curDevId
{
    if([_curDevId length] == 0) {
        _curDevId = [NSString stringWithFormat:@"ios_%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString] ];
    }
    return _curDevId;
}

- (void)setState:(EaseCallState)state
{
    if(self.delegate && state != _state) {
        [self.delegate callStateWillChangeTo:state from:_state];
    }
    _state = state;
}

- (EaseCallState)state
{
    return _state;
}
@end
