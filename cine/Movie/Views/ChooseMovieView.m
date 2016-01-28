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
#import "TuijianViewController.h"
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
    
    _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height - bottomHeight)];
    _movieImageView.backgroundColor = [UIColor colorWithRed:32.0/255 green:26.0/255 blue:25.0/255 alpha:1.0];
 //   imgView.image = self.imageView.image;
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:_movie.cover] placeholderImage:nil];
    
    [_movieImageView setImage:_movieImageView.image];
    
    self.movieImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.movieImageView.layer.borderWidth = 15;
    
    _boliview = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - bottomHeight-55, self.frame.size.width, 50)];
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

    
    _friendsImageLabelView = [[ImageLabelView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_interestsImageLabelView.bounds) + 30, self.bounds.size.width, 30)];
    CGFloat bottomHeight = 140.f;
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/3,self.frame.size.height - bottomHeight-50, self.bounds.size.width/3, 30)];
    [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
    _collectionButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:144/255.0 blue:0 alpha:1.0];
    _collectionButton.layer.masksToBounds = YES;
    _collectionButton.layer.cornerRadius = 6.0;
    
    [_movieImageView addSubview:_collectionButton];
    [_informationView addSubview:_friendsImageLabelView];
    

    
    CGFloat imgW = (CGRectGetWidth(self.bounds)-125)/4;
    
    
    
    
    
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
                 
                 if (i<3) {
                     UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5 + i*5+imgW*i, 100, 30, 30)];
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
                         UIButton * text = [[UIButton alloc]initWithFrame:CGRectMake(wScreen-235,100,120, 30)];
                         [text setTitle:[NSString stringWithFormat:@"%ld 位匠人推荐", self.tuijianarr.count] forState:UIControlStateNormal];
                         text.titleLabel.font = TextFont;
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
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5,70, self.bounds.size.width,20)];
        title.text = [NSString stringWithFormat:@"导演：%@",_movie.director];
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        [title setTextColor:[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]];
        [_informationView addSubview:title];

    
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
    
    TuijianViewController * person = [[TuijianViewController alloc]init];
    
    person.hidesBottomBarWhenPushed = YES;
    
    person.personarr = self.tuijianarr;
    
    [[self viewController].navigationController pushViewController:person animated:YES];
    
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


@end
