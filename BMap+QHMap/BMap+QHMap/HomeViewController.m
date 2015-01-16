//
//  HomeViewController.m
//  BMap+QHMap
//
//  Created by imqiuhang on 15/1/16.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    #warning 在APPDelegate里面一定要将bmkMapManager设为全局的  每一个应用都需要单独设置key 到百度地图官网申请！！！
    
    #warning 一定要在自己的应用的info.plist里面加上这句：NSLocationWhenInUseUsageDescription 类型为string  设置YES不然无法定位！！！
    
    #warning 这里的坐标是谷歌坐标系的  如果你直接用的是百度坐标系的 请看LargeMapViewController.m里面的那个警告
    
    //你也可以传好几个目标点进去
    NSArray*info=@[[LargeMapViewInfo LargeMapViewInfoMakeWithTitle:@"九溪十八坞"
                                                        andAddress:@"西湖区九溪公交站"
                                                       andLocation:CLLocationCoordinate2DMake(30.2240510426, 120.124415001)
                                                     andImageIndex:12]];
    
    LargeMapViewController*largeMapView=[[LargeMapViewController alloc] init];
    largeMapView.info=info;
    [self.navigationController pushViewController:largeMapView animated:YES];
    
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
