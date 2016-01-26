//
//  AboutCineViewController.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AboutCineViewController.h"

@interface AboutCineViewController (){

    UIWebView * webView;
}

@end

@implementation AboutCineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于影迷圈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewW = self.view.frame.size.width;
    CGFloat btnW = 80;

    
    UIButton *titBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 30, btnW, btnW)];
    titBtn.backgroundColor = [UIColor colorWithRed:250.0/255 green:205.0/255 blue:0 alpha:1.0];
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(viewW/2-30, 40, btnW-20, btnW-20)];
    imageview.image = [UIImage imageNamed:@"icon-180.png"];
    [titBtn bringSubviewToFront:imageview];
    titBtn.layer.masksToBounds = YES;
    titBtn.layer.cornerRadius = 8.0;
    
    titBtn.enabled = NO;
    [self.view addSubview:titBtn];
    [self.view addSubview:imageview];
    
    UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(viewW / 2 - 40, 40 + btnW, btnW, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    [title setText:@"影迷圈"];
    [self.view addSubview:title];
    
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 90 + btnW, viewW - 20, 300)];
    textView.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = @"cline生活网提供全国电影票订购，最新上映电影影院排片查询，优惠打折电影票、话剧，展览，演唱会等演出门票购买.羽毛球等运动场馆预定.集城市生活、消费、互动为...                                                cline生活网提供全国电影票订购，最新上映电影影院排片查询，优惠打折电影票cline生活网提供全国电影票订购，最新上映电影影院排片查询，优惠打折电影票、话剧，展览，演唱会等演出门票购买.羽毛球等运动场馆预定.                                                cline生活网提供全国电影票订购                              最新上映电影影院排片查询，优惠打折电影票、话剧，展览，演唱会等演出门票购买.羽毛球等运动场馆预定.集城市生活、消费、互动为... ";
    textView.textAlignment = NSTextAlignmentLeft; //水平居中
    textView.editable = NO;
    [self.view addSubview:textView];
    
    UIButton * negotiate = [[UIButton alloc]initWithFrame:CGRectMake(20,500, self.view.frame.size.width - 40, 30)];
    negotiate.backgroundColor = [UIColor grayColor];
    [negotiate setTitle:@"影迷圈软件许可及服务协议" forState:UIControlStateNormal];
    [negotiate addTarget:self action:@selector(negotiaate) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:negotiate];
    
    

    
}

-(void)negotiaate{
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, wScreen, hScreen-64)];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"服务协议.rtf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

- (void)addObserverForWebViewContentSize{
    
    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    
}

- (void)removeObserverForWebViewContentSize{
    
    [webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    
    //在这里边添加你的代码
    
    UIImageView * view = [[UIImageView alloc ]initWithFrame:CGRectMake(20,100, 20, 20)];
    view.backgroundColor = [UIColor blueColor];
    [webView addSubview:view];
    
    
    
    [self layoutCell];
    
}

//设置footerView的合理位置

- (void)layoutCell{
    
    //取消监听，因为这里会调整contentSize，避免无限递归
    
    [self removeObserverForWebViewContentSize];
    
    UIView *viewss = [self.view viewWithTag:99999];
    
    CGSize contentSize = webView.scrollView.contentSize;
    
    UIView *vi = [[UIView alloc]init];
    
//    vi.backgroundColor = BGCOLOR;
    
    vi.userInteractionEnabled = YES;
    
    vi.tag = 99999;
    
    vi.frame = CGRectMake(0, contentSize.height, wScreen, 150);
    
    [webView.scrollView addSubview:vi];
    
    webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + 150);
    
    //重新监听
    
    [self addObserverForWebViewContentSize];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    self.tabBarController.tabBar.hidden = YES;
    
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
