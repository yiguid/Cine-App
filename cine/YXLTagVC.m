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

-(void)navItemClick{
    
    NSMutableArray *array =[tagEditorImageView popTagModel];
    if (array.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
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
    _popBlock(string);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
