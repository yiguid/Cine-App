//
//  ChoosePersonView.m
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "ChoosePersonView.h"
#import "ImageLabelView.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"
static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChoosePersonView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@property (nonatomic, strong) UIButton *collectionButton;


@end


@implementation ChoosePersonView

- (instancetype)initWithFrame:(CGRect)frame
                        movie:(UserModel *)user
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _user = user;
        
         NSString *cover = [_user.hdImage stringByReplacingOccurrencesOfString:@"albumicon" withString:@"photo"];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:nil];
        
        
       
              
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
       
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView.layer.borderWidth = 15;
        self.imageView.userInteractionEnabled = YES;
        
        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
    
    [self constructDiscribleLable];
    
}


- (void) constructDiscribleLable{
    UILabel *discrible = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _informationView.frame.size.width - 20, _informationView.frame.size.height)];
    
    discrible.text = _user.nickname;
    discrible.numberOfLines = 0;
    discrible.font = NameFont;
    [discrible setTextColor:[UIColor lightGrayColor]];
    
    [_informationView addSubview:discrible];
    
    
    UILabel * promessage = [[UILabel alloc]initWithFrame:CGRectMake(50,0, _informationView.frame.size.width - 60, _informationView.frame.size.height)];
    
    promessage.text = _user.Description;
    promessage.numberOfLines = 0;
    promessage.font = NameFont;
    [promessage setTextColor:[UIColor lightGrayColor]];
    
    [_informationView addSubview:promessage];
    
    
    _PersonBtn = [[UIButton alloc]initWithFrame:CGRectMake(wScreen/3-20,self.frame.size.height-120, self.frame.size.width/3+20, 40)];
    _PersonBtn.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    _PersonBtn.layer.masksToBounds = YES;
    _PersonBtn.layer.cornerRadius = 4.0;
    [_PersonBtn setTitle:@"关注他" forState:UIControlStateNormal];
    [self.imageView addSubview:_PersonBtn];
    
    
}

- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChoosePersonViewImageLabelWidth,
                              0,
                              ChoosePersonViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}


@end
