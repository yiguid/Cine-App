//
//  PublishViewController.h
//  cine
//
//  Created by Deluan on 15/11/13.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController<UIImagePickerControllerDelegate>

{
    UIImageView *_bgviewImage ;
    UILabel *_albumLabel ;
    UILabel *_gallerylabel ;
}

@property (nonatomic, copy) void (^popBlock)(NSString *string);

@end
