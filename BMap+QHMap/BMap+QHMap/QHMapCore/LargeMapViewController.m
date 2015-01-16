//
//  LargeMapViewController.m
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "LargeMapViewController.h"
#import "DDAnnotation.h"
#import "MapCommUtility.h"
#import "MapSearchViewController.h"

@interface LargeMapViewController()<BMKMapViewDelegate>

@end
@implementation LargeMapViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    self.navigationController.title=@"地址详情";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initMapView];
    [self setInfo];
}

-(void)back{
    mapView.delegate=nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initMapView{
    mapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenheight+22)];
    mapView.delegate=self;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(30, 120) animated:YES];
    [self.view addSubview:mapView];
}
-(void)setInfo{
    annotations=[[NSMutableArray alloc] init];
    for(LargeMapViewInfo*curInfo in self.info) {
        DDAnnotation * ann = [[DDAnnotation alloc] init];
        ann.customInfo=@{@"category":[NSString stringWithFormat:@"%i",curInfo.imagePackIndex]};
        if (curInfo.title) {
            ann.title=curInfo.title;
        }
        if (curInfo.address) {
            ann.subtitle=curInfo.address;
        }
#warning 如果你的坐标本来就是百度坐标系的则不需要转换 直接ann.coordinate=curInfo.location不然会有偏差
        ann.coordinate=[MapCommUtility locationToBaidu:curInfo.location];
        [annotations addObject:ann];
    }
    [mapView addAnnotations:annotations];
    [self setRegion];
    

}
-(NSString *) locationIcon:(NSString *) tagId{
    
    
    NSDictionary * tags = @{
                            @"1": @"ic_location_hotel",
                            @"2": @"ic_location_ticket",
                            @"3": @"ic_location_hotel",
                            @"5": @"ic_location_bar",
                            @"6": @"ic_location_music",
                            @"7": @"ic_location_stage",
                            @"8": @"ic_location_pic",
                            @"9": @"ic_location_food",
                            @"10":@"ic_location_bag",
                            @"11":@"ic_location_moive",
                            @"12":@"ic_lcoation_persons",
                            @"13":@"ic_location_basketball",
                            @"14":@"ic_location_leaf",
                            @"15":@"ic_location_shirt",
                            @"16":@"ic_location_hotel",
                            @"17":@"ic_location_ticket",
                            @"18":@"myLocation"
                            };
    return tags[tagId]?tags[tagId]:tags[@"1"];
}

-(void)setRegion{
    BMKCoordinateRegion region;
    region = [MapCommUtility regionForAnnotations:annotations];
    [mapView setRegion:region];
    [mapView regionThatFits:region];
}

-(void)showDefaultCallOut
{
    if(mapView.annotations.count!=0)
    {
        for( DDAnnotation * ann in mapView.annotations)
        {
            if( ![ann isKindOfClass:[BMKUserLocation class]]){
                if(![ann.title isEqualToString:@"我的位置"])
                {
                    [mapView selectAnnotation:ann animated:YES];
                    return;
                }
            }
        }
    }
}



//生成下方的[到这里去]的view
-(UIView*)getGoHereViewWithTitle:(NSString*)title andSubTitle:(NSString*)subtitle andLocation:(CLLocationCoordinate2D)location
{
    UIView*goHereView=[MapCommView getGoHereViewWithTitle:title andSubTitle:subtitle andLocation:location andFrame:self.view.frame];
    UIButton*goHereBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, goHereView.width, 40)];
    [goHereBtn.layer setBorderColor:[subTitleLableColor CGColor]];
    [goHereBtn addTarget:self action:@selector(junpToMapView) forControlEvents:UIControlEventTouchUpInside];
    [goHereView addSubview:goHereBtn];
    return goHereView;
}


#pragma mark-
#pragma MapViewDelegate
-(void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    [self showDefaultCallOut];
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[DDAnnotation class]]){
        DDAnnotation *ann=(DDAnnotation*)view.annotation;
        if(![ann.title isEqualToString:@"我的位置"]){//如果点击的不是自己的位置 callOut
            
            [self cleanGoHereView];
            curJumpInfo=@{@"location":[CustomMapLocation customLocationMakeWithCLL:ann.coordinate],@"title":ann.title,@"address":ann.subtitle!=nil?ann.subtitle:ann.title};
            
            [self.view addSubview:[self getGoHereViewWithTitle:ann.title andSubTitle:ann.subtitle!=nil?ann.subtitle:@"" andLocation:ann.coordinate]];
        }
    }
    
}
//取消选择callOut清除所有显示的‘去这里’view
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    [self cleanGoHereView];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mV viewForAnnotation:(id <BMKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        
        return nil;
    }
    
    BMKAnnotationView *annotationView = (BMKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:@"BMKAnnotationView"];
    if (!annotationView){
        
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BMKAnnotationView"];
    }
    
    DDAnnotation * ann = (DDAnnotation *) annotation;
    annotationView.image = [UIImage imageNamed: [self locationIcon:ann.customInfo[@"category"]]];
    annotationView.canShowCallout =YES;
    annotationView.annotation=ann;
    
    
    return annotationView;
}



#pragma mark Map Functions

//清除弹出的‘去这里’view 在用户点击了其他点显示其他view之前 或者用户点了空白地方调用

- (void)cleanGoHereView
{
    
    if ([self.view viewWithTag:990]) {
        [[self.view viewWithTag:990] removeFromSuperview];
    }
    
}


-(void)junpToMapView{
    MapSearchViewController *mapSearhView=[[MapSearchViewController alloc] init];
    mapSearhView.info=curJumpInfo;
    [self.navigationController pushViewController:mapSearhView animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
      mapView.delegate=nil;
}

-(void)dealloc{
    mapView.delegate=nil;
    mapView=nil;
    MSLog(@"LargeMapViewDealloc");
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end

@implementation LargeMapViewInfo

+ (instancetype)LargeMapViewInfoMakeWithTitle:(NSString *)title andAddress:(NSString *)address andLocation:(CLLocationCoordinate2D)location andImageIndex:(int)imageIndex {
    LargeMapViewInfo*largeMapViewInfo=[LargeMapViewInfo new];
    largeMapViewInfo.title=title;
    largeMapViewInfo.address=address;
    largeMapViewInfo.location=location;
    largeMapViewInfo.imagePackIndex=imageIndex;
    return largeMapViewInfo;
}

@end
