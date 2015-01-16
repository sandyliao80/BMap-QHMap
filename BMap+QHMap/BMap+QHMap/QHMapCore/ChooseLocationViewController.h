//
//  ChooseLocationViewController.h
//  AmapTest
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
@interface ChooseLocationViewController : BaseMapViewController
/**
 *  传入定位成功之前需要显示的坐标,如果不传 则在定位成功前显示的是北京
 */
@property(nonatomic,assign) CLLocationCoordinate2D startCoordinate;

@end
