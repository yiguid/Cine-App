//
//  EditPhotoViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "YXLTagEditorImageView.h"

@interface EditPhotoViewController ()<UIGestureRecognizerDelegate>

{
   YXLTagEditorImageView *tagEditorImageView;
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
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;

}
@end
