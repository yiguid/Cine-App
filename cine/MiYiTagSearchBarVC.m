//
//  MiYiTagSearchBarVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/27.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "MiYiTagSearchBarVC.h"
#import "pch.h"
@interface MiYiTagSearchBarVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UISearchBar *searchBar;

//@property (nonatomic, strong) UITextField *searchField;

@property(nonatomic,strong)UITextField *textField ;

@property (nonatomic ,strong) UITableView *tableView ;

@property (nonatomic ,strong) NSArray *dataList;

@property (strong, nonatomic) NSMutableDictionary *sectionDict;

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
    
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = CGRectMake(wScreen-70-20, 10, 70, 44) ;
    button.backgroundColor = [UIColor lightGrayColor] ;
    [button setTitle:@"确定" forState:UIControlStateNormal] ;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside] ;
    [textView addSubview:button] ;
    
    // 输入框
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, wScreen-90,44)] ;
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


#pragma mark - buttonAction 点击确定添加便签
- (void)buttonAction:(UIButton *)button
{
    
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
