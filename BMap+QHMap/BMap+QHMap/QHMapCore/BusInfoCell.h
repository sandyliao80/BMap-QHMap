//
//  BusInfoCell.h
//  AmapTest
//
//  Created by caomei on 14/11/14.
//  Copyright (c) 2014年 caomei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAdefine.h"
@interface BusInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

-(void)setInfo:(NSDictionary*)info;
-(CGFloat)getHeightWidthInfo:(NSDictionary*)info;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@interface UITableView(BusInfoCell)
-(BusInfoCell*)BusInfoCell;
@end