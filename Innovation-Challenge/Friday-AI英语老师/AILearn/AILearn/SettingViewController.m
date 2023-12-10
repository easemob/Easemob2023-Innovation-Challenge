//
//  SettingViewController.m
//  AILearn
//
//  Created by 岳腾飞 on 2023/11/27.
//

#import "SettingViewController.h"
#import "NETM.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *djBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)actionForDengji:(UIButton *)sender {
    [self showDengjiAlert];
}
-(void)showDengjiAlert{
    UIAlertController *alC = [UIAlertController alertControllerWithTitle:@"请选择英语等级" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alC addAction:[UIAlertAction actionWithTitle:@"小学" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@"1" forKey:kUD_DJ];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.djBtn setTitle:@"小学" forState:UIControlStateNormal];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"初中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@"2" forKey:kUD_DJ];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.djBtn setTitle:@"初中" forState:UIControlStateNormal];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"高中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@"3" forKey:kUD_DJ];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.djBtn setTitle:@"高中" forState:UIControlStateNormal];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"大学" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@"4" forKey:kUD_DJ];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.djBtn setTitle:@"大学" forState:UIControlStateNormal];
    }]];
    [alC addAction:[UIAlertAction actionWithTitle:@"研究生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSUserDefaults.standardUserDefaults setObject:@"5" forKey:kUD_DJ];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.djBtn setTitle:@"研究生" forState:UIControlStateNormal];
    }]];
    [self presentViewController:alC animated:YES completion:nil];
}
@end
