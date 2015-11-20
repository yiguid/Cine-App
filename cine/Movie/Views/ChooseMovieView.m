//
// ChoosePersonView.m
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

#import "ChooseMovieView.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"


static const CGFloat ChooseMovieViewImageLabelWidth = 42.f;

@interface ChooseMovieView ()

@end

@implementation ChooseMovieView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       movie:(Movie *)movie
                      options:(MDCSwipeToChooseViewOptions *)options  {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _movie = movie;
   //     _model = model;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;

        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 180.f;
    
    
    
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    
    _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height - 180.f)];
    _movieImageView.backgroundColor = [UIColor blackColor];
 //   imgView.image = self.imageView.image;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.image] placeholderImage:nil];
    
    [_movieImageView setImage:_movieImageView.image];
    _movieImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController)];
//    
//    [_movieImageView addGestureRecognizer:tap];
    [self addSubview:_movieImageView];
  
    

    [self addSubview:_informationView];

    [self constructNameLabel];
    [self constructCameraImageLabelView];
    [self constructInterestsImageLabelView];
    [self constructFriendsImageLabelView];
}

-(void)nextController{
    NSLog(@"movieDetail");
}

//电影名
- (void)constructNameLabel {
    CGFloat leftPadding = 10.f;
    CGFloat topPadding = 10.f;
//    CGRect frame = CGRectMake(leftPadding,
//                              topPadding,
//                              floorf(CGRectGetWidth(_informationView.frame)/2),
//                              CGRectGetHeight(_informationView.frame) - topPadding);
  
    
    CGRect frame = CGRectMake(leftPadding, topPadding, self.bounds.size.width - 20.f, 20);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = [NSString stringWithFormat:@"%@", _movie.name];
    [_informationView addSubview:_nameLabel];
}
//电影类型
- (void)constructCameraImageLabelView {
    CGFloat leftPadding = 10.f;
    CGRect frame = CGRectMake(leftPadding, CGRectGetMaxY(_nameLabel.bounds) + 20, self.bounds.size.width, 20);
    _cameraImageLabelView = [[ImageLabelView alloc]initWithFrame:frame];
    UILabel *kind = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.bounds.size.width - 60, 20)];
    kind.text = [NSString stringWithFormat:@"类型:    %@",_movie.numberOfSharedFriends];
    [kind setTextColor:[UIColor blackColor]];
//    _cameraImageLabelView.backgroundColor = [UIColor redColor];
    [_cameraImageLabelView addSubview:kind];
//    UIImage *image = [UIImage imageNamed:@"camera"];
//    _cameraImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
//                                                      image:image
//                                                       text:[@(_movie.numberOfPhotos) stringValue]];
    [_informationView addSubview:_cameraImageLabelView];
}
//电影介绍
- (void)constructInterestsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"book"];
//    _interestsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_cameraImageLabelView.frame)
//                                                         image:image
//                                                          text:[@(_movie.numberOfPhotos) stringValue]];
    _interestsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cameraImageLabelView.bounds) + 30, self.bounds.size.width, 70)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 70)];
    title.text = [NSString stringWithFormat:@"%@",_movie.numberOfSharedInterests];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    [_interestsImageLabelView addSubview:title];
    [_informationView addSubview:_interestsImageLabelView];
}
//收藏按钮
- (void)constructFriendsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"group"];
//    _friendsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_interestsImageLabelView.frame)
//                                                      image:image
//                                                       text:[@(_movie.numberOfSharedFriends) stringValue]];
//    [_informationView addSubview:_friendsImageLabelView];
    
    _friendsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_interestsImageLabelView.bounds) + 60, self.bounds.size.width, 30)];
//    _friendsImageLabelView.backgroundColor = [UIColor greenColor];
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, self.bounds.size.width - 80, 30)];
    [_collectionButton setTitle:_movie.numberOfPhotos forState:UIControlStateNormal];
    _collectionButton.backgroundColor = [UIColor grayColor];
    _collectionButton.layer.masksToBounds = YES;
    _collectionButton.layer.cornerRadius = 6.0;
    
//    [_collectionButton addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
    [_friendsImageLabelView addSubview:_collectionButton];
    [_informationView addSubview:_friendsImageLabelView];
    
}


- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChooseMovieViewImageLabelWidth,
                              0,
                              ChooseMovieViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}

//- (void)favourite{
//    NSLog(@"favourite");
//}

@end
