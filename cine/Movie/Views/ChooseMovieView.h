//
// ChoosePersonView.h
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "ImageLabelView.h"
#import "MovieModel.h"

@class MovieModel;
@class ChooseMovieView;
@protocol ChooseMovieViewDelegate <NSObject>

@optional
- (void) chooseMovieView :(ChooseMovieView *)chooseMovieView withMovieName :(NSString *)name withId :(NSString *)Id;

@end

@interface ChooseMovieView : MDCSwipeToChooseView

@property (nonatomic, weak) id<ChooseMovieViewDelegate>delegate;


@property (nonatomic,strong) MovieModel *movie;
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *movieImageView;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) NSString * firstID;
@property (nonatomic, strong) UIView * boliview;
- (instancetype)initWithFrame:(CGRect)frame
                       movie:(MovieModel *)movie
                      options:(MDCSwipeToChooseViewOptions *)options;


@end
