//
//  BaseMapViewController.h
//  AmapTest
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MapCommUtility.h"
#import "UIView+QHUiViewCtg.h"
#import "CAdefine.h"

typedef enum {
    searchBus,
    searchWalk,
    searchCar

}searchType;
@interface BaseMapViewController : UIViewController
{
    float screenWidth;
    float screenheight;
}

@property(nonatomic,strong)UITableView *dataTableView;
-(void)cusShowLoaingView;
-(void)cusHideLoaingView;
@end
