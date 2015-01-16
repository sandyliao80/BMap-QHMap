//
//  ListNoResultCell.h
//  ticket
//
//  Created by ZQD on 14-1-17.
//  Copyright (c) 2014年 Mibang.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAdefine.h"
typedef enum{
    MapNoResult=5,
    MapBadNetWork=6,
    MapBadService=7,
}NoresultType;


@interface ListNoResultCell : UITableViewCell{
    UIImageView *iconView;
    UILabel *titleLabel;
}
-(void)setInfo:(NoresultType)type position:(float)top;
-(void)setInfo:(NoresultType)type;
@end


@interface UITableView(ListNoResultCell)

-(ListNoResultCell *)ListNoResultCell;

@end