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
#import "RestAPI.h"
#import "TuijianTotalViewController.h"
#import "MovieViewController.h"
#import "RecModel.h"
static const CGFloat ChooseMovieViewImageLabelWidth = 42.f;

@interface ChooseMovieView ()
@property(nonatomic,strong)NSArray * tuijianarr;


@end

@implementation ChooseMovieView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       movie:(MovieModel *)movie
                      options:(MDCSwipeToChooseViewOptions *)options  {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _movie = movie;
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//                                UIViewAutoresizingFlexibleWidth |
//                                UIViewAutoresizingFlexibleBottomMargin;
//        self.imageView.autoresizingMask = self.autoresizingMask;
        

        [self constructInformationView];
      
       
        
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = hScreen*140/667;
    
    
    
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
//    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//                                        UIViewAutoresizingFlexibleTopMargin;
    
    _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height - bottomHeight)];
    _movieImageView.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
 //   imgView.image = self.imageView.image;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.cover] placeholderImage:nil];
    
    [_movieImageView setImage:_movieImageView.image];
    
    self.movieImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.movieImageView.layer.borderWidth = hScreen*15/667;
    
    _boliview = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - bottomHeight-hScreen*55/667, self.frame.size.width,hScreen*50/667)];
    _boliview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_movieImageView addSubview:_boliview];
    
    
    _movieImageView.userInteractionEnabled = YES;

    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chooseMovieView:withMovieName:withId:)]) {
        
        [self.delegate chooseMovieView:self withMovieName:_movie.title withId:_movie.ID];
       
    }
    
    
    
    [self addSubview:_movieImageView];
  
    

    [self addSubview:_informationView];


    [self constructFriendsImageLabelView];
    
}


- (void)constructFriendsImageLabelView {

    
    _friendsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_interestsImageLabelView.bounds) + hScreen*30/667, self.bounds.size.width,hScreen*30/667)];
    CGFloat bottomHeight = hScreen*140/667;
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/3,self.frame.size.height - bottomHeight-hScreen*50/667, self.bounds.size.width/3,hScreen*30/667)];
    [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
    _collectionButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:144/255.0 blue:0 alpha:1.0];
    _collectionButton.layer.masksToBounds = YES;
    _collectionButton.layer.cornerRadius = 6.0;
    
    [_movieImageView addSubview:_collectionButton];
    [_informationView addSubview:_friendsImageLabelView];
    

    
    CGFloat imgW = (CGRectGetWidth(self.bounds)-wScreen*125/375)/4;
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDef stringForKey:@"token"];
    NSDictionary *parameters = @{@"movie":_movie.ID};
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"access_token"];
    [manager GET:REC_API parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.tuijianarr = [RecModel mj_objectArrayWithKeyValuesArray:responseObject];
             
             NSInteger i = 0;
             
             for(RecModel * model in self.tuijianarr) {
                 
                  if (i<1) {
                 
                 NSLog(@"%@",model.content);
                         UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(wScreen*15/375,hScreen*55/667,self.bounds.size.width-wScreen*30/375,hScreen*40/667)];
                         title.text = model.content;
                         title.numberOfLines = 0;
                         title.font = [UIFont systemFontOfSize:13];
                         title.textAlignment = NSTextAlignmentLeft;
                         [title setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
                         [_informationView addSubview:title];
                         
                      
                  }
                 
                 
                 if (i<3) {
                     UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(wScreen*15/375 + i*wScreen*5/375+imgW*i,hScreen*100/667,wScreen*30/375,hScreen*30/667)];
                     imageView.backgroundColor = [UIColor blackColor];
                     [imageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatarURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [imageView setImage:imageView.image];
                         //头像圆形
                         imageView.layer.masksToBounds = YES;
                         imageView.layer.cornerRadius = imageView.frame.size.width/2;
                     }];
                     
                     
                     i++;
                     
                     [_informationView addSubview:imageView];
                     
                     if (self.tuijianarr.count>0) {
                         UIButton * text = [[UIButton alloc]initWithFrame:CGRectMake(wScreen*50/375 +imgW*3,hScreen*100/667,wScreen/4,hScreen*30/667)];
                         [text setTitle:[NSString stringWithFormat:@"%ld 位匠人推荐", self.tuijianarr.count] forState:UIControlStateNormal];
                         text.titleLabel.font = MarkFont;
                         text.backgroundColor = [UIColor grayColor];
                         text.layer.masksToBounds = YES;
                         text.layer.cornerRadius = 4.0;
                         [_informationView addSubview:text];
                         [text addTarget:self action:@selector(textbtn:) forControlEvents:UIControlEventTouchUpInside];
                     }
                 
                 }
                 
                 
             }

             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败,%@",error);
             
         }];

    
    UILabel *kind = [[UILabel alloc]initWithFrame:CGRectMake(wScreen*15/375,hScreen*30/667,wScreen*40/375,hScreen*20/667)];
    kind.text = [NSString stringWithFormat:@"类型:"];
    
    kind.textAlignment = NSTextAlignmentLeft;
    kind.font = [UIFont systemFontOfSize:14];
    [kind setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
    [_informationView addSubview:kind];
   
    NSInteger j = 0;
    
    for (NSString * str in _movie.genre) {
        
                    if (j<4) {
                        CGFloat htag = hScreen*50/667;
        
        
                        UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(wScreen*55/375+htag*j,hScreen*30/667,wScreen*40/375,hScreen*20/667)];
        
                        text1.text = [NSString stringWithFormat:@"%@",str];
                        text1.textColor = [UIColor grayColor];
                        text1.textAlignment = NSTextAlignmentCenter;
                        text1.layer.borderColor = [[UIColor grayColor]CGColor];
                        text1.layer.borderWidth = 1.0f;
                        text1.layer.masksToBounds = YES;
                        text1.font = MarkFont;
                        [_informationView addSubview:text1];
        
                        
                        j++;
                        
                    }
        
                    
                }

   

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(wScreen*15/375,0, self.bounds.size.width-wScreen*30/375,hScreen*20/667)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _movie.title,_movie.initialReleaseDate ];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [_nameLabel setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
    [_informationView addSubview:_nameLabel];
    
    

}

//寻找自己所属的viewcontroller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



-(void)textbtn:(id)sender{
    
    TuijianTotalViewController * tuijian = [[TuijianTotalViewController alloc]init];
    
    tuijian.hidesBottomBarWhenPushed = YES;
    
    tuijian.movieID = self.movie.ID;
    
   
 [[self viewController].navigationController pushViewController:tuijian animated:YES];
    

    
    
}





- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChooseMovieViewImageLabelWidth,
                              0,
                              ChooseMovieViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
//    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}


@end
