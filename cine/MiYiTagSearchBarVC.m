//
//  MiYiTagSearchBarVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/27.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "MiYiTagSearchBarVC.h"
#import "pch.h"
#import "AMTagListView.h"
#import "RestAPI.h"
#import "TagModel.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MiYiTagSearchBarVC ()


@property (nonatomic ,strong) NSMutableArray * TagsArr;

@property(nonatomic,strong)UITextField *textField;


// 新添加的代码
@property (strong, nonatomic)AMTagListView	*tagListView;
@property (strong, nonatomic)AMTagListView	*hotTagListView;
@property (nonatomic, strong)AMTagView     *selection;

@end

@implementation MiYiTagSearchBarVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.tabBarController.tabBar.hidden = YES;
    // 给YES才不会漏出便签栏的黑色底部
    self.tabBarController.tabBar.translucent = YES;
//    self.title = @"添加文字标签";
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Futura" size:18];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"添加文字标签";
    self.navigationItem.titleView = titleLabel;
    // 添加文本
    [self _initTextfield];
    
}

- (void)_initTextfield
{
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 44)];
    textView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:textView];
    
    
    [[AMTagView appearance] setTagLength:10];
    [[AMTagView appearance] setTextPadding:14];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
    
    UILabel *myTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44+10, wScreen-40, 20)];
    myTagLabel.text = @"已经添加过的标签";
    myTagLabel.font = [UIFont fontWithName:@"Futura" size:14];
    [self.view addSubview:myTagLabel];
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myTagLabel.frame) + 10, wScreen, 1)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horizontalLine];
    
    
    self.tagListView = [[AMTagListView alloc]initWithFrame:CGRectMake(20, 44+50, wScreen-40, (hScreen-64-49-44-50)/2 - 40) andNotificationName:@"AMTagViewNotification"];
    self.hotTagListView = [[AMTagListView alloc] initWithFrame:CGRectMake(20, 370, wScreen - 40, (hScreen-64-49-44-50)/2) andNotificationName:@"HotAMTagViewNotification"];
    
    
    UILabel *myHotTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tagListView.frame), wScreen-40, 20)];
    myHotTagLabel.text = @"热门标签";
    myHotTagLabel.font = [UIFont fontWithName:@"Futura" size:14];
    [self.view addSubview:myHotTagLabel];
    
    horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myHotTagLabel.frame) + 10, wScreen, 1)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horizontalLine];
    
    
    //添加已有标签
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSDictionary *parameters = @{@"user": userId};
    NSString *url = [NSString stringWithFormat:@"%@/%@",TAG_API,@"recent"];
    __weak MiYiTagSearchBarVC *weakSelf = self;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             weakSelf.TagsArr = [TagModel mj_objectArrayWithKeyValuesArray:responseObject[@"recent_tags"]];
             for (TagModel *model in weakSelf.TagsArr) {
                 [self.tagListView addTag:model.name withNotificationName:self.tagListView.myAMTagViewNotification];
             }
             
             [self.view addSubview:self.tagListView];
             
             [self.tagListView setTapHandler:^(AMTagView *view) {
                 weakSelf.selection = view;
                 [weakSelf insertTag];
             }];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    //添加热门标签
    url = [NSString stringWithFormat:@"%@/%@",TAG_API,@"hot"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             weakSelf.TagsArr = [TagModel mj_objectArrayWithKeyValuesArray:responseObject[@"hot_tags"]];
             for (TagModel *model in weakSelf.TagsArr) {
                 [weakSelf.hotTagListView addTag:model.name withNotificationName:self.hotTagListView.myAMTagViewNotification];
             }
             
             [weakSelf.view addSubview:weakSelf.hotTagListView];
             
             [weakSelf.hotTagListView setTapHandler:^(AMTagView *view) {
                 if(view.myAMTagViewNotification == weakSelf.hotTagListView.myAMTagViewNotification){
                     weakSelf.selection = view;
                     [weakSelf insertTag];
                 }
             }];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
//    [self.tagListView addTag:@"美翻了"];
//    [self.tagListView addTag:@"当时就震惊了"];
//    [self.tagListView addTag:@"演技一流"];
//    [self.tagListView addTag:@"好看"];
    
    
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(wScreen-70-10, 5, 70, 34);
    button.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:button];
    
    // 输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, wScreen-100,34)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    [textView addSubview:_textField];
    
    
}

- (void)insertTag
{
    NSString *string = self.selection.labelText.text;
    _block(string);
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [self.tagListView addTag:textField.text withNotificationName:self.tagListView.myAMTagViewNotification];
        [self.textField setText:@""];
    }
    [textField resignFirstResponder];
    return YES;
}

// Close the keyboard when the user taps away froma  textfield
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    for (UIView* view in self.view.subviews) {
//        if ([view isKindOfClass:[UITextField class]])
//            [view resignFirstResponder];
//    }
    [self.view endEditing:YES];
}


#pragma mark - buttonAction 点击确定添加便签
- (void)buttonAction:(UIButton *)button
{
    if (![self.textField.text isEqualToString:@""]) {
        [self.tagListView addTag:_textField.text withNotificationName:self.tagListView.myAMTagViewNotification];
        [self.textField setText:@""];
    }
}

#pragma mark - 试图将要显示和消失掉用的方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


@end
