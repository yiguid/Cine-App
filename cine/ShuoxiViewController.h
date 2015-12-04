//
//  ShuoxiViewController.h
//  cine
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShuoxiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{
    
    UIView*_textView;
    UITextField*_textFiled;
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    UIButton * _textButton;
    UIImageView * image;
    
    
    
}


@end
