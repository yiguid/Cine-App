//
//  AddPersonTableViewCell.h
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddPersonModel;

@interface AddPersonTableViewCell : UITableViewCell

@property(nonatomic,strong) AddPersonModel *model;

@property(nonatomic,strong) UIView *imgView;

//-(void)setup: (AddPersonModel *)model;



@end
