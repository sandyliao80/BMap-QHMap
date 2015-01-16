//
//  LargeMapViewController.h
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAdefine.h"
#import "BaseMapViewController.h"

@interface LargeMapViewController :BaseMapViewController
{
    @protected
    @private
    BMKMapView*mapView;
    NSMutableArray * annotations;
    NSDictionary*curJumpInfo;
}

/**
 *  请存入LargeMapViewInfo类型 否则不会被显示
 *  @see LargeMapViewInfo
 */
@property(nonatomic,strong)NSArray *info;

///如果数组中有失败的显示,则增加
@property(nonatomic,readonly,assign)int faildShowCount;
@end


@interface LargeMapViewInfo : NSObject

@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*address;
@property(nonatomic,assign)CLLocationCoordinate2D location;
@property(nonatomic,assign)int imagePackIndex;//显示标注组中的哪一张图片

+(instancetype)LargeMapViewInfoMakeWithTitle:(NSString*)title andAddress:(NSString*)address andLocation:(CLLocationCoordinate2D)location andImageIndex:(int)imageIndex;
@end
