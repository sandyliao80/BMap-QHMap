//
//  MSUtil.m
//  BMap+QHMap
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "MSUtil.h"

#define TEXT_DISTANCE_MI            NSLocalizedString(@"%dm",nil)
#define TEXT_DISTANCE_KM            NSLocalizedString(@"%dkm",nil)

@implementation MSUtil
+(NSString *)covertDistance:(NSInteger)distance{
    
    if (distance<100 && distance>0) {
        return [NSString stringWithFormat:TEXT_DISTANCE_MI,distance];
    }else if(distance>100&&distance<1000){
        return [NSString stringWithFormat:TEXT_DISTANCE_MI,distance];
    }else{
        if (distance>1000) {
            return [NSString stringWithFormat:TEXT_DISTANCE_KM,distance/1000];
        }
    }
    return @"";
}



+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    {
        return [UIColor clearColor];

    }
    
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (float)countHeightOfString:(NSString *)string WithWidth:(float)width Font:(UIFont *)font {
    if ([NSNull null] == (id)string) {
        string = @"暂时没有数据";
    }
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize labelSize = [string sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height;
}

@end
