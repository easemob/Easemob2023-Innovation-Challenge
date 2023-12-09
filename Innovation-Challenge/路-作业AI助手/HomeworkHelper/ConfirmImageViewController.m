//
//  ConfirmImageViewController.m
//  HomeworkHelper
//
//  Created by Mac on 2023/12/4.
//

#import "ConfirmImageViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "EMChatViewController.h"
@interface ConfirmImageViewController (){
    MBProgressHUD *hud;
    EMChatViewController *chat;
}
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end

@implementation ConfirmImageViewController
- (void)viewWillAppear:(BOOL)animated{
    [chat loadRewardedAd];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    chat = [[EMChatViewController alloc] initWithConversationId:@"AIMain" conversationType:EMConversationTypeChat];
//    [chat loadRewardedAd];
//    _selectedImageView.layer.borderColor = UIColor.blackColor.CGColor;
//    _selectedImageView.layer.borderWidth = 1;
//    _selectedImageView.layer.cornerRadius = 5;
//    _selectedImageView.clipsToBounds = true;
    _selectedImageView.image = _scanImg;
    // Do any additional setup after loading the view from its nib.
    
    NSString *s = @"https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token=";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",s,_astkn];
    
    NSData *imgData = UIImagePNGRepresentation(_scanImg);
    NSString *base64Str = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary * parametersDic = @{
                                         @"image":base64Str
                                         
                                         };
//    hud  = [[MBProgressHUD alloc] initWithView:self.view];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:parametersDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"图像解析成功：%@",responseObject);
//        [SVProgressHUD dismiss];
//        [MBProgressHUD hid]
        [MBProgressHUD hideHUDForView:self.view animated:true];
        NSDictionary *data = responseObject;
        [self setTextViewContent:data];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"图像解析失败"];
//        [self->hud hideAnimated:true];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [MBProgressHUD showAlertWithMessage:[NSString stringWithFormat:@"图像解析失败：%@",error.description]];
        NSLog(@"图像解析失败：%@",error.description);
    }];
    
}
- (IBAction)homeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidAppear:(BOOL)animated{
//    [hud showAnimated:true];
//    [SVProgressHUD show];
}
- (IBAction)confirmToAsk:(id)sender {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请问您要问的题目是：%@吗？",_mainTextView.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *b = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        chat.scanStr = self->_mainTextView.text;
        [self.navigationController pushViewController:chat animated:true];
    }];
    UIAlertAction *c = [UIAlertAction actionWithTitle:@"我还要修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [a addAction:b];
    [a addAction:c];
    [self presentViewController:a animated:true completion:nil];

}

-(void)setTextViewContent:(NSDictionary *)d{
    NSArray *textArr = [d objectForKey:@"words_result"];
    for (int i = 0; i<textArr.count; i++) {
        if([_mainTextView.text isEqualToString:@""]){
            _mainTextView.text = [textArr[i] objectForKey:@"words"];
        }else{
            _mainTextView.text = [NSString stringWithFormat:@"%@\n%@",_mainTextView.text,[textArr[i] objectForKey:@"words"]];
        }
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
