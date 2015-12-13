//
//  MyDropdown.h
//  cine
//
//  Created by Guyi on 15/12/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDropdown : UIView <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UILabel *indexLabel;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UILabel *indexLabel;

@end
