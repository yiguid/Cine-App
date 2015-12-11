//
//  SecondViewController.h
//  cine
//
//  Created by Guyi on 15/10/27.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "ChooseMovieView.h"
@class MovieModel;

/*
 * 用于向电影详情界面传值的代理
 */
@protocol MovieViewContronllerDelegate
- (void) MovieViewpassMovie :(MovieModel *)movie;
@end

@interface MovieViewController : UIViewController <MDCSwipeToChooseDelegate>
//- (IBAction)logout:(id)sender;
//- (IBAction)shareEvent:(id)sender;
//- (IBAction)wechatShare:(id)sender;
//- (IBAction)QQShare:(id)sender;
@property(nonatomic,assign) id<MovieViewContronllerDelegate> delegate;
@property(nonatomic,copy) NSString *ID;
@property (nonatomic, strong) MovieModel *currentPerson;
@property (nonatomic, strong) ChooseMovieView *frontCardView;
@property (nonatomic, strong) ChooseMovieView *backCardView;
@property (nonatomic,strong) MovieModel *modelMovie;

@end

