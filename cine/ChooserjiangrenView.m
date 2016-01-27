//
//  ChooserjiangrenView.m
//  cine
//
//  Created by wang on 16/1/27.
//  Copyright © 2016年 yiguid. All rights reserved.
//

#import "ChooserjiangrenView.h"
#import "ImageLabelView.h"
#import "UIImageView+WebCache.h"
#import "RestAPI.h"
static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChooserjiangrenView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@property (nonatomic, strong) UIButton *collectionButton;


@end





@implementation ChooserjiangrenView


- (instancetype)initWithFrame:(CGRect)frame
                        movie:(UserModel *)user
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _user = user;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_user.avatarURL] placeholderImage:nil];
        
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
