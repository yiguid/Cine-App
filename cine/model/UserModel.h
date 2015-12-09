//
//  UserModel.h
//  cine
//
//  Created by Guyi on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy) NSString *active;
@property(nonatomic,copy) NSString *avatarURL;
@property(nonatomic,copy) NSString *catalog;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *createAt;
@property(nonatomic,copy) NSMutableArray *followed;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSMutableArray *posts;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *updatedAt;
@property(nonatomic,copy) NSString *user;

@end