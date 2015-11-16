//
//  YXLTagVC.m
//  YXLImageLabelDemo
//
//  Created by 叶星龙 on 15/10/30.
//  Copyright © 2015年 叶星龙. All rights reserved.
//

#import "YXLTagVC.h"
#import "YXLTagEditorImageView.h"

@interface YXLTagVC ()<UIGestureRecognizerDelegate>
{
    YXLTagEditorImageView *tagEditorImageView;
}



@end

@implementation YXLTagVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    tagEditorImageView =[[YXLTagEditorImageView alloc]initWithImage:[UIImage imageNamed:@"2011102267331457.jpg"]];
    tagEditorImageView.viewC=self;
    tagEditorImageView.userInteractionEnabled=YES;
    [self.view addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;
    
}


@end
