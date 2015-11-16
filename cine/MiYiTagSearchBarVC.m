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

@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic ,strong) UITableView *tableView ;

@property (nonatomic ,strong) NSArray *dataList;

@property (strong, nonatomic) NSMutableDictionary *sectionDict;

@end

@implementation MiYiTagSearchBarVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@"我们",@"你们",@"天气真好",@"加油你可以的",@"北京航空航天大学北海学院"] ;
    
    
    _searchBar =[[UISearchBar alloc]init];
    [self.searchBar setPlaceholder:@"搜索"];
    [self.searchBar setTintColor:HEX_COLOR_THEME];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"TagSearchBar"] forState:UIControlStateNormal];
    self.searchBar.delegate=self;
    self.navigationItem.titleView=_searchBar;
    
//    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, [UIScreen mainScreen].bounds.size.height-49) style:UITableViewStylePlain] ;
    tableView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    tableView.dataSource=self;
    tableView.delegate=self;
//    [tableView setSectionHeaderHeight:50];
//    [tableView setRowHeight:50];
    [self.view addSubview:tableView];

    self.sectionDict = [NSMutableDictionary dictionaryWithCapacity:self.dataList.count];
    
    // Do any additional setup after loading the view.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchBar.text);
    
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
@end
