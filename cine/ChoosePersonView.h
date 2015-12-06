//
//  ChoosePersonView.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "UserModel.h"

@class Person;
@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) UserModel *user;

- (instancetype)initWithFrame:(CGRect)frame
                        movie:(UserModel *)user
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
