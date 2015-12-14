//
//  TagModel.h
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface TagModel : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *votecount;
@property(nonatomic,copy) NSString *createdAt;
@property(nonatomic,copy) NSString *updatedAt;
@property(nonatomic,copy) NSString *tagId;

@end
