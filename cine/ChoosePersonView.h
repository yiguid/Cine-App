//
//  ChoosePersonView.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Person;
@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Person *person;

- (instancetype)initWithFrame:(CGRect)frame
                        movie:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
