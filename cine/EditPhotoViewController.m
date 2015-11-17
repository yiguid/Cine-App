//
//  EditPhotoViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "YXLTagEditorImageView.h"
#import "TextViewController.h"

@interface EditPhotoViewController ()<UIGestureRecognizerDelegate>

{
    YXLTagEditorImageView *tagEditorImageView;
    TextViewController *_textView ;
}

@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建控件
    [self _initView] ;
}

- (void)_initView
{
    tagEditorImageView =[[YXLTagEditorImageView alloc]initWithImage:self.image];
    tagEditorImageView.viewC=self;
    tagEditorImageView.userInteractionEnabled=YES;
    [self.view addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;

}

///**
// *  确定并pop    返回这个图片所有的标签地址内容，是否翻转样式的数组   坐标为这个图片的真实坐标
// */
-(void)navItemClick{
    
    NSMutableArray *array =[tagEditorImageView popTagModel];
//    if (array.count==0) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    NSMutableArray *array1 =[NSMutableArray array];
    for(NSDictionary *dic in array){
        BOOL is =[dic[@"positiveAndNegative"] boolValue];
        NSString *positiveAndNegative ;
        if (is) {
            positiveAndNegative=@"反";
        }else{
            positiveAndNegative=@"正";
        }
        NSString *string =[NSString stringWithFormat:@"方向%@坐标%@文本%@",positiveAndNegative,dic[@"point"],dic[@"text"]];
        [array1 addObject:string];
    }
    NSString *string =[array1 componentsJoinedByString:@"\n"];
    
    
    // 创建push界面
    _textView = [[TextViewController alloc]init] ;
    [self.navigationController pushViewController:_textView animated:YES] ;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    _textView.image = [self imageFromView:tagEditorImageView atFrame:CGRectMake(0, 0, tagEditorImageView.width, tagEditorImageView.height)] ;

}

- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

@end
