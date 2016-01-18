//
//  DinggeTotalTableViewController.m
//  cine
//
//  Created by wang on 16/1/4.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "DinggeTotalTableViewController.h"
#import "DinggeSecondViewController.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "DingGeModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RestAPI.h"
#import "TadeTableViewController.h"
#import "MovieTableViewController.h"
@interface DinggeTotalTableViewController (){
    
    NSMutableArray * DingGeArr;
}

@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic, strong)NSArray *statusFramesDingGe;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;


@end

@implementation DinggeTotalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"影片定格";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDingGeData];
    [self setupHeader];
    [self setupFooter];
    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
    
}


- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
   
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"movie"] = self.movieID;
    [manager GET:DINGGE_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             self.DingArr = DingGeArr;
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 model.zambiaCount = model.voteCount;
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",(long)comments];
                 model.answerCount = com;
                 model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
                 model.nikeName = model.user.nickname;
                 model.time = model.createdAt;
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
                 [statusFrames addObject:statusFrame];
             }
             
             
             self.statusFramesDingGe = statusFrames;
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.statusFramesDingGe count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
    //设置cell
    cell.modelFrame = self.statusFramesDingGe[indexPath.row];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    
    DingGeModel *model = self.DingArr[indexPath.row];
    
    NSString * string = model.image;
    
    __weak DinggeTotalTableViewController *weakSelf = self;
    
    //设置cell
    cell.modelFrame = self.statusFramesDingGe[indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:string];
    if( ![manager diskImageExistsForURL:url]){
        [imageView sd_cancelCurrentImageLoad];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"myBackImg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"Dingge Image Size: %f",image.size.height,nil);
            if (image.size.height > 0) {
                cell.tagEditorImageView.imagePreviews.image = image;
                CGFloat ratio = (wScreen - 10) / image.size.width;
                cell.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, image.size.height * ratio); //190
                cell.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, image.size.height * ratio);
                cell.commentview.frame = CGRectMake(5,image.size.height * ratio - 25,wScreen-20, 30);
                DingGeModelFrame *statusFrame = weakSelf.statusFramesDingGe[indexPath.row];
                statusFrame.imageHeight = image.size.height * ratio;
                cell.ratio = ratio;
                [cell setTags];
                //                    [statusFrame setModel:model];
                //                    [weakSelf.statusFramesDingGe setObject:statusFrame atIndexedSubscript:indexPath.row];
                //                    ((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]).imageHeight = image.size.height;
                //                    [((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]) setModel:model];
                NSInteger height = [statusFrame getHeight:model];
                [self.cellHeightDic setObject:[NSString stringWithFormat:@"%ld",(long)height] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                //                    cell.modelFrame = statusFrame;
                //                    [weakSelf performSelectorOnMainThread:@selector(reloadCellAtIndexPath:) withObject:indexPath waitUntilDone:NO];
                
                //                    [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView reloadData];
            }
        }];
    }else{
        UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        cell.tagEditorImageView.imagePreviews.image = image;
        
        CGFloat ratio = (wScreen - 10) / image.size.width;
        
        cell.tagEditorImageView.frame = CGRectMake(5, 5, wScreen-10, image.size.height * ratio); //190
        cell.tagEditorImageView.imagePreviews.frame = CGRectMake(5, 5, wScreen-20, image.size.height * ratio);
        cell.commentview.frame = CGRectMake(5,image.size.height * ratio - 25,wScreen-20, 30);
        NSLog(@"Dingge Image Size: %f",image.size.height * ratio,nil);
        DingGeModelFrame *statusFrame = weakSelf.statusFramesDingGe[indexPath.row];
        statusFrame.imageHeight = image.size.height * ratio;
        cell.ratio = ratio;
        [cell setTags];
        NSInteger height = [statusFrame getHeight:model];
        
        if([[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue] != height){
            //                [weakSelf.statusFramesDingGe setObject:statusFrame atIndexedSubscript:indexPath.row];
            //                ((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]).imageHeight = image.size.height;
            //                [((DingGeModelFrame *)weakSelf.statusFramesDingGe[indexPath.row]) setModel:model];
            //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.cellHeightDic setObject:[NSString stringWithFormat:@"%ld",(long)height] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [weakSelf.tableView reloadData];
            //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
//    [cell.contentView addSubview:imageView];
    
    cell.message.text = model.content;
    [cell.contentView addSubview:cell.message];
    
    cell.userImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userbtn:)];
    
    [cell.userImg addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
    
    [cell.movieName addGestureRecognizer:movieGesture];
    
    
    [cell.screenBtn addTarget:self action:@selector(screenbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.screenBtn];
    
    
    [cell.answerBtn addTarget:self action:@selector(answerbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.answerBtn];
    
    UITapGestureRecognizer * detailGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailBtn:)];
    
    [cell.tagEditorImageView.imagePreviews addGestureRecognizer:detailGesture];
    
    
    if (model.viewCount == nil) {
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
    }
    [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
    [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.seeBtn];
    
    
    [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
    [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.zambiaBtn];
    
    
    
    
    cell.tagEditorImageView.viewC = self;
    
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
    //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
    

    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
    if(height > 0){
        return height;
    }else
        return 420;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    
    dingge.DingID  = model.ID;
    
    
    
    [self.navigationController pushViewController:dingge animated:YES];
    
}




-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}

-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
  
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
  
    [self.navigationController pushViewController:dingge animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    [self.navigationController pushViewController:dingge animated:YES];
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    taviewcontroller.model = model.user;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * moviecontroller = [[MovieTableViewController alloc]init];
    
    moviecontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    moviecontroller.ID = model.movie.ID;
    moviecontroller.name = model.movieName;
    
    
    
    [self.navigationController pushViewController:moviecontroller animated:YES];
    

    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dingge = [[DinggeSecondViewController alloc]init];
    
    dingge.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dingge.dingimage = model.image;
    dingge.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",DINGGE_API,model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    [self.navigationController pushViewController:dingge animated:YES];
}


- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
