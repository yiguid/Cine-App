//
//  MovieTableViewController.h
//  cine
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UITableViewController{

   UITableView *mytableView;
    NSMutableArray *starrings;
    NSMutableArray *genres;
    
   
   
   

}

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *name;



@end
