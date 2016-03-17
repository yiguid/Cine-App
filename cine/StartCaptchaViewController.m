//
//  StartViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartCaptchaViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"

@interface StartCaptchaViewController ()
@property MBProgressHUD *hud;
@end

@implementation StartCaptchaViewController

- (void)modifyUITextField: (UITextField *) textField {
    CGRect rect = textField.frame;
    rect.size.height = 50;
    textField.frame = rect;
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)modifyUIButton: (UIButton *) button {
    button.backgroundColor = [UIColor grayColor];
    CGRect rect = button.frame;
    rect.size.height = 50;
    button.frame = rect;
    button.layer.cornerRadius = 6.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyUIButton:self.nextBtn];
    [self modifyUITextField:self.captcha];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [accountDefaults objectForKey:@"mobile"];
    self.mobileInfo.text = [NSString stringWithFormat:@"%@", mobile];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.labelText = @"验证验证码...";//显示提示
    //hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
   
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.yanzhengBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.yanzhengBtn.backgroundColor = [UIColor clearColor];
                self.yanzhengBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            NSInteger sconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                             
                 self.yanzhengBtn.userInteractionEnabled=NO;
                [self.yanzhengBtn setBackgroundColor:[UIColor clearColor]];
                self.yanzhengBtn.titleLabel.text = [NSString stringWithFormat:@"%ld秒",sconds];
                [self.yanzhengBtn setTitle:[NSString stringWithFormat:@"%ld秒",sconds] forState:UIControlStateNormal];
            });
            timeout --;
        }    });
    dispatch_resume(_timer);

    
    [self.yanzhengBtn.layer setCornerRadius:16.0]; //设置矩圆角半径
    [self.yanzhengBtn.layer setBorderWidth:0.6];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){254/255.0 ,153/255.0,0/255.0,1.0});
    [self.yanzhengBtn.layer setBorderColor:colorref];//边框颜色
    
    [self.yanzhengBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)startTime{
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:120];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    //你的接口地址
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASE_API,@"invite"];
    //发送请求
    //服务器真实数据
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *msg = responseObject;
        NSLog(@"%@",msg[@"invite"],nil);
        //发送验证码
        //传入的参数
        NSDictionary *parameters = @{@"phone":self.mobileInfo.text, @"invite":msg[@"invite"]};
        NSString *codeUrl = [NSString stringWithFormat:@"%@/%@",BASE_API,@"auth/sendSMSCode"];
        [manager POST:codeUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            //NSDictionary *msg = responseObject;
            //NSLog(@"%@",msg[@"invite"],nil);
            //发送验证码
    
           
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.yanzhengBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                        self.yanzhengBtn.backgroundColor = [UIColor clearColor];
                        self.yanzhengBtn.userInteractionEnabled = YES;
                    });
                }else{
                    //            int minutes = timeout / 60;
                    NSInteger sconds = timeout % 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                         self.yanzhengBtn.userInteractionEnabled=NO;
                        [self.yanzhengBtn setBackgroundColor:[UIColor clearColor]];
                        self.yanzhengBtn.titleLabel.text = [NSString stringWithFormat:@"%ld秒",sconds];
                        [self.yanzhengBtn setTitle:[NSString stringWithFormat:@"%ld秒",sconds] forState:UIControlStateNormal];
                    });
                    timeout --;
                }
            });
            dispatch_resume(_timer);

          
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            self.hud.labelText = @"验证码发送失败...";//显示提示
            [self.hud show:YES];
            
            [self.hud hide:YES afterDelay:2];
            
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.hud.labelText = @"服务器有问题啦...";//显示提示
        [self.hud show:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES afterDelay:2];
            
        });
        
    }];
    
    
   }






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)verifyCaptcha:(id)sender {
    //本地测试
    [self.hud show:YES];
    
    [self.hud hide:YES afterDelay:2];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:120];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [accountDefaults objectForKey:@"mobile"];
    
    NSDictionary *parameters = @{@"phone":mobile, @"code":self.captcha.text};
    //你的接口地址
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASE_API,@"auth/verifySmsCode"];
    //发送请求
    //服务器真实数据
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (!([self.captcha.text isEqualToString:@""])) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartPasswordScene"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            self.hud.labelText = @"验证码输入有误...";//显示提示
            [self.hud show:YES];
            [self.hud hide:YES afterDelay:2];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.hud.labelText = @"验证码输入错误...";//显示提示
        [self.hud show:YES];
        [self.hud hide:YES afterDelay:2];
    }];
}

@end
