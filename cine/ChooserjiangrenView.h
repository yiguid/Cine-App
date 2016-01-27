//
//  ChooserjiangrenView.h
//  cine
//
//  Created by wang on 16/1/27.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import <Foundation/Foundation.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "UserModel.h"

@class Person;
@interface ChooserjiangrenView : MDCSwipeToChooseView


@property (nonatomic, strong, readonly) UserModel *user;
@property (nonatomic, strong) UIView * boliview;
- (instancetype)initWithFrame:(CGRect)frame
                        movie:(UserModel *)user
                      options:(MDCSwipeToChooseViewOptions *)options;


@property (nonatomic,strong) UIButton * PersonBtn;

@end
