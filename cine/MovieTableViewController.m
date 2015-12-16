//
//  MovieTableViewController.m
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieModel.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "ShuoXiImgTableViewCell.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "MyShuoXiTableViewCell.h"
#import "DinggeSecondViewController.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
#import "MovieViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "RecModel.h"
#import "RecMovieTableViewCell.h"
#import "ReviewModel.h"
#import "ReviewTableViewCell.h"
#define tablewH self.view.frame.size.height-230

@interface MovieTableViewController () <ChooseMovieViewDelegate>{

    MovieModel * movie;
    DingGeModel * dingge;
    NSMutableArray * ShuoXiArr;
    NSMutableArray * DingGeArr;
  

}

@property NSMutableArray *dataSource;

@property(nonatomic,strong)NSArray * statusFramesShuoXi;
@property(nonatomic,strong)NSArray * statusFramesDingGe;
@property(nonatomic, strong)NSArray *statusFramesComment;

@property(nonatomic,strong)NSArray * RecArr;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * CommentArr;


@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"说戏#%@#详情",self.ID);
    
    
    self.title = self.name;
    
    
    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"ID" : @"id"};
    }];
    
    
    ShuoXiArr = [NSMutableArray array];
    DingGeArr = [NSMutableArray array];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _starrings = [[NSMutableArray alloc]init];
    _genres = [[NSMutableArray alloc]init];
  
    
    
    
    [self loadmovie];
    [self Refresh];
    [self loadDingGe];
    [self loadRecData];
    [self loadRevData];
    [self loadCommentData];
  
}


-(void)loadmovie{
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://fl.limijiaoyin.com:1337/movie/",self.ID];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        movie = [MovieModel mj_objectWithKeyValues:responseObject];
        
        
        _starrings = movie.starring;
        _genres = movie.genre;
        
        //NSLog(@"---------%@",movie.cover);
        NSLog(@"----23%@",responseObject);
        
        
        [self.tableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
        
    }];
    
   
}
- (void)loadDingGe{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    //NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API];
    [manager GET:DINGGE_API parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 //model.votecount
                 //status.zambiaCount = model.votecount;
                 model.answerCount = @"50";
                 model.movieName =[NSString stringWithFormat:@"《%@》",model.movie.title];
                 model.nikeName = model.user.nickname;
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 //创建MianDingGeModelFrame模型
                 DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
                 statusFrame.model = model;
                 [statusFrame setModel:model];
                 [statusFrames addObject:statusFrame];
                 
             }
             
             
             self.statusFramesDingGe = statusFrames;
             
                          
             [self.tableView reloadData];
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
         }];
}

-(void)loadRecData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RecArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
         }];
    
}


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
         }];
    
}

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"评论内容-----%@",responseObject);
             self.CommentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject];
             //将里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (CommentModel * model in self.CommentArr) {
                 //  CommentModel * status = [[CommentModel alloc]init];
                 model.comment= model.content;
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.nickName = [NSString stringWithFormat:@"霍比特人"];
                 model.time = [NSString stringWithFormat:@"1小时前"];
                 model.zambiaCounts = @"600";
                 
                 //创建MLStatusFrame模型
                 CommentModelFrame *modelFrame = [[CommentModelFrame alloc]init];
                 modelFrame.model = model;
                 [modelFrame setModel:model];
                 [statusFrames addObject:modelFrame];
             }
             
             self.statusFramesComment = statusFrames;
             
             
             
             
             [self.tableView reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
         }];
    
    
}





- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //分组数
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
  //设置每个分组下tableview的行数
    
    if (section==0) {
        return 1;
    }
    else if(section==1){
        return 1;
    }
    else if(section==2){
        
         return self.statusFramesDingGe.count;
        
    }
    else if(section ==3){
        
         return [self.RecArr count];
    
    }
    else {
        
         return [self.RevArr count];
    
    
    }
//    else{
//    
//        return self.statusFramesComment.count;
//    
//    }
//

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        
        static NSString * CellIndentifier = @"CellTableIdentifier";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        UIView *movieView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,190)];
        movieView.backgroundColor = [UIColor colorWithRed:28.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
        
         [self.view addSubview:movieView];
        [movieView addSubview:cell.contentView];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, wScreen/4, 140)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:movie.cover] placeholderImage:nil];
        
        [imageView setImage:imageView.image];
        
        [cell.contentView addSubview:imageView];
        
        
        UILabel *dirnameLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 20, 50, 14)];
        dirnameLabel.text=@"导演:";
        dirnameLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:dirnameLabel];
        UILabel * director = [[UILabel alloc]initWithFrame:CGRectMake(200, 20, wScreen/3, 14)];
        director.backgroundColor = [UIColor clearColor];
        director.textColor = [UIColor whiteColor];
        director.text = movie.director;
        [cell.contentView addSubview:director];
        
        UILabel *yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 45, 50, 14)];
        yearLabel.text=@"年份:";
        yearLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:yearLabel];
        UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(200, 45, wScreen/3, 14)];
        year.backgroundColor = [UIColor clearColor];
        year.textColor = [UIColor whiteColor];
        year.text = movie.year;
        [cell.contentView addSubview:year];
         
        
        UILabel *initLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 72, 50, 14)];
        initLabel.text=@"地区:";
        initLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:initLabel];
        UILabel * initial = [[UILabel alloc]initWithFrame:CGRectMake(200, 72, wScreen/2, 14)];
        initial.backgroundColor = [UIColor clearColor];
        initial.textColor = [UIColor whiteColor];
        initial.text = movie.initialReleaseDate ;
        [cell.contentView addSubview:initial];
        
        UILabel *genreLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 98, 50, 14)];
        genreLabel.text=@"类型:";
        genreLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:genreLabel];
        UILabel * genre = [[UILabel alloc]initWithFrame:CGRectMake(200, 98, wScreen/2, 14)];
        genre.backgroundColor = [UIColor clearColor];
        NSString * genreString = [_genres componentsJoinedByString:@","];
        genre.textColor = [UIColor whiteColor];
        genre.text = genreString;
        [cell.contentView addSubview:genre];
        
        UILabel *ratingLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 130, 50, 14)];
        ratingLabel.text=@"评分:";
        ratingLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:ratingLabel];
        UILabel * rating = [[UILabel alloc]initWithFrame:CGRectMake(200, 130, wScreen/3, 14)];
        rating.backgroundColor = [UIColor clearColor];
        rating.textColor = [UIColor whiteColor];
        rating.text = movie.rating;
        [cell.contentView addSubview:rating];
        
        
                // Configure the cell...
                
         return cell;

        
    }
    else if (indexPath.section==1){
        
        
        static NSString * CellIndentifier = @"Cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }

  
        
                UIImage *image1 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
                [imageView1 setImage:image1];
                [cell.contentView addSubview:imageView1];
                UIImage *image2 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 30, 30)];
                [imageView2 setImage:image2];
                [cell.contentView addSubview:imageView2];
        
                UIImage *image3 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 30, 30)];
                [imageView3 setImage:image3];
                [cell.contentView addSubview:imageView3];
        
                UIImage *image4 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView4= [[UIImageView alloc]initWithFrame:CGRectMake(130, 10, 30, 30)];
                [imageView4 setImage:image4];
                [cell.contentView addSubview:imageView4];
        
                UIImage *image5 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(170, 10, 30, 30)];
                [imageView5 setImage:image5];
                [cell.contentView addSubview:imageView5];
        
                UIImage *image6 = [UIImage imageNamed:@"avatar@2x.png"];
                UIImageView * imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(210, 10, 30, 30)];
                [imageView6 setImage:image6];
                [cell.contentView addSubview:imageView6];
        
                UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 120, 28)];
                text.text = @"112匠人推荐";
                text.textColor = [UIColor whiteColor];
                text.textAlignment = NSTextAlignmentCenter;
                text.backgroundColor = [UIColor grayColor];
                [cell.contentView addSubview:text];
        
        
        
        
        
                UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(10,50, 70, 30)];
                text1.text = @"导演好";
                text1.textColor = [UIColor grayColor];
                text1.textAlignment = NSTextAlignmentCenter;
                text1.layer.borderColor = [[UIColor grayColor]CGColor];
                text1.layer.borderWidth = 1.0f;
                text1.layer.masksToBounds = YES;
                [cell.contentView addSubview:text1];
                UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 50,70, 30)];
                text2.text = @"视觉好";
                text2.textColor = [UIColor grayColor];
                text2.textAlignment = NSTextAlignmentCenter;
                text2.layer.borderColor = [[UIColor grayColor]CGColor];
                text2.layer.borderWidth = 1.0f;
                text2.layer.masksToBounds = YES;
                [cell.contentView addSubview:text2];
                UILabel * text3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 50,70, 30)];
                text3.text = @"摄影好";
                text3.textColor = [UIColor grayColor];
                text3.textAlignment = NSTextAlignmentCenter;
                text3.layer.borderColor = [[UIColor grayColor]CGColor];
                text3.layer.borderWidth = 1.0f;
                text3.layer.masksToBounds = YES;
                [cell.contentView addSubview:text3];
                
                UILabel * text4 = [[UILabel alloc]initWithFrame:CGRectMake(250, 50,70, 30)];
                text4.text = @"音乐好";
                text4.textColor = [UIColor grayColor];
                text4.textAlignment = NSTextAlignmentCenter;
                text4.layer.borderColor = [[UIColor grayColor]CGColor];
                text4.layer.borderWidth = 1.0f;
                text4.layer.masksToBounds = YES;
                [cell.contentView addSubview:text4];
                return cell;
    
        
    }
    else if(indexPath.section==2){
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        
        [cell.movieImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
        [imageView setImage:cell.movieImg.image];
        
        [cell.contentView addSubview:imageView];
        cell.message.text = model.content;
        [cell.contentView addSubview:cell.message];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];

        
        
        return cell;
    
    
    }

    else if(indexPath.section==3){
        
        NSString *ID = [NSString stringWithFormat:@"Rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        return cell;
        
    }
    else{
        
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        return cell;
        

    
    
    }
//    else{
//        
//        //创建cell
//        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
//        //设置高度
//        cell.modelFrame = self.statusFramesComment[indexPath.row];
//        
//        return cell;
//        
//
//    
//    }
//

  
    return nil;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
         return 190;
    }
    else if(indexPath.section==1) {
    
        return 100;
    
    }
    else if(indexPath.section==2){
    
        DingGeModelFrame * modelFrame = self.statusFramesDingGe[indexPath.row];
        return modelFrame.cellHeight;
    }else if(indexPath.section==3){
        
        
        return 300;
        
        
    }else{
    
        
        return 270;
        
    }
//    else{
//        
//        
//        CommentModelFrame *modelFrame = self.statusFramesComment[indexPath.row];
//        return modelFrame.cellHeight;
//          
//    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==2) {
        DinggeSecondViewController * DingViewController = [[DinggeSecondViewController alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        DingViewController.dingimage = model.image;
        
        DingViewController.DingID  = model.ID;
        
        [self.navigationController pushViewController:DingViewController animated:YES];
        

    }
    

}

-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
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



-(void)Refresh
{
    self.refreshHeader.isEffectedByNavigationController = NO;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableView];
    [refreshHeader addTarget:self refreshAction:@selector(endRefresh)];
    self.refreshHeader=refreshHeader;
    [refreshHeader autoRefreshWhenViewDidAppear];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(endRefresh)];
    self.refreshFooter=refreshFooter;
    
    
}
-(void)endRefresh
{
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
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
