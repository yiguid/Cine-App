//
//  UITabBar+badge.h
//  cine
//
//  Created by Guyi on 16/2/2.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
