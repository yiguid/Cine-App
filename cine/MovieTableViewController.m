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
#import "DinggeSecondViewController.h"
#import "ShuoXiModel.h"
#import "ShuoxiViewController.h"
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
#import "RecommendSecondViewController.h"
#import "ReviewSecondViewController.h"
#import "ShuoXiSecondViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "cine.pch"
#import "CineViewController.h"
#import "MyRecMovieTableViewController.h"
#import "MyLookTableViewController.h"
#import "ShuoxiTotalTableViewController.h"
#import "DinggeTotalTableViewController.h"
#import "TuijianTotalTableViewController.h"
#import "HaopingTotalTableViewController.h"
#import "TadeTableViewController.h"
#import "AddPersonViewController.h"
#define tablewH self.view.frame.size.height-230

@interface MovieTableViewController () <ChooseMovieViewDelegate>{

    MovieModel * movie;
    DingGeModel * dingge;
    NSMutableArray * ShuoXiArr;
    NSMutableArray * DingGeArr;
  

}

@property NSMutableArray *dataSource;

@property(nonatomic,strong)NSArray * ActivityArr;
@property(nonatomic,strong)NSArray * statusFramesDingGe;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
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
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"";
    self.navigationItem.backBarButtonItem = backIetm;
    
    [DingGeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"ID" : @"id"};
    }];
    
    
    ShuoXiArr = [NSMutableArray array];
    DingGeArr = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    
   
    
    _starrings = [[NSMutableArray alloc]init];
    _genres = [[NSMutableArray alloc]init];
  
    
    
    [self setupHeader];
    [self setupFooter];
    
    
    [self loadmovie];
    [self loadDingGe];
    [self loadRecData];
    [self loadRevData];
    [self loadCommentData];
    [self loadShuoXiData];
    
    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];
  
}


-(void)loadmovie{
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://fl.limijiaoyin.com:1337/movie/",self.ID];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        movie = [MovieModel mj_objectWithKeyValues:responseObject];
        
        
        _starrings = movie.starring;
        _genres = movie.genre;
        
        //NSLog(@"---------%@",movie.cover);
        NSLog(@"----23%@",responseObject);
        
        
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
       
        
    }];
    
   
}

- (void)loadShuoXiData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:ACTIVITY_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.ActivityArr = [ActivityModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
             NSLog(@"请求失败,%@",error);
         }];
}





- (void)loadDingGe{
    NSLog(@"init array dingge",nil);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    //NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API];
    [manager GET:DINGGE_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 //status.zambiaCount = model.votecount;
                 NSInteger comments = model.comments.count;
                 NSString * com = [NSString stringWithFormat:@"%ld",comments];
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

-(void)loadRecData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RecArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
    
}


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSDictionary *parameters = @{@"sort": @"createdAt DESC",@"limit":@"3"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.tableView reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];
    
}

- (void)loadCommentData{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *url = @"http://fl.limijiaoyin.com:1337/comment";
    NSDictionary *parameters = @{@"sort": @"createdAt DESC"};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:url parameters:parameters
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
    
//    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //分组数
    return 10;
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
    else if (section==2){
    
    
        return self.ActivityArr.count;
    }
    else if(section==3){
        
         return 1;
        
    }
    else if(section==4){
        
        return self.statusFramesDingGe.count;
        
    }
    else if(section==5){
        
        return 1;
        
    }
    
    else if(section ==6){
        
         return [self.RecArr count];
    
    }
    else if(section ==7){
        
        return 1;
        
    }

    else if(section ==8){
        
         return [self.RevArr count];
    
    
    }else{
    
        return 1;
    }
   

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        
        static NSString * CellIndentifier = @"CellTableIdentifier";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        UIView *movieView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,170)];
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
        ratingLabel.text=@"收藏:";
        ratingLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:ratingLabel];
        UILabel * rating = [[UILabel alloc]initWithFrame:CGRectMake(200, 130, wScreen/3, 14)];
        rating.backgroundColor = [UIColor clearColor];
        rating.textColor = [UIColor whiteColor];
        rating.text = @"(已有125人收藏)";
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
        

        
                UIButton * text = [[UIButton alloc]initWithFrame:CGRectMake(250,10,120, 30)];
                [text setTitle:@"112位匠人推荐" forState:UIControlStateNormal];
                text.titleLabel.font = TextFont;
                text.backgroundColor = [UIColor grayColor];
                text.layer.masksToBounds = YES;
                text.layer.cornerRadius = 4.0;
                [cell.contentView addSubview:text];
                [text addTarget:self action:@selector(textbtn:) forControlEvents:UIControlEventTouchUpInside];

        
        
        
        
        
        
        
        
        
                UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(10,60, 70, 20)];
                text1.text = @"导演好";
                text1.textColor = [UIColor grayColor];
                text1.textAlignment = NSTextAlignmentCenter;
                text1.layer.borderColor = [[UIColor grayColor]CGColor];
                text1.layer.borderWidth = 1.0f;
                text1.layer.masksToBounds = YES;
                text1.font = TextFont;
                [cell.contentView addSubview:text1];
                UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 60,70, 20)];
                text2.text = @"视觉好";
                text2.textColor = [UIColor grayColor];
                text2.textAlignment = NSTextAlignmentCenter;
                text2.layer.borderColor = [[UIColor grayColor]CGColor];
                text2.layer.borderWidth = 1.0f;
                text2.layer.masksToBounds = YES;
                text2.font = TextFont;
                [cell.contentView addSubview:text2];
                UILabel * text3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 60,70, 20)];
                text3.text = @"摄影好";
                text3.textColor = [UIColor grayColor];
                text3.textAlignment = NSTextAlignmentCenter;
                text3.layer.borderColor = [[UIColor grayColor]CGColor];
                text3.layer.borderWidth = 1.0f;
                text3.layer.masksToBounds = YES;
                 text3.font = TextFont;
                [cell.contentView addSubview:text3];
                
                UILabel * text4 = [[UILabel alloc]initWithFrame:CGRectMake(250, 60,70, 20)];
                text4.text = @"音乐好";
                text4.textColor = [UIColor grayColor];
                text4.textAlignment = NSTextAlignmentCenter;
                text4.layer.borderColor = [[UIColor grayColor]CGColor];
                text4.layer.borderWidth = 1.0f;
                text4.layer.masksToBounds = YES;
                 text4.font = TextFont;
                [cell.contentView addSubview:text4];
                return cell;
    
        
    }
    else if(indexPath.section==2){
        
        NSString *ID = [NSString stringWithFormat:@"ShuoXi"];
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        [cell setup:self.ActivityArr[indexPath.row]];
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shuoxiuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];

        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框

        
        
        
        return cell;

    
    
    }
    else if(indexPath.section==3){
        static NSString * CellIndentifier = @"quanbushuoxi";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.ActivityArr.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            [button setTitle:@"全部111条说戏" forState:UIControlStateNormal ];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(shuoxiBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
            UIView *tempView = [[UIView alloc] init];
            [cell setBackgroundView:tempView];
            [cell setBackgroundColor:[UIColor clearColor]];
        
             cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
         cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
        
    }

    else if (indexPath.section==4)
    {
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        
        __weak MovieTableViewController *weakSelf = self;
        
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
        
//        [cell.contentView addSubview:imageView];
        cell.message.text = model.content;
        [cell.contentView addSubview:cell.message];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zambiabtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
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
        
         cell.tagEditorImageView.viewC = self;
        
        
        if (model.viewCount == nil) {
            [cell.seeBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seebtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];

        
        
        
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        
        
        return cell;
    
    
    }
    else if(indexPath.section==5){
        
        static NSString * CellIndentifier = @"quanbutuijian";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.statusFramesDingGe.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            [button setTitle:@"全部111条定格" forState:UIControlStateNormal ];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(dinggeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
             cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
          
            
        }
        
        return cell;
        
        
    }


    else if(indexPath.section==6){
        
        NSString *ID = [NSString stringWithFormat:@"Rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recmoviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
//        [cell.screenBtn addTarget:self action:@selector(recscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cell.screenBtn];
        
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        

        
        return cell;
        
    }
    else if(indexPath.section==7){
        static NSString * CellIndentifier = @"quanbutuijian";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.RecArr.count>=3) {
            
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
            [button setTitle:@"全部111条推荐" forState:UIControlStateNormal ];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
            [button addTarget:self action:@selector(tuijianBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            button.layer.cornerRadius = 5.0f;
            
            button.layer.masksToBounds = YES;
            
            button.layer.borderWidth = 0.5f;
            
            button.layer.borderColor = [[UIColor grayColor]CGColor];
            
             cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
        }
        
        return cell;
        
        
    }

    else if(indexPath.section==8){
        
        NSString *ID = [NSString stringWithFormat:@"REVIEW"];
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RevArr[indexPath.row]];
        
        ReviewModel * model = self.RevArr[indexPath.row];
        
        
        [cell.zambiaBtn setTitle:[NSString stringWithFormat:@"%@",model.voteCount] forState:UIControlStateNormal];
        [cell.zambiaBtn addTarget:self action:@selector(zamrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.zambiaBtn];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userrevbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
//        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moviebtn:)];
//        
//        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        [cell.screenBtn addTarget:self action:@selector(screenrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.screenBtn];
        
        
        [cell.answerBtn addTarget:self action:@selector(answerrevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.answerBtn];
        
        
        [cell.seeBtn setTitle:[NSString stringWithFormat:@"%@",model.viewCount] forState:UIControlStateNormal];
        [cell.seeBtn addTarget:self action:@selector(seerevbtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.seeBtn];
        
      
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        //        cell.separatorColor = [UIColor redColor];//设置行间隔边框
        

        return cell;
        
    
    }else{
        static NSString * CellIndentifier = @"quanbuhaoping";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
            
        }
        
        
        if (self.RevArr.count>=3) {
            
            
            
                             UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                             button.frame = CGRectMake(wScreen/3, 10, wScreen/3, 30);
                             [button setTitle:@"全部111条好评" forState:UIControlStateNormal ];
                             [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                             button.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
                             [button addTarget:self action:@selector(haopingBtn:) forControlEvents:UIControlEventTouchUpInside];
            
                             [cell.contentView addSubview:button];
                             button.layer.cornerRadius = 5.0f;
            
                             button.layer.masksToBounds = YES;
            
                             button.layer.borderWidth = 0.5f;
                             
                             button.layer.borderColor = [[UIColor grayColor]CGColor];
            
                             cell .contentView .backgroundColor = [ UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
            
            
                         }

        return cell;
    
    
    }

  
    return nil;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
         return 170;
    }
    else if(indexPath.section==1) {
    
        return 100;
    
    }
    else if(indexPath.section==2){
        
        return 330;
    
    }
    else if(indexPath.section==3){
        
        return 50;
        
    }

    else if (indexPath.section==4)
    {
    
        CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        if(height > 0){
            return height;
        }else
            return 420;
    }
    else if(indexPath.section==5){
        
        return 50;
        
    }

    else if(indexPath.section==6){
        
        
        return 300;
        
        
    }
    else if(indexPath.section==7){
        
        return 50;
        
    }

    else if (indexPath.section==8){
    
        
        return 290;
        
    }else{
    
        return 50;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==2) {
        
        ShuoXiSecondViewController * shuoxi = [[ShuoXiSecondViewController alloc]init];
        shuoxi.hidesBottomBarWhenPushed = YES;
        ActivityModel *model = self.ActivityArr[indexPath.row];
        shuoxi.movie = model.movie;
        shuoxi.activityId = model.activityId;
        shuoxi.activityimage = model.image;
        
        [self.navigationController pushViewController:shuoxi animated:YES];
        
    
    }
    
    else if (indexPath.section==4)
    {
        DinggeSecondViewController * DingViewController = [[DinggeSecondViewController alloc]init];
        DingViewController.hidesBottomBarWhenPushed = YES;
        DingGeModel *model = DingGeArr[indexPath.row];
        
        DingViewController.dingimage = model.image;
        
        DingViewController.DingID  = model.ID;
        
        [self.navigationController pushViewController:DingViewController animated:YES];

    }
//    else if (indexPath.section==6){
//    
//        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//        rec.hidesBottomBarWhenPushed = YES;
//        RecModel * model = self.RecArr[indexPath.row];
//        
//        rec.recimage = model.image;
//        
//        rec.recID = model.recId;
//
//        
//        [self.navigationController pushViewController:rec animated:YES];
//    
//    }
    else if (indexPath.section==8){
        
        ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
        rev.hidesBottomBarWhenPushed = YES;
        ReviewModel * model = self.RevArr[indexPath.row];
        
        rev.revimage = model.image;
        
        rev.revID = model.reviewId;
        
        [self.navigationController pushViewController:rev animated:YES];
    
    
    }
    

}


/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==2) {
        return 30;
    }else if(section == 4){
        
        return 30;
        
    }
    else if(section == 6){
        
        return 30;
        
    }
    else if(section == 8){
        
        return 30;
        
    }
    else{
        
        
        return 0;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        
        UIView * view = [[UIView alloc]init];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = @"电影说戏";
        label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
        [view addSubview:label];
    
        
        return view;
    }
    else if(section == 4)
    {
        UIView * view = [[UIView alloc]init];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = @"电影定格";
        label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
        [view addSubview:label];

        
        return view;
        
        
    }else if(section == 6){
        
        UIView * view = [[UIView alloc]init];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = @"电影推荐";
        label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
        [view addSubview:label];

        
        return view;
    }else if(section == 8){
        
        UIView * view = [[UIView alloc]init];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        label.text = @"电影好评";
        label.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1.0];
        [view addSubview:label];

       
        
        return view;
    }
    
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        //为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
        
    }
    

}


-(void)textbtn:(id)sender{
    
    AddPersonViewController * person = [[AddPersonViewController alloc]init];
    
    person.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:person animated:YES];
    
}








-(void)shuoxiBtn:(id)sender{
    ShuoxiTotalTableViewController * shuoxi = [[ShuoxiTotalTableViewController alloc]init];
    shuoxi.hidesBottomBarWhenPushed = YES;
    
    
    shuoxi.movieID = self.ID;

    
    
    
    
    [self.navigationController pushViewController:shuoxi animated:YES];
}
-(void)dinggeBtn:(id)sender{
    
    
    DinggeTotalTableViewController * ding = [[DinggeTotalTableViewController alloc]init];
    ding.hidesBottomBarWhenPushed = YES;
    
    ding.movieID = self.ID;
    
    
    
    [self.navigationController pushViewController:ding animated:YES];
    


}
-(void)tuijianBtn:(id)sender{

    TuijianTotalTableViewController * rec = [[TuijianTotalTableViewController alloc]init];
    rec.hidesBottomBarWhenPushed = YES;
    
    
    rec.movieID = self.ID;
    
    [self.navigationController pushViewController:rec animated:YES];
    
}
-(void)haopingBtn:(id)sender{
 
    HaopingTotalTableViewController * look = [[HaopingTotalTableViewController alloc]init];
    look.hidesBottomBarWhenPushed = YES;
    
    
    look.movieID = self.ID;

    
    [self.navigationController pushViewController:look animated:YES];
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
-(void)zamrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/votecount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
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
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
   
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}

-(void)seebtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
  
    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}


-(void)answerbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    

    [self.navigationController pushViewController:dinggesecond animated:YES];
    
    
}



-(void)userbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    

    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/post/",model.ID];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    [self.navigationController pushViewController:dinggesecond animated:YES];
}


-(void)screenrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}

-(void)seerevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
   ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}


-(void)answerrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
   ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/review/",model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
    
    [self.navigationController pushViewController:revsecond animated:YES];
    
    
}



-(void)userrevbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)shuoxiuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ActivityModel *model = self.ActivityArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}





-(void)movierevbtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}

-(void)recuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    taviewcontroller.userimage = model.user.avatarURL ;
    taviewcontroller.nickname = model.user.nickname;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)recmoviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
}

//-(void)recscreenbtn:(UIButton *)sender{
//    
//    UIButton * btn = (UIButton *)sender;
//    
//    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
//    
//    //获得点击了哪一行
//    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//    
//    
//    
//    RecModel *model = self.RecArr[indexPath.row];
//    
//    
//    RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//    
//    rec.hidesBottomBarWhenPushed = YES;
//    
//    
//    
//    rec.recimage = model.image;
//    rec.recID  = model.recId;
//    
//    
//    NSInteger see = [model.viewCount integerValue];
//    see = see+1;
//    model.viewCount = [NSString stringWithFormat:@"%ld",see];
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    NSString *token = [userDef stringForKey:@"token"];
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",@"http://fl.limijiaoyin.com:1337/recommend/",model.recId];
//    
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    [manager POST:url parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//              NSLog(@"成功,%@",responseObject);
//              [self.tableView reloadData];
//              
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              
//              NSLog(@"请求失败,%@",error);
//          }];
//    
//    
//    
//    
//    
//    [self.navigationController pushViewController:rec animated:YES];
//    
//    
//}
//




- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadShuoXiData];
            [self loadDingGe];
            [self loadRecData];
            [self loadRevData];
            
            
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

- (void)viewWillDisappear:(BOOL)animated {
    [self setHidesBottomBarWhenPushed:NO];
    [super viewDidDisappear:animated];
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
