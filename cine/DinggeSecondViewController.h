//
//  DinggeSecondViewController.h
//  cine
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DinggeSecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{

    UIView*_textView;
    UITextField*_textFiled;
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    UIButton * _textButton;
    UIImageView * image;
    


}

@end
