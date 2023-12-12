#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EaseCallManager.h"
#import "EaseCallDefine.h"
#import "EaseCallError.h"
#import "EaseCallConfig.h"
#import "EaseCallUIKit.h"

FOUNDATION_EXPORT double EaseCallKitVersionNumber;
FOUNDATION_EXPORT const unsigned char EaseCallKitVersionString[];

