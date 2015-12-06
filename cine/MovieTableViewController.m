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
#import "ShuoXiImgModel.h"
#import "MyDingGeTableViewCell.h"
#import "DingGeModel.h"
#import "DingGeModelFrame.h"
#import "ShuoXiCell.h"
#import "ShuoXiModel.h"
#import "ShuoXiModelFrame.h"
#import "MovieViewController.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#define tablewH self.view.frame.size.height-230

@interface MovieTableViewController () <ChooseMovieViewDelegate>{

 MovieModel * movie;

}
@property(nonatomic, strong)NSArray *DingGe;
@property(nonatomic, strong)NSArray *ShuoXi;
@property(nonatomic, strong)NSArray *Comment;
@property NSMutableArray *dataSource;


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
    
    
   
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    starrings = [[NSMutableArray alloc]init];
    genres = [[NSMutableArray alloc]init];
    self.DingGeArr = [[NSMutableArray alloc]init];
    
    
    
    
    //获取服务器数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",@"http://fl.limijiaoyin.com:1337/movie/",self.ID];
    NSString *DingGeurl = @"http://fl.limijiaoyin.com:1337/post";
    NSString *ShuoXiurl = @"http://fl.limijiaoyin.com:1337/story";
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        movie = [MovieModel mj_objectWithKeyValues:responseObject];
        
        
        starrings = movie.starring;
        genres = movie.genre;
        
        //NSLog(@"---------%@",movie.cover);
        NSLog(@"----23%@",responseObject);
        
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    

    [manager GET:DingGeurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        //NSLog(@"11111111====%@",responseObject);
        self.DingGeArr = responseObject;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    [manager GET:ShuoXiurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        //NSLog(@"2222222===%@",responseObject);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
  
}







- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}

#pragma 定义tableview
//- (void) settabController{
//    mytableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 220, wScreen,tablewH)];
//    
//    mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    mytableView.dataSource = self;
//
//    mytableView.delegate = self;
//    
//    [self.view addSubview:mytableView];
//
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)DingGe{
    if (_DingGe == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *DingGe = [NSMutableArray array];
            //创建MLStatus模型
            DingGeModel *status = [[DingGeModel alloc]init];
            status.message = [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
            status.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
            status.nikeName = [NSString stringWithFormat:@"霍比特人"];
            status.movieImg = [NSString stringWithFormat:@"shuoxiImg.png"];
        
            status.time = @"1小时前";
            status.seeCount = @"600";
            status.zambiaCount = @"600";
            status.answerCount = @"50";
        
            //创建MLStatusFrame模型
            DingGeModelFrame *statusFrame = [[DingGeModelFrame alloc]init];
            statusFrame.model = status;
            [statusFrame setModel:status];
            [DingGe addObject:statusFrame];
        
        _DingGe = DingGe;
    }
    return _DingGe;
}
-(NSArray *)Comment{
    if (_Comment == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *Comment = [NSMutableArray array];
    
        
        
        //创建MLStatus模型
        CommentModel *model = [[CommentModel alloc]init];
        model.comment= [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        model.userImg = [NSString stringWithFormat:@"avatar@2x.png"];
        model.nickName = [NSString stringWithFormat:@"吉姆"];
        model.time = [NSString stringWithFormat:@"1小时前"];
        model.zambiaCounts = @"600";
        
        
        
        
        //创建MLStatusFrame模型
        CommentModelFrame *modelFrame = [[CommentModelFrame alloc]init];
        modelFrame.model = model;
        [modelFrame setModel:model];
        [Comment addObject:modelFrame];
        
        
        
        
        
        
        _Comment = Comment;
    }
    return _Comment;
}
-(NSArray *)ShuoXi{
    if (_ShuoXi == nil) {
        //将dictArray里面的所有字典转成模型,放到新的数组里
        NSMutableArray *ShuoXi = [NSMutableArray array];

        
        //创建ShuoXiModel模型
        ShuoXiModel *model = [[ShuoXiModel alloc]init];
        model.picture = [NSString stringWithFormat:@"shuoxiImg.png"];
        model.text= [NSString stringWithFormat:@"上映日期: 2015年5月6日 (中国内地) 好哈哈哈哈好吼吼吼吼吼吼吼吼吼吼吼吼吼吼吼"];
        model.icon = [NSString stringWithFormat:@"avatar@2x.png"];
        model.name = [NSString stringWithFormat:@"吉姆"];
        model.time = [NSString stringWithFormat:@"1小时前"];
     
        
        //创建MLStatusFrame模型
        ShuoXiModelFrame * mlFrame = [[ShuoXiModelFrame alloc]init];
        
        mlFrame.model = model;
        [mlFrame setModel:model];
        [ShuoXi addObject:mlFrame];
        
        
        _ShuoXi = ShuoXi;
    }
    return _ShuoXi;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //分组数
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
  //设置每个分组下tableview的行数
    
    if (section==1) {
        return 1;
    }else if(section==2){
        
    
    return self.DingGe.count;
        
    }else if (section==3){
    
    return self.Comment.count;
    
    }else{
    
    return self.ShuoXi.count;
        
    }

}
//@"avatar@2x.png"
//可以改变标题内容
//子控件之间的间距
CGFloat padding = 10;
//头像
//CGFloat iconX = padding;
//CGFloat iconY = padding;
//CGFloat iconW = 30;
//CGFloat iconH = 30;
//_iconF= CGRectMake(iconX, iconY, iconW, iconH);
 //[UIColor colorWithPatternImage:[UIImage imageNamed:@"22.jpg"]];

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==1) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width,60)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        
        UIImage *image1 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, -30, 30, 30)];
        [imageView1 setImage:image1];
        [sectionView addSubview:imageView1];
        UIImage *image2 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(50, -30, 30, 30)];
        [imageView2 setImage:image2];
        [sectionView addSubview:imageView2];
        
        UIImage *image3 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(90, -30, 30, 30)];
        [imageView3 setImage:image3];
        [sectionView addSubview:imageView3];
        
        UIImage *image4 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView4= [[UIImageView alloc]initWithFrame:CGRectMake(130, -30, 30, 30)];
        [imageView4 setImage:image4];
        [sectionView addSubview:imageView4];
        
        UIImage *image5 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(170, -30, 30, 30)];
        [imageView5 setImage:image5];
        [sectionView addSubview:imageView5];
        
        UIImage *image6 = [UIImage imageNamed:@"avatar@2x.png"];
        UIImageView * imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(210, -30, 30, 30)];
        [imageView6 setImage:image6];
        [sectionView addSubview:imageView6];
        
        UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake(250, -30, 120, 28)];
        text.text = @"112匠人推荐";
        text.textColor = [UIColor whiteColor];
        text.textAlignment = NSTextAlignmentCenter;
        text.backgroundColor = [UIColor grayColor];
        [sectionView addSubview:text];

        
       
        
        
        UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 30)];
        text1.text = @"导演好";
        text1.textColor = [UIColor grayColor];
        text1.textAlignment = NSTextAlignmentCenter;
        text1.layer.borderColor = [[UIColor grayColor]CGColor];
        text1.layer.borderWidth = 1.0f;
        text1.layer.masksToBounds = YES;
        [sectionView addSubview:text1];
        UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 10,70, 30)];
        text2.text = @"视觉好";
        text2.textColor = [UIColor grayColor];
        text2.textAlignment = NSTextAlignmentCenter;
        text2.layer.borderColor = [[UIColor grayColor]CGColor];
        text2.layer.borderWidth = 1.0f;
        text2.layer.masksToBounds = YES;
        [sectionView addSubview:text2];
        UILabel * text3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 10,70, 30)];
        text3.text = @"摄影好";
        text3.textColor = [UIColor grayColor];
        text3.textAlignment = NSTextAlignmentCenter;
        text3.layer.borderColor = [[UIColor grayColor]CGColor];
        text3.layer.borderWidth = 1.0f;
        text3.layer.masksToBounds = YES;
        [sectionView addSubview:text3];
        
        UILabel * text4 = [[UILabel alloc]initWithFrame:CGRectMake(250, 10,70, 30)];
        text4.text = @"音乐好";
        text4.textColor = [UIColor grayColor];
        text4.textAlignment = NSTextAlignmentCenter;
        text4.layer.borderColor = [[UIColor grayColor]CGColor];
        text4.layer.borderWidth = 1.0f;
        text4.layer.masksToBounds = YES;
        [sectionView addSubview:text4];
        return sectionView;
        
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString * CellIndentifier = @"CellTableIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
        
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
   
     }
    if (indexPath.section==0) {
        
        
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
        NSString * genreString = [genres componentsJoinedByString:@","];
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

        
    }else if(indexPath.section==1){
        
        //创建cell
        MyDingGeTableViewCell *cell = [MyDingGeTableViewCell cellWithTableView:tableView];
        //设置cell
        cell.modelFrame = self.DingGe[indexPath.row];
        
    
        
        
        return  cell;
        
        
    
    }else if(indexPath.section==2){
        
        
        
        //创建cell
        CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:mytableView];
        //设置高度
        cell.modelFrame = self.Comment[indexPath.row];
        
        return  cell;
    
    
    
    }   else{
        
        //创建cell
        ShuoXiCell *cell = [ShuoXiCell cellWithTableView:mytableView];
        
        cell.modelFrame = self.ShuoXi[indexPath.row];
        
        return  cell;
        
        
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 190;
    }
    else if(indexPath.section == 1){
        DingGeModelFrame *modelFrame = self.DingGe[indexPath.row];
        return modelFrame.cellHeight;
        
        
    }
    else if(indexPath.section == 2){
        
        CommentModelFrame *modelFrame = self.Comment[indexPath.row];
        return modelFrame.cellHeight;
        
    }
    else{
        
        ShuoXiModelFrame *modelFrame = self.ShuoXi[indexPath.row];
        return modelFrame.cellHeight;

        
    }
    
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
