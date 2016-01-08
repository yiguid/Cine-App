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
#import "UIImageView+WebCache.h"


static const CGFloat ChooseMovieViewImageLabelWidth = 42.f;

@interface ChooseMovieView ()

@end

@implementation ChooseMovieView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       movie:(MovieModel *)movie
                      options:(MDCSwipeToChooseViewOptions *)options  {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _movie = movie;
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
    CGFloat bottomHeight = 140.f;
    
    
    
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    
    _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height - bottomHeight)];
    _movieImageView.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
 //   imgView.image = self.imageView.image;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.cover] placeholderImage:nil];
    
    [_movieImageView setImage:_movieImageView.image];
    
    _boliview = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - bottomHeight-40, self.frame.size.width, 50)];
    _boliview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_movieImageView addSubview:_boliview];
    
    
    
    _movieImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController)];
//    
//    [_movieImageView addGestureRecognizer:tap];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chooseMovieView:withMovieName:withId:)]) {
        [self.delegate chooseMovieView:self withMovieName:_movie.title withId:_movie.ID];
        
       
    }
    
    [self addSubview:_movieImageView];
  
    

    [self addSubview:_informationView];

//    [self constructNameLabel];
//    [self constructCameraImageLabelView];
//    [self constructInterestsImageLabelView];
    [self constructFriendsImageLabelView];
    
}

-(void)nextController{
    NSLog(@"movieDetail");
}

////电影名
//- (void)constructNameLabel {
//    CGFloat leftPadding = 10.f;
//    CGFloat topPadding = 10.f;
////    CGRect frame = CGRectMake(leftPadding,
////                              topPadding,
////                              floorf(CGRectGetWidth(_informationView.frame)/2),
////                              CGRectGetHeight(_informationView.frame) - topPadding);
//  
//    
//    CGRect frame = CGRectMake(5, topPadding, self.bounds.size.width, 20);
//    _nameLabel = [[UILabel alloc] initWithFrame:frame];
//    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    _nameLabel.text = [NSString stringWithFormat:@"%@", _movie.title];
//    [_informationView addSubview:_nameLabel];
//}
////电影类型
//- (void)constructCameraImageLabelView {
//    CGFloat leftPadding = 0.f;
//    CGRect frame = CGRectMake(5, CGRectGetMaxY(_nameLabel.bounds) + 20, self.bounds.size.width, 20);
//    _cameraImageLabelView = [[ImageLabelView alloc]initWithFrame:frame];
//    UILabel *kind = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
//    kind.text = [NSString stringWithFormat:@"类型：%@",[_movie.genre componentsJoinedByString:@" "]];
//    kind.textAlignment = NSTextAlignmentCenter;
//    [kind setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
////    _cameraImageLabelView.backgroundColor = [UIColor redColor];
//    [_cameraImageLabelView addSubview:kind];
////    UIImage *image = [UIImage imageNamed:@"camera"];
////    _cameraImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
////                                                      image:image
////                                                       text:[@(_movie.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_cameraImageLabelView];
//}
//电影导演
//- (void)constructInterestsImageLabelView {
////    UIImage *image = [UIImage imageNamed:@"book"];
////    _interestsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_cameraImageLabelView.frame)
////                                                         image:image
////                                                          text:[@(_movie.numberOfPhotos) stringValue]];
//    _interestsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cameraImageLabelView.bounds) + 24, self.bounds.size.width, 70)];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 70)];
//    title.text = [NSString stringWithFormat:@"导演：%@",_movie.director];
//    title.numberOfLines = 0;
//    title.textAlignment = NSTextAlignmentCenter;
//    [_interestsImageLabelView addSubview:title];
//    [_informationView addSubview:_interestsImageLabelView];
//}
//收藏按钮
- (void)constructFriendsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"group"];
//    _friendsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_interestsImageLabelView.frame)
//                                                      image:image
//                                                       text:[@(_movie.numberOfSharedFriends) stringValue]];
//    [_informationView addSubview:_friendsImageLabelView];
    
    _friendsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_interestsImageLabelView.bounds) + 30, self.bounds.size.width, 30)];
//    _friendsImageLabelView.backgroundColor = [UIColor greenColor];
    CGFloat bottomHeight = 140.f;
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/3,self.frame.size.height - bottomHeight-35, self.bounds.size.width/3, 30)];
    [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
    _collectionButton.backgroundColor = [UIColor colorWithRed:249/255.0 green:124/255.0 blue:0 alpha:1.0];
    _collectionButton.layer.masksToBounds = YES;
    _collectionButton.layer.cornerRadius = 6.0;
    
//    [_collectionButton addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];
//    [_boliview bringSubviewToFront:_collectionButton];
    [_movieImageView addSubview:_collectionButton];
    [_informationView addSubview:_friendsImageLabelView];
    
    
    UIImage *image3 = [UIImage imageNamed:@"avatar@2x.png"];
    UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 30, 30)];
    [imageView3 setImage:image3];
    [_informationView addSubview:imageView3];
    
    UIImage *image4 = [UIImage imageNamed:@"avatar@2x.png"];
    UIImageView * imageView4= [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 30, 30)];
    [imageView4 setImage:image4];
    [_informationView addSubview:imageView4];
    
    UIImage *image5 = [UIImage imageNamed:@"avatar@2x.png"];
    UIImageView * imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(70, 100, 30, 30)];
    [imageView5 setImage:image5];
    [_informationView addSubview:imageView5];
    
    UIImage *image6 = [UIImage imageNamed:@"avatar@2x.png"];
    UIImageView * imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 100, 30, 30)];
    [imageView6 setImage:image6];
    [_informationView addSubview:imageView6];
    
    UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake(140, 100, 120, 28)];
    text.text = @"112匠人推荐";
    text.textColor = [UIColor whiteColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor grayColor];
    [_informationView addSubview:text];
    
    
    
    UILabel *kind = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, self.bounds.size.width, 20)];
    kind.text = [NSString stringWithFormat:@"类型：%@",[_movie.genre componentsJoinedByString:@" "]];
    kind.textAlignment = NSTextAlignmentLeft;
    kind.font = [UIFont systemFontOfSize:15];
    [kind setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
    [_informationView addSubview:kind];

   

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.bounds.size.width, 20)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _movie.title,_movie.initialReleaseDate ];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [_nameLabel setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
    [_informationView addSubview:_nameLabel];
    
    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width, 70)];
//        title.text = [NSString stringWithFormat:@"导演：%@",_movie.director];
//        title.numberOfLines = 0;
//        title.textAlignment = NSTextAlignmentCenter;
//        [title setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
//        [_interestsImageLabelView addSubview:title];
//        [_informationView addSubview:_interestsImageLabelView];

    
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
