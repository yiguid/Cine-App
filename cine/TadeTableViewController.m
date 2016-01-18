//
//  TadeTableViewController.m
//  cine
//
//  Created by wang on 15/12/22.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "TadeTableViewController.h"
#import "HeadView.h"
#import "headViewModel.h"
#import "HMSegmentedControl.h"
#import "DingGeModel.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModelFrame.h"
#import "RecMovieTableViewCell.h"
#import "RecModel.h"
#import "RestAPI.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "DinggeSecondViewController.h"
#import "ReviewModel.h"
#import "ReviewTableViewCell.h"
#import "MovieTableViewController.h"
#import "RecommendSecondViewController.h"
#import "ReviewSecondViewController.h"
#import "MBProgressHUD.h"
#define tablewH self.view.frame.size.height-250
@interface TadeTableViewController (){
    
    NSMutableArray * DingGeArr;
    UIView * cellview;
    HeadView *headView;
    HMSegmentedControl *segmentedControl;
}

@property(nonatomic, strong)NSArray *statusFrames;
@property(nonatomic,strong)NSMutableArray *dataload;
@property(strong,nonatomic) NSMutableArray *DingArr;
@property(nonatomic,strong)NSArray *statusFramesDingGe;
@property(nonatomic, strong)NSMutableDictionary *cellHeightDic;
@property(nonatomic,strong)NSArray * RevArr;
@property(nonatomic,strong)NSArray * RecArr;
@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation TadeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"他的";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    
    self.cellHeightDic = [[NSMutableDictionary alloc] init];

    
    
    
    cellview = [[UIView alloc]initWithFrame:CGRectMake(0, 210, wScreen, 30)];
    
    

    [self settabController];
    [self loadRevData];
    [self loadDingGeData];
    [self loadRecData];
    [self.revtableview reloadData];
    [self setupHeader];
    [self setupFooter];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 定义tableview
- (void) settabController{
    self.rectableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen-50)];
    self.dinggetableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen-50)];
    self.revtableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, wScreen,hScreen-50)];
    self.rectableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dinggetableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.revtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.rectableview.dataSource = self;
    self.rectableview.delegate = self;
    self.dinggetableview.delegate = self;
    self.dinggetableview.dataSource = self;
    self.revtableview.dataSource = self;
    self.revtableview.delegate = self;
    
    [self.tableView addSubview:self.rectableview];
    [self.tableView addSubview:self.dinggetableview];
    [self.tableView addSubview:self.revtableview];
    
    
    
    headView = [[HeadView alloc]init];
    headViewModel *model = [[headViewModel alloc]init];
    model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
    model.userImg = _model.avatarURL;
    model.name = _model.nickname;
    model.catalog = _model.catalog;
    model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
    model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
    
    [headView setup:model];
    self.revtableview.tableHeaderView = headView;
    
    
    UIButton * guanzhu = [[UIButton alloc]initWithFrame:CGRectMake(wScreen-40,155, 40, 40)];
    [headView addSubview:guanzhu];
    
    [guanzhu addTarget:self action:@selector(guanzhuBtn)forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"看过", @"定格",@"鉴片"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(0,210, wScreen, 30);
    segmentedControl.selectionIndicatorHeight = 3.0f;
    segmentedControl.backgroundColor= [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
//    segmentedControl.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]};
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.revtableview addSubview:segmentedControl];
    
}



-(void)guanzhuBtn{
    
    
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.hud];
    // Set custom view mode
    self.hud.mode = MBProgressHUDModeCustomView;
    
    self.hud.labelText = @"已关注";//显示提示
    self.hud.customView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3x.png"]];

    
    
   
    
    UserModel *model =[[UserModel alloc]init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/follow/%@", BASE_API,userId,model.userId];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"关注成功,%@",responseObject);
              
              [self.hud show:YES];
              [self.hud hide:YES afterDelay:1];
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //             [self.hud setHidden:YES];
              NSLog(@"请求失败,%@",error);
          }];
    
    
}




- (void)loadDingGeData{
    NSLog(@"init array dingge",nil);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = _model.userId;
    param[@"sort"] = @"createdAt DESC";
    
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    //NSString *url = [NSString stringWithFormat:@"%@/%@",DINGGE_API];
    [manager GET:DINGGE_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             
             DingGeArr = [DingGeModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             //将dictArray里面的所有字典转成模型,放到新的数组里
             NSMutableArray *statusFrames = [NSMutableArray array];
             
             for (DingGeModel *model in DingGeArr) {
                 NSLog(@"DingGeArr------%@",model.content);
                 //创建模型
                 model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
                 model.seeCount = model.viewCount;
                 model.zambiaCount = model.voteCount;
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
             
             
             [self.dinggetableview reloadData];
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"请求失败,%@",error);
             
         }];
}
-(void)loadRecData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = _model.userId;
    param[@"sort"] = @"createdAt DESC";
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RecArr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.rectableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
}


-(void)loadRevData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"user"] = _model.userId;
    param[@"sort"] = @"createdAt DESC";
    NSString *token = [userDef stringForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REVIEW_API parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.RevArr = [ReviewModel mj_objectArrayWithKeyValuesArray:responseObject];
             [self.revtableview reloadData];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
         }];
    
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"index %ld ", (long)segmentedControl.selectedSegmentIndex);
    
    
    if(segmentedControl.selectedSegmentIndex == 0){
        
        
        
        
        headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = _model.avatarURL;
        model.name = _model.nickname;
        model.catalog = _model.catalog;
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        
        self.revtableview.tableHeaderView = headView;
        
        
        [self.revtableview addSubview:segmentedControl];
        
        
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:NO];
        [self.dinggetableview setHidden:YES];
        [self.rectableview setHidden:YES];
        [self loadRevData];
    }
    else if(segmentedControl.selectedSegmentIndex == 1){
        
        
        
        
        
        
        headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = _model.avatarURL;
        model.name = _model.nickname;
        model.catalog = _model.catalog;
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        
        self.dinggetableview.tableHeaderView = headView;
       
        [self.dinggetableview addSubview:segmentedControl];
       
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:YES];
        [self.dinggetableview setHidden:NO];
        [self.rectableview setHidden:YES];
        [self loadDingGeData];
    }else{
        
        
        
        
        headView = [[HeadView alloc]init];
        headViewModel *model = [[headViewModel alloc]init];
        model.backPicture = [NSString stringWithFormat:@"myBackImg.png"];
        model.userImg = _model.avatarURL;
        model.name = _model.nickname;
        model.catalog = _model.catalog;
        model.mark = [NSString stringWithFormat:@"著名编剧、导演、影视投资人"];
        model.addBtnImg = [NSString stringWithFormat:@"follow-mark.png"];
        [headView setup:model];
        self.rectableview.tableHeaderView = headView;
        
        
        
        [self.rectableview addSubview:segmentedControl];
       
        
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1;
        
        [self.revtableview.layer addAnimation:animation forKey:nil];
        [self.dinggetableview.layer addAnimation:animation forKey:nil];
        [self.rectableview.layer addAnimation:animation forKey:nil];
        
        
        
        [self.revtableview setHidden:YES];
        [self.dinggetableview setHidden:YES];
        [self.rectableview setHidden:NO];
        [self loadRecData];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    
    
        
        if (tableView == self.revtableview) {
            return self.RevArr.count;
        }else if (tableView == self.dinggetableview) {
            
             return self.statusFramesDingGe.count;
        }else{
            
           return self.RecArr.count;
        }
    
  }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.revtableview) {
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
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框
        
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
        
        if (self.RevArr.count==0) {
            
            UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
            [tableView setBackgroundView:backgroundView];
        }
        

        
        
        return cell;
    }else if(tableView == self.dinggetableview){
    
    
        
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.statusFramesDingGe[indexPath.row];
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        
        DingGeModel *model = DingGeArr[indexPath.row];
        
        NSString * string = model.image;
        
        
        __weak TadeTableViewController *weakSelf = self;
        
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
                    [weakSelf.dinggetableview reloadData];
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
                [weakSelf.dinggetableview reloadData];
                //                [weakSelf.dingge reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
        
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
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
        if (self.statusFramesDingGe.count==0) {
            
            UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
            [tableView setBackgroundView:backgroundView];
        }
        

        
        
        return cell;
    
    }else{
    
        
        NSString *ID = [NSString stringWithFormat:@"Rec"];
        RecMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[RecMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell setup:self.RecArr[indexPath.row]];
        
        
         RecModel *model = self.RecArr[indexPath.row];
        
        
        cell.userImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recuserbtn:)];
        
        [cell.userImg addGestureRecognizer:tapGesture];
        
        
        UITapGestureRecognizer * movieGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recmoviebtn:)];
        
        [cell.movieName addGestureRecognizer:movieGesture];
        
        
        
        if (model.thankCount == nil) {
            [cell.appBtn setTitle:[NSString stringWithFormat:@"0人 感谢"] forState:UIControlStateNormal];
        }
        [cell.appBtn setTitle:[NSString stringWithFormat:@"%@人 感谢",model.thankCount] forState:UIControlStateNormal];
        [cell.appBtn addTarget:self action:@selector(thankBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.appBtn];
        
        
        
//        [cell.screenBtn addTarget:self action:@selector(recscreenbtn:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cell.screenBtn];
        
        
        UIView *tempView = [[UIView alloc] init];
        [cell setBackgroundView:tempView];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.layer.borderWidth = 10;
        cell.layer.borderColor = [[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0] CGColor];//设置列表边框

        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        
        
        if (self.RecArr.count==0) {
            
            UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
            [tableView setBackgroundView:backgroundView];
        }
        

        
        
        return cell;

    
    }
               return nil;
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if (tableView==self.rectableview) {
       return 280+10;
    }else if (tableView==self.dinggetableview) {
        
        CGFloat height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] floatValue];
        if(height > 0){
            return height;
        }else
            return 400;
    }else{
        return 270+10;
        
    }

}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
   if(tableView==self.revtableview)
        
    {
        
        ReviewSecondViewController * rev = [[ReviewSecondViewController alloc]init];
        
        rev.hidesBottomBarWhenPushed = YES;
        
        ReviewModel * model = self.RevArr[indexPath.row];
        
        rev.revimage = model.image;
        
        rev.revID = model.reviewId;
        
        NSInteger see = [model.viewCount integerValue];
        see = see+1;
        model.viewCount = [NSString stringWithFormat:@"%ld",see];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *token = [userDef stringForKey:@"token"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.ID];
        
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
        [manager POST:url parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSLog(@"成功,%@",responseObject);
                  [self.revtableview reloadData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        
        
        
        [self.navigationController pushViewController:rev animated:YES];
        

        
    }else if (tableView==self.dinggetableview){
        
        
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
                  
                  NSLog(@"成功,%@",responseObject);
                  [self.dinggetableview reloadData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"请求失败,%@",error);
              }];
        

        
        
        
        [self.navigationController pushViewController:dingge animated:YES];

        
        
    }
//    else{
//        
//        RecommendSecondViewController * rec = [[RecommendSecondViewController alloc]init];
//        
//        rec.hidesBottomBarWhenPushed = YES;
//        
//        RecModel * model = self.RecArr[indexPath.row];
//        
//        rec.recimage = model.image;
//        
//        rec.recID = model.recId;
//        
//        
//        
//        [self.navigationController pushViewController:rec animated:YES];
//
//        
//        
//    }
    
}



-(void)thankBtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    RecMovieTableViewCell * cell = (RecMovieTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    
    
    NSInteger thank = [model.thankCount integerValue];
    thank = thank+1;
    model.thankCount = [NSString stringWithFormat:@"%ld",thank];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSString *userId = [userDef stringForKey:@"userID"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/thank/recommend/%@",BASE_API,userId,model.recId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"感谢成功,%@",responseObject);
              [self.tableView reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
}




-(void)zambiabtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dinggetableview indexPathForCell:cell];
    
    
    
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
              [self.dinggetableview reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}

-(void)zamrevbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    ReviewTableViewCell * cell = (ReviewTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.revtableview indexPathForCell:cell];
    
    
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    
    
    NSInteger zan = [model.voteCount integerValue];
    zan = zan+1;
    model.voteCount = [NSString stringWithFormat:@"%ld",(long)zan];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/votecount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"点赞成功,%@",responseObject);
              [self.revtableview reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"请求失败,%@",error);
          }];
    
}


-(void)screenbtn:(UIButton *)sender{
    
    UIButton * btn = (UIButton *)sender;
    
    MyDingGeTableViewCell * cell = (MyDingGeTableViewCell *)[[btn superview] superview];
    
    //获得点击了哪一行
    NSIndexPath * indexPath = [self.dinggetableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
              
              NSLog(@"成功,%@",responseObject);
              [self.dinggetableview reloadData];
              
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
    NSIndexPath * indexPath = [self.dinggetableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
              
              NSLog(@"成功,%@",responseObject);
              [self.dinggetableview reloadData];
              
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
    NSIndexPath * indexPath = [self.dinggetableview indexPathForCell:cell];
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
              
              NSLog(@"成功,%@",responseObject);
              [self.dinggetableview reloadData];
              
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
    NSIndexPath *indexPath = [self.dinggetableview indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
   taviewcontroller.model = model.user;    
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)moviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.dinggetableview indexPathForCell:cell];
    
    DingGeModel *model = DingGeArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}



- (void)detailBtn:(UITapGestureRecognizer *)sender{
    
    
    
    DinggeSecondViewController * dinggesecond = [[DinggeSecondViewController alloc]init];
    
    dinggesecond.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview.superview;
    NSIndexPath *indexPath = [self.dinggetableview indexPathForCell:cell];
    DingGeModel *model = DingGeArr[indexPath.row];
    
    dinggesecond.dingimage = model.image;
    dinggesecond.DingID  = model.ID;
    
    
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
              
              NSLog(@"成功,%@",responseObject);
              [self.dinggetableview reloadData];
              
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
    NSIndexPath * indexPath = [self.revtableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.revtableview reloadData];
              
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
    NSIndexPath * indexPath = [self.revtableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.revtableview reloadData];
              
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
    NSIndexPath * indexPath = [self.revtableview indexPathForCell:cell];
    
    ReviewSecondViewController * revsecond = [[ReviewSecondViewController alloc]init];
    
    revsecond.hidesBottomBarWhenPushed = YES;
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    revsecond.revimage = model.image;
    revsecond.revID  = model.reviewId;
    
    
    NSInteger see = [model.viewCount integerValue];
    see = see+1;
    model.viewCount = [NSString stringWithFormat:@"%ld",(long)see];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/viewCount",REVIEW_API,model.reviewId];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"成功,%@",responseObject);
              [self.revtableview reloadData];
              
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
    NSIndexPath *indexPath = [self.revtableview indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)movierevbtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview;
    NSIndexPath *indexPath = [self.revtableview indexPathForCell:cell];
    
    ReviewModel *model = self.RevArr[indexPath.row];
    
    movieviewcontroller.ID = model.movie.ID;
    
    [self.navigationController pushViewController:movieviewcontroller animated:YES];
    
    
}

-(void)recuserbtn:(UITapGestureRecognizer *)sender{
    
    
    
    TadeTableViewController * taviewcontroller = [[TadeTableViewController alloc]init];
    
    
    
    taviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UIImageView *imageView = (UIImageView *)sender.view;
    UITableViewCell *cell = (UITableViewCell *)imageView.superview.superview;
    NSIndexPath *indexPath = [self.rectableview indexPathForCell:cell];
    
    RecModel *model = self.RecArr[indexPath.row];
    
    taviewcontroller.model = model.user;
    
    
    
    [self.navigationController pushViewController:taviewcontroller animated:YES];
    
}

-(void)recmoviebtn:(UITapGestureRecognizer *)sender{
    
    
    MovieTableViewController * movieviewcontroller = [[MovieTableViewController alloc]init];
    
    movieviewcontroller.hidesBottomBarWhenPushed = YES;
    
    UILabel * label = (UILabel *)sender.view;;
    UITableViewCell *cell = (UITableViewCell *)label.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.rectableview indexPathForCell:cell];
    
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
//    NSIndexPath * indexPath = [self.rectableview indexPathForCell:cell];
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
//    NSString *url = [NSString stringWithFormat:@"%@%@/viewCount",REC_API,model.recId];
//    
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
//    [manager POST:url parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//              NSLog(@"成功,%@",responseObject);
//              [self.rectableview reloadData];
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
            
            
            [self loadDingGeData];
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
