//
//  EditPhotoViewController.m
//  cine
//
//  Created by Deluan on 15/11/16.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "YXLTagEditorImageView.h"
#import "TextViewController.h"

@interface EditPhotoViewController ()<UIGestureRecognizerDelegate>

{
    YXLTagEditorImageView *tagEditorImageView;
    TextViewController *_textView;
}

@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建控件
    [self _initView];
    
    
}

//+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
//{
//    CGSize originalsize = [originalImage size];
//    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
//    
//    //原图长宽均小于标准长宽的，不作处理返回原图
//    if (originalsize.width<size.width && originalsize.height<size.height)
//    {
//        return originalImage;
//    }
//    
//    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
//    else if(originalsize.width>size.width && originalsize.height>size.height)
//    {
//        CGFloat rate = 1.0;
//        CGFloat widthRate = originalsize.width/size.width;
//        CGFloat heightRate = originalsize.height/size.height;
//        
//        rate = widthRate>heightRate?heightRate:widthRate;
//        
//        CGImageRef imageRef = nil;
//        
//        if (heightRate>widthRate)
//        {
//            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
//        }
//        else
//        {
//            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
//        }
//        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
//        CGContextRef con = UIGraphicsGetCurrentContext();
//        
//        CGContextTranslateCTM(con, 0.0, size.height);
//        CGContextScaleCTM(con, 1.0, -1.0);
//        
//        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
//        
//        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
//        
//        UIGraphicsEndImageContext();
//        CGImageRelease(imageRef);
//        
//        return standardImage;
//    }
//    
//    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
//    else if(originalsize.height>size.height || originalsize.width>size.width)
//    {
//        CGImageRef imageRef = nil;
//        
//        if(originalsize.height>size.height)
//        {
//            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
//        }
//        else if (originalsize.width>size.width)
//        {
//            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
//        }
//        
//        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
//        CGContextRef con = UIGraphicsGetCurrentContext();
//        
//        CGContextTranslateCTM(con, 0.0, size.height);
//        CGContextScaleCTM(con, 1.0, -1.0);
//        
//        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
//        
//        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
//        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
//        
//        UIGraphicsEndImageContext();
//        CGImageRelease(imageRef);
//        
//        return standardImage;
//    }
//    
//    //原图为标准长宽的，不做处理
//    else
//    {
//        return originalImage;
//    }
//}




- (void)_initView
{
//    tagEditorImageView =[[YXLTagEditorImageView alloc]initWithImage:self.image];
    tagEditorImageView = [[YXLTagEditorImageView alloc]initWithImage:self.image imageEvent:ImageHaveEvent];
    tagEditorImageView.viewC=self;
    tagEditorImageView.userInteractionEnabled=YES;
    [self.view addSubview:tagEditorImageView];
    [tagEditorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [tagEditorImageView addTagViewText:@"默认标签1" Location:CGPointMake(10,10) isPositiveAndNegative:YES];
//    [tagEditorImageView addTagViewText:@"默认标签2" Location:CGPointMake(50, 50) isPositiveAndNegative:NO];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(navItemClick)];
    self.navigationItem.rightBarButtonItem=item;

}



///**
// *  确定并pop    返回这个图片所有的标签地址内容，是否翻转样式的数组   坐标为这个图片的真实坐标
// */
-(void)navItemClick{
    
    NSMutableArray *array =[tagEditorImageView popTagModel];
    
    // 数据的处理

//    NSMutableArray *array1 =[NSMutableArray array];
//    for(NSDictionary *dic in array){
//        BOOL is =[dic[@"positiveAndNegative"] boolValue];
//        NSString *positiveAndNegative;
//        if (is) {
//            positiveAndNegative=@"反";
//        }else{
//            positiveAndNegative=@"正";
//        }
//        NSString *string =[NSString stringWithFormat:@"方向%@坐标%@文本%@",positiveAndNegative,dic[@"point"],dic[@"text"]];
//        [array1 addObject:string];
//    }
    
    // 创建push界面
    _textView = [[TextViewController alloc]init];
    _textView.pointAndTextsArray = array;
    _textView.movie = self.movie;
    
    [self.navigationController pushViewController:_textView animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // 截图
    _textView.screenshot = [self imageFromView:tagEditorImageView atFrame:CGRectMake(0, 0, tagEditorImageView.width, tagEditorImageView.height)];

    // 正常图片
    _textView.image = self.image;
    
}



// 调用系统的截图
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}



@end
