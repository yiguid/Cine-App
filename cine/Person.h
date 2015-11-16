//
//  Person.h
//  cine
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Person : NSObject
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, assign) NSUInteger age;
//@property (nonatomic, assign) NSUInteger numberOfSharedFriends;
//@property (nonatomic, assign) NSUInteger numberOfSharedInterests;
//@property (nonatomic, assign) NSUInteger numberOfPhotos;
//
//- (instancetype)initWithName:(NSString *)name
//                       image:(UIImage *)image
//                         age:(NSUInteger)age
//       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
//     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
//              numberOfPhotos:(NSUInteger)numberOfPhotos;


@property(nonatomic,copy) NSString *describle;
@property(nonatomic,strong) UIImage *image;

- (instancetype) initWithDescible :(NSString *)describle withImage :(UIImage *)image;
@end
