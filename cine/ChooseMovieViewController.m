//
//  ChooseMovieViewController.m
//  cine
//
//  Created by Guyi on 15/12/8.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ChooseMovieViewController.h"
#import "MovieModel.h"
#import "PublishViewController.h"
#import "MovieSecondViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "ReviewPublishViewController.h"
#import "RecommendPublishViewController.h"
#import "RestAPI.h"

@implementation ChooseMovieViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, wScreen, hScreen-20-44) style:UITableViewStylePlain];
    self.dataSource = [[NSMutableArray alloc] init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self setTitle:@"选择影片"];
    [self.view addSubview:self.tableview];
    
    [self.tableview setBackgroundColor:[UIColor lightGrayColor]];
    
    //search
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    
    // 添加 searchbar 到 headerview
    self.tableview.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    self.searchDisplayController.searchResultsDelegate = self;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    _hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
    self.hud.square = YES;//设置显示框的高度和宽度一样
    self.hud.labelText = @"获取电影数据";
    [self.hud show:YES];
    __weak ChooseMovieViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadMovieData:@""];
    });
    
    [self setupHeader];
    [self setupFooter];
    
    
    [MovieModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}


-(void)loadMovieData:(NSString *)key{
    NSLog(@"loadMovieData",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",MOVIE_API,@"/search"];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"searchText"] = key;
    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __weak ChooseMovieViewController *weakSelf = self;
        NSArray *arrModel = [MovieModel mj_objectArrayWithKeyValuesArray:responseObject];
        weakSelf.dataSource = [arrModel mutableCopy];
        [weakSelf.tableview reloadData];
        //        [self.hud hide:YES afterDelay:1];
        [weakSelf.hud hide:YES];
       
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableview]) {
        return [self.dataSource count];
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title contains [cd] %@",self.searchDisplayController.searchBar.text];
        self.filterData = [[NSArray alloc] initWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];
        return self.filterData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [cell setBackgroundColor:[UIColor colorWithRed:248 green:248 blue:248 alpha:0.9]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    MovieModel *model;
    if ([tableView isEqual:self.tableview]) {
        model = [self.dataSource objectAtIndex:indexPath.row];
    }else{
        model = [self.filterData objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = model.title;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",model.year, model.director];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"movieCover.png"]];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(62, 60, 100.0f, 44.0f);
//    [btn setTitle:@"详细" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(movieDetail:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:btn];
//    
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)movieDetail:(UIButton *)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    MovieSecondViewController *movieController = [[MovieSecondViewController alloc]init];
    MovieModel *model = [self.dataSource objectAtIndex:indexPath.row];
    movieController.name = model.title;
    movieController.ID = model.ID;
    
    movieController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:movieController animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建发布页面导航控制器
    
    if([self.judge isEqualToString:@"定格"]){
        
        
        PublishViewController *publishview = [[PublishViewController alloc]init];
        if ([tableView isEqual:self.tableview]) {
            publishview.movie = [self.dataSource objectAtIndex:indexPath.row];
        }else{
            publishview.movie = [self.filterData objectAtIndex:indexPath.row];
        }
        
        [self.navigationController pushViewController:publishview animated:YES];
    
    
    }else if([self.judge isEqualToString:@"评分"]){
        
        ReviewPublishViewController *reviewPublishVC = [[ReviewPublishViewController alloc]init];
        
        
        
        MovieModel *model;
        if ([tableView isEqual:self.tableview]) {
            model = [self.dataSource objectAtIndex:indexPath.row];
        }else{
            model = [self.filterData objectAtIndex:indexPath.row];
        }

        
        
        
                    reviewPublishVC.movie = model;
        
        
      [self.navigationController pushViewController:reviewPublishVC animated:YES];
    
    
    }else if([self.judge isEqualToString:@"推荐"]){
        
        RecommendPublishViewController *recommendPublishVC = [[RecommendPublishViewController alloc]init];
        
        
        
        MovieModel *model;
        if ([tableView isEqual:self.tableview]) {
            model = [self.dataSource objectAtIndex:indexPath.row];
        }else{
            model = [self.filterData objectAtIndex:indexPath.row];
        }

        
        recommendPublishVC.movie = model;
        [self.navigationController pushViewController:recommendPublishVC animated:YES];
        
        
    }

    
    
    
    
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    //定义取消按钮
    /*
     *ios7与ios6方法不同
     */
    for (id searchbutton in self.searchDisplayController.searchBar.subviews)
    {
        UIView *view = (UIView *)searchbutton;
        UIButton *cancelButton = (UIButton *)[view.subviews objectAtIndex:2];
        cancelButton.enabled = YES;
        [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
        break;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//去除 No Results 标签
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        for (UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
                UILabel *label = (UILabel *)subview;
                label.text = @"无结果";
                break;
            }
        }
    });
    return YES;
}

- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
    [self.searchDisplayController.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
}



- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableview];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableview reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableview];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableview reloadData];
        
        [self.refreshFooter endRefreshing];
    });
}

@end
