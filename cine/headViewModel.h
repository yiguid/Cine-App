//
//  headViewModel.h
//  cine
//
//  Created by Mac on 15/11/17.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface headViewModel : NSObject

@property(nonatomic,copy) NSString *backPicture;
@property(nonatomic,copy) NSString *userImg;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *mark;
@property(nonatomic,copy) NSString *vipImg;
@property(nonatomic,copy) NSString *vip;
@property(nonatomic,copy) NSString *addBtnImg;
@property(nonatomic,copy) NSString *addBtn;
@property(nonatomic,strong)UserModel * user;

@end
