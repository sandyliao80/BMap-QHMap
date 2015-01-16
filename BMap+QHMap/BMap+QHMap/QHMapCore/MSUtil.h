//
//  MSUtil.h
//  BMap+QHMap
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSUtil : NSObject
+ (NSString *)covertDistance:(NSInteger)distance;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (float)countHeightOfString:(NSString *)string WithWidth:(float)width Font:(UIFont *)font;
@end
