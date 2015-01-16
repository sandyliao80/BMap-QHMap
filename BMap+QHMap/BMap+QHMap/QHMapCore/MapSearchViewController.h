//
//  MapSearchViewController.h
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
@interface MapSearchViewController :  BaseMapViewController<UITableViewDataSource,UITableViewDelegate>
{
  @private
    CLLocationCoordinate2D startCoordinate;
    CLLocationCoordinate2D destinationCoordinate;
}
/**
 *  title & CustomMapLocation
 *  @{@"location":[CustomMapLocation customLocationMakeWithCLL:CLLocationCoordinate2DMake(30.2240510426, 120.124415001)],@"title":@"杭州西湖",@"address":@"杭州市西湖区"};
 */
@property(strong ,nonatomic)NSDictionary*info;

@end
