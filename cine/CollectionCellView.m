//
//  CollectionCellView.m
//  cine
//
//  Created by Mac on 15/11/23.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "CollectionCellView.h"
#import "CollectionModel.h"
@implementation CollectionCellView



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
  //  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //电影图片
        UIImageView *img = [[UIImageView alloc]init];
        [self.contentView addSubview:img];
        self.img = img;
        //电影名
        UILabel *name = [[UILabel alloc]init];
        name.font = NameFont;
        [self.contentView addSubview:name];
        self.name= name;
    }
    return self;

}


- (void)layoutSubviews{
    
    [self.img setFrame:CGRectMake(0, 0, 100, 150)];
    [self.name setFrame:CGRectMake(0, 100, 100, 30)];
}

- (void)setup :(CollectionModel *)model{
    
    self.img.image = [UIImage imageNamed:model.img];
    self.name.text = model.name;
    
}

@end
