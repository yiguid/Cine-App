//
//  StartViewController.m
//  cine
//
//  Created by Guyi on 15/10/28.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "StartGenderViewController.h"
#import "UIImageView+WebCache.h"
@interface StartGenderViewController ()

@end

@implementation StartGenderViewController

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [accountDefaults objectForKey:@"nickname"];
    self.nickname.text = nickname;
    self.nickname.textColor = [UIColor whiteColor];
    NSString *avatar = [accountDefaults objectForKey:@"avatarURL"];
    
    if ([avatar isEqualToString:@"choose-touxiang.png"]) {
        
        self.headimage.image = [UIImage imageNamed:@"choose-touxiang.png"];
        
        
    }else{
    
        [self.headimage sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatar@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [self.headimage setImage:self.headimage.image];
                    //头像圆形
                    self.headimage.layer.masksToBounds = YES;
                    self.headimage.layer.cornerRadius = self.headimage.frame.size.width/2;
                    //头像边框
                    self.headimage.layer.borderColor = [UIColor whiteColor].CGColor;
                    self.headimage.layer.borderWidth = 1.5;
                    
                }];
    
    }
    

    
    
    //初始化性别
    [accountDefaults setObject:@"0" forKey:@"gender"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveGender:(id)sender {
    //下一步
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StartScene"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chooseGender:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSString *index = [NSString stringWithFormat:@"%ld",seg.selectedSegmentIndex] ;
    //保存性别
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:index forKey:@"gender"];
}

@end
