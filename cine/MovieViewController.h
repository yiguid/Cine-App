//
//  SecondViewController.h
//  cine
//
//  Created by Guyi on 15/10/27.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "Movie.h"
#import "ChooseMovieView.h"
@class MovieModel;
@interface MovieViewController : UIViewController <MDCSwipeToChooseDelegate>
- (IBAction)logout:(id)sender;
- (IBAction)shareEvent:(id)sender;
- (IBAction)wechatShare:(id)sender;
- (IBAction)QQShare:(id)sender;
@property(nonatomic,copy) NSString *ID;
@property (nonatomic, strong) Movie *currentPerson;
@property (nonatomic, strong) ChooseMovieView *frontCardView;
@property (nonatomic, strong) ChooseMovieView *backCardView;
@property (nonatomic,strong) MovieModel *modelMovie;

@end

