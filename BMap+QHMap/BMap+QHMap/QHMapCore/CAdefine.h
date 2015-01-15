//
//  CAdefine.h
//  commonAnimation
//
//  Created by imqiuhang on 15/1/14.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#ifndef commonAnimation_CAdefine_h
#define commonAnimation_CAdefine_h


#endif



#ifdef DEBUG
#define MSLog(fmt,...) NSLog((@"[行号:%d]" "[函数名:%s]\n" fmt),__LINE__,__FUNCTION__,##__VA_ARGS__);
#else
#define MSLog(fmt,...);
#endif

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#define isIOS8                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define isIOS7                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define isIOS6                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0


#define CAVerson 1.0.0
#define CAWayCount (INT_MAX)

