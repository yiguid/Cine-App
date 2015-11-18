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
//    tagEditorImageView =[[YXLTagEditorImageView alloc]initWithImage:self.image];
    tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:self.image imageEvent:ImageHaveEvent] ;
    tagEditorImageView.viewC=self;
    tagEditorImageView.userInteractionEnabled=YES;
    [self.view addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [tagEditorImageView addTagViewText:@"哈哈哈哈" Location:CGPointMake(448.309179,296.296296) isPositiveAndNegative:YES];
    [tagEditorImageView addTagViewText:@"哈哈lalallallal" Location:CGPointMake(430.917874, 295.652174) isPositiveAndNegative:NO];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;

}

///**
// *  确定并pop    返回这个图片所有的标签地址内容，是否翻转样式的数组   坐标为这个图片的真实坐标
// */
-(void)navItemClick{
    
    NSMutableArray *array =[tagEditorImageView popTagModel];
    
    // 数据的处理
#warning wicuo

//    NSMutableArray *array1 =[NSMutableArray array];
//    for(NSDictionary *dic in array){
//        BOOL is =[dic[@"positiveAndNegative"] boolValue];
//        NSString *positiveAndNegative ;
//        if (is) {
//            positiveAndNegative=@"反";
//        }else{
//            positiveAndNegative=@"正";
//        }
//        NSString *string =[NSString stringWithFormat:@"方向%@坐标%@文本%@",positiveAndNegative,dic[@"point"],dic[@"text"]];
//        [array1 addObject:string];
//    }
    
    // 创建push界面
    _textView = [[TextViewController alloc]init] ;
    _textView.pointAndTextsArray = array ;
    [self.navigationController pushViewController:_textView animated:YES] ;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    // 截图
    _textView.screenshot = [self imageFromView:tagEditorImageView atFrame:CGRectMake(0, 0, tagEditorImageView.width, tagEditorImageView.height)] ;
    // 正常图片
    _textView.image = self.image ;

}


// 调用系统的截图
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
