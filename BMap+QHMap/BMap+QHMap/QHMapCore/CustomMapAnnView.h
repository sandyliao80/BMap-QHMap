//
//  CustomMapAnnView.h
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "CAdefine.h"
#import "UIView+QHUiViewCtg.h"
@protocol CustomMapAnnDelegate;

@interface CustomMapAnnView :  BMKAnnotationView
/*
  是否显示右边的那个button~要想改成在左边显示 直接在.m文件改吧
 */
@property(nonatomic,assign)BOOL  showRigthBtn;

@property(nonatomic,weak)id <CustomMapAnnDelegate>delegate;
/*
  title和subtitle必须有其一,都木有就不显示calloutview了
 */
@property (nonatomic, copy) NSString *title;

@property(nonatomic,copy)NSString*subTitle;
/*
   有默认的view,也可以传一个自定义的View,宽高需要自己设置,或者在.m里面改
 */
@property (nonatomic, strong) UIView *calloutView;


@end

/*
 点击了右边的按钮的代理
 */
@protocol CustomMapAnnDelegate<NSObject>
@optional
-(void)rightBtnClicked;
@end





