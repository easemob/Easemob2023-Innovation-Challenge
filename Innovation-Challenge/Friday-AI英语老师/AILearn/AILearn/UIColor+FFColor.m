//
//  UIColor+FFColor.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/29.
//

#import "UIColor+FFColor.h"

@implementation UIColor (FFColor)
+ (UIColor *)hexColor:(NSString *)hex {
    return [self hexColor:hex Alpha:1];
}
+ (UIColor *)hexColor:(NSString *)hex Alpha:(CGFloat)Alpha{
    long red = strtoul([[hex substringWithRange:NSMakeRange(1, 2)]UTF8String], 0, 16);
    long green = strtoul([[hex substringWithRange:NSMakeRange(3, 2)]UTF8String], 0, 16);
    long blue = strtoul([[hex  substringWithRange:NSMakeRange(5, 2)]UTF8String], 0, 16);
    return [UIColor colorWithRed:red / 255.0f green:green/ 255.0f blue:blue / 255.0f alpha:Alpha];
}
@end
