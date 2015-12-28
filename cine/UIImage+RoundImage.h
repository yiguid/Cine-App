//
//  UIImage+RoundImage.h
/**
 可直接返回一个裁剪后的圆形图片(多用于头像)
 */

#import <UIKit/UIKit.h>

@interface UIImage (RoundImage)
/**
 * 返回一张图片
 */
- (instancetype)Image;

/**
 * 返回一张图片
 */
+ (instancetype)ImageNamed:(NSString *)name;
@end
