//
//  CollectionViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()
@property UIScrollView *_scrollView;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示图片方法
    [self showPicWithCount:20];
   
}

- (void)showPicWithCount :(int) count{
    
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat picW = (viewW - 80) / 3;
    CGFloat picH = 150;
    //间隙距离
    CGFloat space = 20;
    
    int n = 20;
    
    int modle = n % 3;
    
    int column = n / 3;
    if (modle != 0 ) {
        column += 1;
    }
    
    
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    scrollview.frame = CGRectMake(0, 0, viewW, self.view.frame.size.height);
    [self.view addSubview:scrollview];
    scrollview.contentSize =CGSizeMake(0, (column + 1) * (space + picH) +space);

    for (int i = 0; i < column; i++) {
        if (i == column - 1) {
            for (int j = 0; j < modle; j++) {
                UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(space + (picW + space) * j, space + (picH + space) * i, picW, picH)];
                pic.image = [UIImage imageNamed:@"shuoxiImg.png"];
                
                [scrollview addSubview:pic];
            }
        }
        else{
            for (int j = 0; j < 3; j++) {
                UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(space + (picW + space) * j, space + (picH + space) * i, picW, picH)];
                pic.image = [UIImage imageNamed:@"shuoxiImg.png"];
                [scrollview addSubview:pic];
                
            }
            
        }
    }
    
    __scrollView = scrollview;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
