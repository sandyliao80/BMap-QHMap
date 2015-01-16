//
//  MapCommUtility.m
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "MapCommUtility.h"
#import "MSUtil.h"
@implementation MapCommUtility

+(BMKCoordinateRegion) regionForAnnotations:(NSArray*) anns
{
    NSAssert(anns!=nil, @"annotations was nil");
    NSAssert([anns count]!=0, @"annotations was empty");
    
    double minLat=360.0f, maxLat=-360.0f;
    double minLon=360.0f, maxLon=-360.0f;
    
    for (id<BMKAnnotation> vu in anns) {
        if ( vu.coordinate.latitude  < minLat ) minLat = vu.coordinate.latitude;
        if ( vu.coordinate.latitude  > maxLat ) maxLat = vu.coordinate.latitude;
        if ( vu.coordinate.longitude < minLon ) minLon = vu.coordinate.longitude;
        if ( vu.coordinate.longitude > maxLon ) maxLon = vu.coordinate.longitude;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0, (minLon+maxLon)/2.0);
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance (center, MAX((maxLat-minLat)*2,5000),MAX((maxLat-minLat)*2,5000));
    return region;
}
+(BMKCoordinateRegion)regionForCarAnnotations:(NSArray *)anns{
    id<BMKAnnotation> firstAnn= [anns firstObject];
    id<BMKAnnotation> lastAnn= [anns lastObject];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((firstAnn.coordinate.latitude+lastAnn.coordinate.latitude)/2.0f,(firstAnn.coordinate.longitude+lastAnn.coordinate.longitude)/2.0f);
    CLLocation*startLocation=[[CLLocation alloc] initWithLatitude:firstAnn.coordinate.latitude longitude:firstAnn.coordinate.longitude];
    CLLocation*endLocation=[[CLLocation alloc] initWithLatitude:lastAnn.coordinate.latitude longitude:lastAnn.coordinate.longitude];
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance (center,[startLocation distanceFromLocation:endLocation],[startLocation distanceFromLocation:endLocation]);
    return region;
}
+(CLLocationCoordinate2D)locationToBaidu:(CLLocationCoordinate2D)location{
    NSDictionary *baidudict = BMKConvertBaiduCoorFrom(location, BMK_COORDTYPE_COMMON);
    CLLocationCoordinate2D baiduCoordinate = BMKCoorDictionaryDecode(baidudict);
    return baiduCoordinate;
}
+(CLLocationCoordinate2D)gpsLocationToBaidu:(CLLocationCoordinate2D)location{
    NSDictionary *baidudict = BMKConvertBaiduCoorFrom(location, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D baiduCoordinate = BMKCoorDictionaryDecode(baidudict);
    return baiduCoordinate;
}
+(NSString*)removeFormatWithStr:(NSString*)str{
    NSString*curStr=str;
    NSString*rangeLeftStr=@"<";
    NSString*rangeRightStr=@">";
    
    NSRange rangeLeft =[curStr rangeOfString:rangeLeftStr];
    NSRange rangeRight=[curStr rangeOfString:rangeRightStr];
    
    while (rangeLeft.location!=NSNotFound&&rangeRight.location!=NSNotFound&&rangeRight.location>rangeLeft.location) {
        NSRange cutRange=NSMakeRange(rangeLeft.location, rangeRight.location-rangeLeft.location+1);
        curStr=[curStr stringByReplacingCharactersInRange:cutRange withString:@""];
        rangeLeft =[curStr rangeOfString:rangeLeftStr];
        rangeRight=[curStr rangeOfString:rangeRightStr];
    }
    curStr=[curStr stringByReplacingOccurrencesOfString:@"brt" withString:@"快速公交"];
   return curStr;
}
@end
@implementation MapCommView
+(UIButton*)getGoHereBtnWithFrame:(CGRect)frame andSel:(SEL)event{
    
    return nil;
}
+(UIButton*)getGoHereBtnWithFrame:(CGRect)frame andSelName:(NSString*)eventName{
    
    return nil;
}
+(UIView *)getGoHereViewWithTitle:(NSString *)title andSubTitle:(NSString *)subtitle andLocation:(CLLocationCoordinate2D)location andFrame:(CGRect)frame{
    float goHereViewHeigh=50.0f;
    UIView *goHereView=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-goHereViewHeigh, frame.size.width, goHereViewHeigh)];
    goHereView.tag=990;
    [goHereView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
    UILabel*titleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, goHereView.width-110, 20)];
    [titleLable setCenterY:goHereView.height/3];
    [titleLable setFont:[UIFont systemFontOfSize:12]];
    titleLable.textAlignment=NSTextAlignmentLeft;
    titleLable.textColor=titleLableColor;
    titleLable.numberOfLines=1;

    titleLable.text=title;
    UILabel*addressLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, goHereView.width-110, 20)];
    [addressLable setFont:[UIFont systemFontOfSize:10]];
    [addressLable setCenterY:2*goHereViewHeigh/3];
    addressLable.textAlignment=NSTextAlignmentLeft;
    addressLable.textColor=subTitleLableColor;
    addressLable.numberOfLines=1;
    addressLable.text=subtitle;
    UIImageView*goHereImage=[[UIImageView alloc] initWithFrame:CGRectMake(goHereView.width-65, 13, 15, 15)];
    [goHereImage setCenterY:goHereView.height/2];
    [goHereImage setImage:[UIImage imageNamed:@"mylocalGo"]];
    UILabel*goHereLable=[[UILabel alloc] initWithFrame:CGRectMake(goHereView.width-50, 10, 50, 20)];
    [goHereLable setCenterY:goHereView.height/2];
    goHereLable.text=@"到这去";
    [goHereLable setFont:[UIFont systemFontOfSize:11]];
    [goHereLable setTextColor: titleLableColor];
    UIView*cutLineView=[[UIView alloc] initWithFrame:CGRectMake(goHereView.width-85, 3, 0.5, 30)];
    cutLineView.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
    [cutLineView setCenterY:goHereView.height/2];
    [goHereView addSubview:cutLineView];
    [goHereView addSubview:goHereLable];
    [goHereView addSubview:goHereImage];
    [goHereView addSubview:titleLable];
    [goHereView addSubview:addressLable];
    return goHereView;

}
@end
@implementation CustomMapLocation

+(CustomMapLocation *)customLocationMake:(float)lat andLon:(float)lon{
    CustomMapLocation*curMapLocation=[[CustomMapLocation alloc] init];
    curMapLocation.location=CLLocationCoordinate2DMake(lat, lon);
    return curMapLocation;
}
+(CustomMapLocation*)customLocationMakeWithCLL:(CLLocationCoordinate2D)cllLocation{
    CustomMapLocation*curMapLocation=[[CustomMapLocation alloc] init];
    curMapLocation.location=cllLocation;
    return curMapLocation;
}
+(instancetype)customLocationMakeWithGoogleLoc:(CLLocationCoordinate2D)cllLocation{
    CustomMapLocation*curMapLocation=[[CustomMapLocation alloc] init];
    curMapLocation.location=[MapCommUtility locationToBaidu:cllLocation];
    return curMapLocation;
}
+(instancetype)customLocationMakeWithGPSLoc:(CLLocationCoordinate2D)cllLocation{
    CustomMapLocation*curMapLocation=[[CustomMapLocation alloc] init];
    curMapLocation.location=[MapCommUtility gpsLocationToBaidu:cllLocation];
    return curMapLocation;
}
@end