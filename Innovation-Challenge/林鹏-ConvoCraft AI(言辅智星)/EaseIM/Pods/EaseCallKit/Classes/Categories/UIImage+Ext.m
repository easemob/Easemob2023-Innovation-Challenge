//
//  UIImage+Ext.m
//  EaseCallUI
//
//  Created by lixiaoming on 2020/12/11.
//

#import "UIImage+Ext.h"
#import "EaseCallStreamView.h"

@implementation UIImage (Ext)
+ (UIImage*) imageNamedFromBundle:(NSString*)imageName
{
    NSBundle* bundle = [NSBundle bundleForClass:[EaseCallStreamView class]];
    NSString* path = [NSString stringWithFormat:@"EaseCall.bundle/%@",imageName];
    NSString *file1 = [bundle pathForResource:path ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:file1];

    return image1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
