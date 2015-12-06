//
//  TagCoordinateModel.h
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagCoordinateModel : NSObject

@property(nonatomic,copy) NSString *x;
@property(nonatomic,copy) NSString *y;
@property(nonatomic,copy) NSString *direction;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *post;
@property(nonatomic,copy) NSString *createdAt;
@property(nonatomic,copy) NSString *updatedAt;
@property(nonatomic,copy) NSString *coordinateId;

@end
