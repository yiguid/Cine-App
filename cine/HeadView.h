//
//  headView.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class headViewModel;
@interface HeadView : UIView

@property(nonatomic,strong) headViewModel *model;

- (void) setup :(headViewModel *)model;
@end
