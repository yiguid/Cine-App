//
//  AddPersonTableViewCell.m
//  cine
//
//  Created by Mac on 15/11/10.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import "AddPersonTableViewCell.h"

@implementation AddPersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.imgView = [[UIView alloc]init];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)layoutSubviews{
    
    CGFloat viewW = self.bounds.size.width;
    
    [self.imgView setFrame:CGRectMake(20, 20, viewW - 20, 300)];
}


@end
