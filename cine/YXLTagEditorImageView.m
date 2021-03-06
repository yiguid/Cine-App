//
//  YXLTagEditorImageView.m
//  YXLImageLabelDemo
//
//  Created by 叶星龙 on 15/10/26.
//  Copyright © 2015年 叶星龙. All rights reserved.
//

#import "YXLTagEditorImageView.h"
#import "YXLTagView.h"
#import "MiYiTagSearchBarVC.h"
#import "BackImageViewController.h"
#import "DinggeTitleViewController.h"

@interface YXLTagEditorImageView ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *arrayTagS;
    UIView *viewCover;
    UIView *viewMBP;
    UIButton *buttonOne;
    YXLTagView *viewTag;
    CGFloat imageScale;
    UIImage *imageLabelIcon;
    CGFloat viewTagLeft;
    NSMutableArray *arrayInitDidView;
    BOOL isViewDidLoad;
    
}
@end

@implementation YXLTagEditorImageView


- (id)initWithImage:(UIImage *)image imageEvent:(ImageEvent)imageEvent
{
    self =[super init];
    if (self) {
        self.imageEvent = imageEvent;
        arrayInitDidView= [NSMutableArray array];
        imageLabelIcon =[UIImage imageNamed:@"textTag"];
        arrayTagS =[NSMutableArray array];
        _imagePreviews =[self getimagePreviews];
        _imagePreviews.userInteractionEnabled = YES;
        [self addSubview:_imagePreviews];
        if(self.imageEvent == ImageHaveEvent)
        {
            _imagePreviews.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            _imagePreviews.contentMode = UIViewContentModeScaleToFill;
        }
        if (image==nil) {
            return self;
        }
        _imagePreviews.image =image;
        [self scaledFrame];
        [self initTagUI];
        
    }
    return self;

}

-(id)initWithImage:(UIImage *)image{
    self =[super init];
    if (self) {
        arrayInitDidView= [NSMutableArray array];
        imageLabelIcon =[UIImage imageNamed:@"textTag"];
        arrayTagS =[NSMutableArray array];
        _imagePreviews =[self getimagePreviews];
        _imagePreviews.userInteractionEnabled=YES;
        [self addSubview:_imagePreviews];
        _imagePreviews.contentMode = UIViewContentModeScaleAspectFit;
        if (image==nil) {
            return self;
        }
        _imagePreviews.image =image;
        [self scaledFrame];
        [self initTagUI];
        
    }
    return self;
}

-(id)init{
    self =[super init];
    if (self) {
        if (imageLabelIcon==nil) {
            imageLabelIcon =[UIImage imageNamed:@"textTag"];
        }
        if (arrayTagS==nil) {
            arrayTagS =[NSMutableArray array];
        }
        if (arrayInitDidView==nil) {
            arrayInitDidView= [NSMutableArray array];
        }
        if (_imagePreviews==nil) {
            _imagePreviews =[self getimagePreviews];
            _imagePreviews.userInteractionEnabled=YES;
            [self addSubview:_imagePreviews];
            [self initTagUI];
        }
    }
    return self;
}

/**
 *  初始化MBP界面
 */
-(void)initTagUI{
    
    viewCover =[UIView new];
    viewCover.alpha=0;
    [self addSubview:viewCover];
    [viewCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    viewMBP =[UIView new];
    UITapGestureRecognizer* viewMBPTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewMBP)];
    viewMBPTag.numberOfTapsRequired=1;
    viewMBPTag.numberOfTouchesRequired=1;
    viewMBPTag.delegate = self;
    [viewMBP addGestureRecognizer:viewMBPTag];
    [viewCover addSubview:viewMBP];
    [viewMBP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat widthAndHeight =50;
    
    buttonOne =[self getButtonOne];
    buttonOne.layer.cornerRadius = widthAndHeight;
    [viewCover addSubview:buttonOne];
    
    // 已经复制粘贴下去了
//    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self).offset(-(widthAndHeight/1.3));
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(widthAndHeight, widthAndHeight));
//    }];
//    buttonOne.center = self.point;
}
/**
 *  mbp界面的动画
 */
-(void)mbpAnimation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.1 animations:^{
            viewCover.alpha=1;
            buttonOne.transform=CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
                buttonOne.transform=CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            viewCover.alpha=0;
        }completion:^(BOOL finished) {
            if (arrayTagS.count !=0) {
                YXLTagView *tag =[arrayTagS lastObject];
                if (!tag.isImageLabelShow) {
                    [tag removeFromSuperview];
                    [arrayTagS removeLastObject];
                }
            }
        }];
        
    }
    
}

#pragma -mark 添加已知标签

-(void)addTagViewText:(NSString *)text Location:(CGPoint )point isPositiveAndNegative:(BOOL)isPositiveAndNegative{
    CGFloat X;
    imageScale = 1;
    if (isPositiveAndNegative) {
        X = point.x*imageScale-8;
    }else{
        X = point.x*imageScale;
    }
    CGPoint pointimageScale =CGPointMake(X, point.y*imageScale+imageLabelIcon.size.height/2);
    [self addtagViewimageClickinit:pointimageScale isAddTagView:YES];
    if(text.length!=0)
        viewTag.imageLabel.labelWaterFlow.text=text;
    [arrayInitDidView addObject:[NSString stringWithFormat:@"%d",isPositiveAndNegative]];
    
}

- (void)didMoveToWindow {
    [self layoutIfNeeded];
    if (self.window) {
        if(!isViewDidLoad){
            isViewDidLoad=YES;
            for (int i=0; i<arrayInitDidView.count; i++) {
                NSLog(@"%d",![arrayInitDidView[i] boolValue]);
                if(![arrayInitDidView[i] boolValue]==YES)
                {
                    break;
                }
                [self viewTagIsPositiveAndNegative:![arrayInitDidView[i] boolValue] view:arrayTagS[i]];
            }
        }
    }
}

#pragma -mark 点击创建标签
-(void)addtagViewimageClickinit:(CGPoint)point isAddTagView:(BOOL)isAdd{
    YXLTagView *viewTagNew =[[YXLTagView alloc]init];
    UIPanGestureRecognizer *panTagView =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTagView:)];
    panTagView.minimumNumberOfTouches=1;
    panTagView.maximumNumberOfTouches=1;
    panTagView.delegate=self;
    [viewTagNew addGestureRecognizer:panTagView];
    
    UITapGestureRecognizer* tapTagView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTagView:)];
    tapTagView.numberOfTapsRequired=1;
    tapTagView.numberOfTouchesRequired=1;
    tapTagView.delegate = self;
    [viewTagNew addGestureRecognizer:tapTagView];
    
    UILongPressGestureRecognizer *longTagView =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTagView:)];
    longTagView.minimumPressDuration=0.5;
    longTagView.delegate=self;
    [viewTagNew addGestureRecognizer:longTagView];
    [_imagePreviews addSubview:viewTagNew];
    
    [viewTagNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(point.x));
        make.top.equalTo(@(point.y-imageLabelIcon.size.height/2));
        make.width.greaterThanOrEqualTo(@(viewTagNew.imageLabel.image.size.width+8));
        make.height.equalTo(@(imageLabelIcon.size.height));
    }];
    
    [arrayTagS addObject:viewTagNew];
    viewTag=viewTagNew;
    if (!isAdd) {
        [self mbpAnimation:YES];
    }else{
        viewTagNew.isImageLabelShow=YES;
    }
    
    
}


#pragma -mark GestureRecognizer
/**
 *  标签移动
 */
-(void)panTagView:(UIPanGestureRecognizer *)sender{
    
    if(self.imageEvent == ImageHaveEvent)
    {
        viewTag =(YXLTagView *)sender.view;
        CGPoint point = [sender locationInView:_imagePreviews];
        if (sender.state ==UIGestureRecognizerStateBegan) {
            viewTagLeft =point.x-CGOriginX(viewTag.frame);
        }
        [self panTagViewPoint:point];
    }
}
/**
 *  点击标签翻转
 */
-(void)tapTagView:(UITapGestureRecognizer *)sender{
    if(self.imageEvent == ImageHaveEvent)
    {
        viewTag = (YXLTagView *)sender.view;
        [self viewTagIsPositiveAndNegative:viewTag.isPositiveAndNegative view:viewTag];
    }
    else
    {
        viewTag = (YXLTagView *)sender.view;
        
        //[self.owner.navigationController pushViewController:[MiYiTagSearchBarVC new] animated:YES];
        
        
        DinggeTitleViewController *title = [[DinggeTitleViewController alloc]init];
        title.hidesBottomBarWhenPushed = YES;
      
        title.tagTitle = viewTag.imageLabel.labelWaterFlow.text;
//        title.tagimage = viewTag.
        [self.viewC.navigationController pushViewController:title animated:YES];
//        NSLog(@"Class%@",NSStringFromClass([self.viewC class]));
//        NSLog(@"点击了标签%@",viewTag.imageLabel.labelWaterFlow.text);
        
       
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
/**
 *  长按手势
 */
-(void)longTagView:(UILongPressGestureRecognizer *)sender{
    
    if(self.imageEvent == ImageHaveEvent)
    {
        viewTag =(YXLTagView *)sender.view;
        if (sender.state ==UIGestureRecognizerStateBegan) {
            [sender.view becomeFirstResponder];
            UIMenuController *popMenu = [UIMenuController sharedMenuController];
            UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(menuItem1Pressed)];
            UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem2Pressed)];
            NSArray *menuItems = [NSArray arrayWithObjects:item1,item2,nil];
            [popMenu setMenuItems:menuItems];
            [popMenu setArrowDirection:UIMenuControllerArrowDown];
            [popMenu setTargetRect:sender.view.frame inView:_imagePreviews];
            [popMenu setMenuVisible:YES animated:YES];
        }
    }
}
/**
 *  点击图片
 */
-(void)clickimagePreviews:(UITapGestureRecognizer *)sender{
    if(self.imageEvent == ImageHaveEvent)
    {
        _point = [sender locationInView:sender.view];
        // 从上面复制粘贴下来的
        [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // 给中心位置和大小
            buttonOne.frame = CGRectMake(0, 0, 100, 100);
//            buttonOne.center = CGPointMake(self.point.x, self.point.y+165);
            buttonOne.center = CGPointMake(wScreen/2,hScreen/2 - 50);
        }];
        [self addtagViewimageClickinit:_point isAddTagView:NO];
    }
}
-(void)viewTagIsPositiveAndNegative:(BOOL)isPositiveAndNegative view:(YXLTagView *)view{
    if(isPositiveAndNegative){
        view.isPositiveAndNegative=NO;
        [self positive:view];
    }else{
        view.isPositiveAndNegative=YES;
        [self negative:view];
    }
}
/**
 *  正向
 */
-(void)positive:(YXLTagView *)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CGOriginX(view.frame)+CGWidth(view.frame)-8));
        if (CGRectGetMaxX(view.frame)+CGWidth(view.frame)-8 >=kWindowWidth) {
            make.left.equalTo(@(kWindowWidth-CGWidth(view.frame)));
        }
    }];
}
/**
 *  反向
 */
-(void)negative:(YXLTagView *)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CGOriginX(view.frame)-CGWidth(view.frame)+8));
        if (CGOriginX(view.frame)-CGWidth(view.frame)+8<=0) {
            make.left.equalTo(@0);
        }
    }];
}
#pragma -mark
/**
 *  编辑
 */
-(void)menuItem1Pressed{
    MiYiTagSearchBarVC *vc =[[MiYiTagSearchBarVC alloc]init];
    __weak YXLTagEditorImageView *ws =self;
    vc.block=^(NSString *text){
        viewTag.imageLabel.labelWaterFlow.text=text;
        [viewTag mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size =[text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
            CGFloat W;
            if (CGWidth(imageLabelIcon)-15 > size.width) {
                W=0;
            }else{
                W=size.width-(CGWidth(imageLabelIcon)-15);
            }
            if(viewTag.isPositiveAndNegative){
                if (CGRectGetMaxX(viewTag.frame)-(CGWidth(imageLabelIcon)+8+W)<=0) {
                    make.left.equalTo(@0);
                }
            }else{
                if (CGRectGetMaxX(viewTag.frame) >=kWindowWidth) {
                    make.left.equalTo(@(kWindowWidth-(CGWidth(imageLabelIcon)+8+W)));
                }
            }
            [ws correct:text isPositiveAndNegative:YES];

        }];
    };
    [self.viewC.navigationController pushViewController:vc animated:YES];
}
/**
 *  删除
 */
-(void)menuItem2Pressed{
    for (YXLTagView *tag in arrayTagS) {
        if ([tag isEqual: viewTag]) {
            [arrayTagS removeObject:tag];
            [tag removeFromSuperview];
            break;
        }
    }
}

/**
 *  pan手势  标签移动
 */
-(void)panTagViewPoint:(CGPoint )point{
    [viewTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(point.x-viewTagLeft));
        make.top.equalTo(@(point.y-imageLabelIcon.size.height/2));
        if((point.x-viewTagLeft)<=0){
            make.left.equalTo(@0);
        }
        if (point.y+imageLabelIcon.size.height/2 >=CGRectGetHeight(_imagePreviews.frame)) {
            make.top.equalTo(@(CGRectGetHeight(_imagePreviews.frame)-imageLabelIcon.size.height));
        }
        if (point.y-imageLabelIcon.size.height/2 <= 0) {
            make.top.equalTo(@(0));
        }
        if (point.x+(CGWidth(viewTag.frame)-viewTagLeft) >=kWindowWidth) {
            make.left.equalTo(@(kWindowWidth-(CGWidth(viewTag.frame))));
        }
    }];
}


#pragma -mark 点击

-(void)clickViewMBP{
    [self mbpAnimation:NO];
}

-(void)clickButtonOne{
    MiYiTagSearchBarVC *vc =[[MiYiTagSearchBarVC alloc]init];
    __weak YXLTagEditorImageView *ws =self;
    vc.block=^(NSString *text){
        viewTag.imageLabel.labelWaterFlow.text=text;
        viewTag.isImageLabelShow=YES;
        [self clickViewMBP];
        [ws correct:text isPositiveAndNegative:YES];
    };
    
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    backIetm.title =@"";
    self.viewC.navigationItem.backBarButtonItem = backIetm;
    
    [self.viewC.navigationController pushViewController:vc animated:YES];
}

/**
 *  修正
 */
-(void)correct:(NSString *)text isPositiveAndNegative:(BOOL)isPositiveAndNegative{
    CGSize size =[text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
    CGFloat W;
    if (CGWidth(imageLabelIcon)-15 > size.width) {
        W=0;
    }else{
        W=size.width-(CGWidth(imageLabelIcon)-15);
    }
    
    if (CGOriginX(viewTag.frame)+(CGWidth(imageLabelIcon)+8+W) >=kWindowWidth) {
        [viewTag mas_updateConstraints:^(MASConstraintMaker *make) {
            if (isPositiveAndNegative) {
                viewTag.isPositiveAndNegative=YES;
                make.left.equalTo(@(CGOriginX(viewTag.frame)-(CGWidth(imageLabelIcon)+8+W)));
            }else{
                make.left.equalTo(@(CGRectGetMaxX(viewTag.frame)-(CGWidth(imageLabelIcon)+8+W)));
                
            }
            
        }];
    }
}

#pragma -mark 初始化
-(UIImageView *)getimagePreviews{
    UIImageView *image =[UIImageView new];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickimagePreviews:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    tap.delegate = self;
    [image addGestureRecognizer:tap];
    return image;
}

-(UIButton *)getButtonOne{
    UIButton *btn =[UIButton new];
    btn.backgroundColor=UIColorRGBA(0, 0, 0, 0.6);
    [btn setTitle:@"添加标签" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickButtonOne) forControlEvents:UIControlEventTouchUpInside];

    
    return btn;
}




#pragma -mark 尺寸
-(void)scaledFrame{
    

    
    CGRect noScale = CGRectMake(0.0, 0.0, _imagePreviews.image.size.width , _imagePreviews.image.size.height );
    if (CGWidth(noScale) <= kWindowWidth && CGHeight(noScale) <= self.frame.size.height) {
        imageScale = 1.0;
        if(self.imageEvent == ImageHaveEvent)
        {
            _imagePreviews.frame= (CGRect){{kWindowWidth/2 -noScale.size.width/2,(kWindowHeight-64) /2 -noScale.size.height/2} ,noScale.size};
        }
        else
        {
            _imagePreviews.frame = CGRectMake(10, 10, wScreen-20, 190);
        }
        return;
    }
    CGRect scaled;
    imageScale= (kWindowHeight-64) / _imagePreviews.image.size.height;
    scaled=CGRectMake(0.0, 0.0, _imagePreviews.image.size.width * imageScale , _imagePreviews.image.size.height * imageScale );
    if (CGWidth(scaled) <= kWindowWidth && CGHeight(scaled) <= (kWindowHeight-64)) {
        if(self.imageEvent == ImageHaveEvent)
        {
            _imagePreviews.frame= (CGRect){{kWindowWidth/2 -scaled.size.width/2,(self.frame.size.height-64) /2 -scaled.size.height/2} ,scaled.size};
        }
        else
        {
            _imagePreviews.frame = CGRectMake(10, 10, wScreen-20, 190);
        }
        return;
    }
    imageScale = kWindowWidth / _imagePreviews.image.size.width;
    scaled = CGRectMake(0.0, 0.0, _imagePreviews.image.size.width * imageScale, _imagePreviews.image.size.height * imageScale);
    if(self.imageEvent == ImageHaveEvent)
    {
        _imagePreviews.frame=(CGRect){{kWindowWidth/2 -scaled.size.width/2,(kWindowHeight-64) /2 -scaled.size.height/2} ,scaled.size};
    }
    else
    {
        _imagePreviews.frame = CGRectMake(0, 0, wScreen, 190);
        
    }
    
}

#pragma -mark pop返回标签尺寸和文本
-(NSMutableArray *)popTagModel{
//    NSMutableArray *array =[NSMutableArray array];
//    NSString *positiveAndNegative;
//    NSString *point;
//    if (viewCover.alpha==1) {
//        if (arrayTagS.count !=0) {
//            YXLTagView *tag =[arrayTagS lastObject];
//            if (!tag.isImageLabelShow) {
//                [tag removeFromSuperview];
//                [arrayTagS removeLastObject];
//            }
//        }
//    }
//    for (YXLTagView *tag in arrayTagS) {
//        positiveAndNegative =@"0";
//        point =[NSString stringWithFormat:@"%f,%f",CGOriginX(tag.frame)/imageScale,CGOriginY(tag.frame)/imageScale];
//        if(tag.isPositiveAndNegative ==YES){
//            positiveAndNegative =@"1";
//            point =[NSString stringWithFormat:@"%f,%f",CGRectGetMaxX(tag.frame)/imageScale,CGOriginY(tag.frame)/imageScale];
//        }
//        NSDictionary *dic=@{@"positiveAndNegative":positiveAndNegative,@"point":point,@"text":tag.imageLabel.labelWaterFlow.text};
//        [array addObject:dic];
//    }
    
    //  自己定义返回数据格式
    NSMutableArray *array =[NSMutableArray array];
    NSString *positiveAndNegative;
    float pointX;
    float pointY;
    if (viewCover.alpha==1) {
        if (arrayTagS.count !=0) {
            YXLTagView *tag =[arrayTagS lastObject];
            if (!tag.isImageLabelShow) {
                [tag removeFromSuperview];
                [arrayTagS removeLastObject];
            }
        }
    }
    for (YXLTagView *tag in arrayTagS) {
        positiveAndNegative =@"right";
        pointX = CGOriginX(tag.frame)/imageScale;
        pointY = CGOriginY(tag.frame)/imageScale;
        if(tag.isPositiveAndNegative ==YES){
            positiveAndNegative =@"left";
        }
        NSDictionary *dic = @{@"x":@(pointX),@"y":@(pointY),@"direction":positiveAndNegative,@"text":tag.imageLabel.labelWaterFlow.text};
        [array addObject:dic];
    }
    return array;
}
@end
