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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MiYiTagSearchBarVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UISearchBar *searchBar;

//@property (nonatomic, strong) UITextField *searchField;

@property(nonatomic,strong)UITextField *textField ;

@property (nonatomic ,strong) NSArray *dataList;

@property (strong, nonatomic) NSMutableDictionary *sectionDict;

// 新添加的代码
@property (strong, nonatomic)AMTagListView	*tagListView;
@property (nonatomic, strong)AMTagView     *selection;

@end

@implementation MiYiTagSearchBarVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@"我们",@"你们",@"天气真好",@"加油你可以的",@"北京航空航天大学北海学院"] ;
    
    self.tabBarController.tabBar.hidden = YES ;
    // 给YES才不会漏出便签栏的黑色底部
    self.tabBarController.tabBar.translucent = YES ;
    
    self.view.backgroundColor = [UIColor lightGrayColor] ;
    
    // 添加文本
    [self _initTextfield] ;
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, [UIScreen mainScreen].bounds.size.height-49) style:UITableViewStylePlain] ;
//    tableView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
//    tableView.dataSource=self;
//    tableView.delegate=self;
//    [self.view addSubview:tableView];

    self.sectionDict = [NSMutableDictionary dictionaryWithCapacity:self.dataList.count];
    
}

- (void)_initTextfield
{
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 44+20)] ;
    textView.backgroundColor = [UIColor colorWithRed:255/255.0 green:245/255.0 blue:247/255.0 alpha:1] ;
    [self.view addSubview:textView] ;
    
    
    [[AMTagView appearance] setTagLength:10];
    [[AMTagView appearance] setTextPadding:14];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
    
    
    _tagListView = [[AMTagListView alloc]initWithFrame:CGRectMake(20, 44+20+50, wScreen-40, hScreen-64-49-44-20-50)] ;
    
    [self.tagListView addTag:@"my tag"];
    [self.tagListView addTag:@"something"];
    [self.tagListView addTag:@"long tag is long"];
    [self.tagListView addTag:@"hi there"];
    
    [self.view addSubview:self.tagListView];
    
    __weak MiYiTagSearchBarVC* weakSelf = self;
    [self.tagListView setTapHandler:^(AMTagView *view) {
        weakSelf.selection = view;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"您想删除呢，还是添加到图片上去", [view tagText]]
                                                       delegate:weakSelf
                                              cancelButtonTitle:@"添加"
                                              otherButtonTitles:@"删除", nil];
        [alert show];
    }];
    
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = CGRectMake(wScreen-70-10, 10, 70, 44) ;
    button.backgroundColor = [UIColor lightGrayColor] ;
    [button setTitle:@"确定" forState:UIControlStateNormal] ;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    [textView addSubview:button] ;
    
    // 输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, wScreen-100,44)] ;
    _textField.backgroundColor = [UIColor whiteColor] ;
    _textField.delegate = self ;
    [textView addSubview:_textField] ;
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TagSearchBarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell.textLabel setText:self.dataList[indexPath.row]];
    
    return cell;
}

// cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.dataList[indexPath.row] ;
    _block(string) ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        // 删除
        [self.tagListView removeTag:self.selection];
    }
    else
    {
//        NSString *string = self.dataList[indexPath.row] ;
        
        NSString *string = self.selection.labelText.text ;
        _block(string) ;
        [self.navigationController popViewControllerAnimated:YES] ;

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tagListView addTag:textField.text];
    [self.textField setText:@""];
    return YES;
}

// Close the keyboard when the user taps away froma  textfield
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}


#pragma mark - buttonAction 点击确定添加便签
- (void)buttonAction:(UIButton *)button
{
    [self.tagListView addTag:_textField.text];
    [self.textField setText:@""];
}

#pragma mark - 试图将要显示和消失掉用的方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor] ;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor] ;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor] ;
}


@end
