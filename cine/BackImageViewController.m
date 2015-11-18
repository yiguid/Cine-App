//
//  BackImageViewController.m
//  cine
//
//  Created by Deluan on 15/11/18.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "BackImageViewController.h"
#import "YXLTagEditorImageView.h"

@interface BackImageViewController ()

{
    
    YXLTagEditorImageView *tagEditorImageView;
    UIImageView *_imageView ;
}

@end

@implementation BackImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 隐藏标签栏
    self.tabBarController.tabBar.translucent = YES ;
    self.tabBarController.tabBar.hidden = YES ;
    [self _initView] ;
    

    
}

- (void)_initView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wScreen, 300) ] ;
    view.backgroundColor = [UIColor purpleColor] ;
    [self.view addSubview:view] ;
//    tagEditorImageView =[[YXLTagEditorImageView alloc]initWithImage:self.image];
    tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:self.image imageEvent:ImageHaveNoEvent] ;
    tagEditorImageView.viewC=self;
    tagEditorImageView.userInteractionEnabled=YES;
    [view addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    for (NSDictionary *dic in self.pointAndTextsArray) {
        float pointX = [dic[@"x"]floatValue] ;
        float pointY = [dic[@"y"]floatValue] ;
        NSString *textString = dic[@"text"] ;
        NSString *directionString = dic[@"direction"] ;
        if([directionString isEqualToString:@"left"])
        {
            [tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:YES];
        }
        else
        {
            [tagEditorImageView addTagViewText:textString Location:CGPointMake(pointX,pointY) isPositiveAndNegative:NO];
        }
        
    }

}



@end
