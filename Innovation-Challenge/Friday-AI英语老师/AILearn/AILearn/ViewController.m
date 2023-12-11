//
//  ViewController.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/23.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.iflyaicloud.com/portal/AIHub"]] resume];
}


@end
