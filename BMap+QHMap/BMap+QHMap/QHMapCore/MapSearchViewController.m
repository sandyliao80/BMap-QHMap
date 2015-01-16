//
//  MapSearchViewController.m
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "MapSearchViewController.h"
#import "BusInfoCell.h"
#import "ShowLineViewController.h"
#import "MSUtil.h"
#import "ListNoResultCell.h"
#import "ChooseLocationViewController.h"
#define btnPosition 70
#define btnHeigh 40

#define searchImageTag  234324
typedef enum {
    mapNoResult=0,
    mapNone=1,
    mapBadNetWork=2,
    mapBadService=3
}Maptype;

@interface MapSearchViewController ()<BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    UILabel* startLable;
    UILabel*  endLable;
    NSArray*chooseImage;
    NSArray*unchooseImage;
    NSMutableArray*images;
    NSMutableArray*downLineView;
    UIImageView*searchPosImg;
    UIButton*chooseBtn;
    UIView*topView;
    UIButton*changePosBtn;

    BOOL firstIn;
    Maptype maptype;
    searchType mySearchType;
    BMKRouteSearch*routeSearch;
    NSMutableArray*routeInfo;
    NSMutableArray*turnInfo;
    NSArray*turnImage;
    BMKGeoCodeSearch* geocodesearch;
    NSString *city;
    BMKLocationService* locService;
  
    
}
@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    maptype=mapNone;
    mySearchType=searchBus;
    [self initView];
    [self initLocation];
    routeSearch=[[BMKRouteSearch alloc] init];
    routeSearch.delegate=self;
    
    //当用户在地图中选择了起始位置会受到这个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocation:) name:@"USERLOCATIONCHANGED" object:nil];
    
    turnImage=@[@"walk_turn_littleLeft",
                @"walk_turn_littleLeft",
                @"walk_turn_littleRight",
                @"walk_turn_littleRight",
                @"walk_turn_left",
                @"walk_turn_right",
                @"walk_turn_back",
                @"walk_turn_go",
                @"walk_turn_go",
                @"walk_turn_go",
                @"walk_turn_default"
                ];
    
}
#pragma mark init
- (void)initLocation
{
    [self cusShowLoaingView];
    locService=[[BMKLocationService alloc] init];
    locService.delegate=self;
    [locService startUserLocationService];
    CustomMapLocation*desLocation=self.info[@"location"];
    self->destinationCoordinate  =[MapCommUtility locationToBaidu:desLocation.location];
}

#pragma mark Events
//收到用户在地图上选择了新的起点通知event
-(void)reloadLocation:(NSNotification*) notification
{
    routeSearch.delegate=self;
    geocodesearch.delegate=self;
    locService.delegate=self;
    NSDictionary*curLocationInfo=notification.object;
    CustomMapLocation*curCusLoc=curLocationInfo[@"location"];
    if (curLocationInfo[@"city"]!=nil) {
        city=curLocationInfo[@"city"];
    }
    if (searchPosImg.tag==searchImageTag) {
        self->startCoordinate =curCusLoc.location;
        startLable.text=curLocationInfo[@"locationTitle"];
    }else{
        self->destinationCoordinate=curCusLoc.location;
        endLable.text=curLocationInfo[@"locationTitle"];;
    }
    [self beginSearch];
}
-(void)getLocation{
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate=self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self->startCoordinate;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];

    if(flag){
        NSLog(@"反geo检索发送成功");
    }
    else{
        NSLog(@"反geo检索发送失败");
        [self cusHideLoaingView];
        maptype=mapBadService;
        [self.dataTableView reloadData];
    }

}
//点击我的位置和目标位置切换按钮做的事情
-(void)changePos {
    CLLocationCoordinate2D curLocation=self->startCoordinate ;
    self->startCoordinate=self->destinationCoordinate;
    self->destinationCoordinate =curLocation;
    
    NSString *curTitleString=startLable.text;
    startLable.text=endLable.text;
    endLable.text=curTitleString;
    
    [self.dataTableView reloadData];
    
    if (searchPosImg.tag==searchImageTag) {
        searchPosImg.tag=searchImageTag-1;
        [searchPosImg setFrame:CGRectMake(searchPosImg.frame.origin.x, searchPosImg.frame.origin.y+30, searchPosImg.frame.size.width, searchPosImg.frame.size.height)];
        
        [chooseBtn setFrame:CGRectMake(chooseBtn.frame.origin.x, chooseBtn.frame.origin.y+30, chooseBtn.frame.size.width, chooseBtn.frame.size.height)];
    } else {
        searchPosImg.tag=searchImageTag;
        [searchPosImg setFrame:CGRectMake(searchPosImg.frame.origin.x, searchPosImg.frame.origin.y-30, searchPosImg.frame.size.width, searchPosImg.frame.size.height)];
        
        [chooseBtn setFrame:CGRectMake(chooseBtn.frame.origin.x, chooseBtn.frame.origin.y-30, chooseBtn.frame.size.width, chooseBtn.frame.size.height)];
    }
    
    [self beginSearch];
}
//点击从地图上选择位置按钮event
-(void)chooseLocationInMap
{
    ChooseLocationViewController*chooseView=[[ChooseLocationViewController alloc] init];
    chooseView.startCoordinate=self->startCoordinate;
    [self.navigationController pushViewController:chooseView animated:YES];
}
//更换搜索类型event
-(void)changeSearch:(UIButton*)sender
{
    switch (sender.tag) {
        case 100:
            mySearchType=searchBus;
            break;
        case 101:
            mySearchType=searchWalk;
            break;
        case 102:
            mySearchType=searchCar;
            break;
        default:
            break;
    }
    for(int i=0;i<images.count;i++){
        if(i==sender.tag-100){
            UIImageView*cur_ImageView=images[i];
            [cur_ImageView setImage:[UIImage imageNamed:chooseImage[i]]];
            UIView*cur_lineView=downLineView[i];
            cur_lineView.backgroundColor= [UIColor colorWithRed:122/255.0f green:124/255.0f blue:128/255.0f alpha:1.0f];
        }
        else{
            UIImageView*cur_ImageView=images[i];
            [cur_ImageView setImage:[UIImage imageNamed:unchooseImage[i]]];
            
            UIView*cur_lineView=downLineView[i];
            cur_lineView.backgroundColor=[UIColor clearColor];
            
        }
    }
    

    [self beginSearch];
}

#pragma mark -
#pragma searchEvent

-(void)beginSearch{
    
    [self doReload];
    if (!firstIn) {
        [self cusShowLoaingView];
    }
    BMKPlanNode*start=[[BMKPlanNode alloc] init];
    BMKPlanNode*end=[[BMKPlanNode alloc] init];
    start.pt=startCoordinate;
    end.pt=destinationCoordinate;
    BOOL flag;
    switch (mySearchType) {
        case searchBus:{
            BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
            transitRouteSearchOption.city=city;
            transitRouteSearchOption.from = start;
            transitRouteSearchOption.to = end;
            flag = [routeSearch transitSearch:transitRouteSearchOption];
            
            break;
        }
        case searchWalk:{
            BMKWalkingRoutePlanOption*walkingRoutePlanOption=[[BMKWalkingRoutePlanOption alloc] init];
            walkingRoutePlanOption.from = start;
            walkingRoutePlanOption.to = end;
            flag = [routeSearch walkingSearch:walkingRoutePlanOption];
            break;
        }
        case searchCar:{
            BMKDrivingRoutePlanOption*drivingRouteSearchOption=[[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = start;
            drivingRouteSearchOption.to = end;
            flag = [routeSearch drivingSearch:drivingRouteSearchOption];
            break;
        }
        default:
            break;
    }
    
    if(flag){
        //搜索发起成功
        
    }else{
        //搜索发起失败
        [self cusHideLoaingView];
        maptype=mapBadService;
        routeInfo=[[NSMutableArray alloc] init];
        [self.dataTableView reloadData];
    }
    
}
#pragma mark -
#pragma searchDelegate
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
//todo
    if (userLocation.location!=nil) {
        self->startCoordinate =userLocation.location.coordinate;
    }
    
    [self getLocation];
    [locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    //todo
    self->startCoordinate =CLLocationCoordinate2DMake(31.2434191659 , 121.4813312057);
   [locService stopUserLocationService];
    [self getLocation];
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self cusHideLoaingView];
    if (error == BMK_SEARCH_NO_ERROR) {
        [self getBusResult:result];
    }else{;
        maptype=mapNoResult;
        [self.dataTableView reloadData];
    }
    
}
-(void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    [self cusHideLoaingView];
    if (error == BMK_SEARCH_NO_ERROR) {
        [self getWalkResult:result];
    }else{

        maptype=mapNoResult;
        [self.dataTableView reloadData];
    }
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    [self cusHideLoaingView];
    if (error == BMK_SEARCH_NO_ERROR) {
        [self getCarResult:result];
    }else{
        maptype=mapNoResult;
        [self.dataTableView reloadData];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self cusHideLoaingView];
    firstIn=NO;
    if (error == 0) {
        startLable.text = result.address;
        city=result.addressDetail.city;
        [self beginSearch];
    }else{
        startLable.text=@"定位失败";
        maptype=mapBadService;
        [self.dataTableView reloadData];
    }
}

#pragma mark -
#pragma mark searchData

-(void)getBusResult:(BMKTransitRouteResult*)result{
    
    routeInfo=[[NSMutableArray alloc] init];
    if (result.routes.count==0) {
        return ;
    }else{
        for(BMKTransitRouteLine* plan in result.routes){
            
            NSMutableArray*busStopNameArr=[[NSMutableArray alloc] init];
            int busStopCount=0;
            int distance=plan.distance;
            BMKTime*time=plan.duration;
            for (int i=0; i<plan.steps.count; i++) {
                BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
                
                
                if (transitStep.stepType==BMK_BUSLINE ||transitStep.stepType==BMK_SUBWAY) {
                    [busStopNameArr addObject:transitStep.vehicleInfo.title];
                    busStopCount+=transitStep.vehicleInfo.passStationNum;
                }
            }
            
            NSString*busStopName=[busStopNameArr componentsJoinedByString:@"-"];
            NSDictionary*curResult=@{@"busStopName":busStopName,
                                     @"busStopCount":[NSString stringWithFormat:@"%i",busStopCount],
                                     @"distance":[NSString stringWithFormat:@"%@",[MSUtil covertDistance:distance]],
                                     @"time":time,
                                     @"plan":plan
                                     };
            [routeInfo addObject:curResult];
        }
        
    }
    
    [self.dataTableView reloadData];
}
-(void)getWalkResult:(BMKWalkingRouteResult*)result{
    routeInfo=[[NSMutableArray alloc] init];
    BMKWalkingRouteLine* plan=result.routes[0];//现在只返回一条
    int distance=plan.distance;
    BMKTime*time=plan.duration;
    //int taxiPrice=result.taxiInfo.totalPrice;
    int taxiPrice=10+(distance/1000)*3;
    
    NSDictionary*curResult=@{@"title":[NSString stringWithFormat:@"%@  %@",[self getTime:time],[MSUtil covertDistance:distance]],
                             @"taxiPrice":[NSString stringWithFormat:@"打车约%i元",taxiPrice],
                             @"plan":plan
                             };
    [routeInfo addObject:curResult];
    turnInfo=[[NSMutableArray alloc] init];
    for (int i=0; i<plan.steps.count; i++){
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
        [turnInfo addObject:transitStep.entraceInstruction];
    }
    [self.dataTableView reloadData];
    
}

-(void)getCarResult:(BMKDrivingRouteResult*)result{
    routeInfo=[[NSMutableArray alloc] init];
    BMKDrivingRouteLine* plan=result.routes[0];//现在只返回一条
    int distance=plan.distance;
    BMKTime*time=plan.duration;
    //int taxiPrice=result.taxiInfo.totalPrice;
    /*todo   这里taxi都是0元 why*/
    int taxiPrice=10+(distance/1000)*3;
    NSDictionary*curResult=@{@"title":[NSString stringWithFormat:@"%@  %@",[self getTime:time],[MSUtil covertDistance:distance]],
                             @"taxiPrice":[NSString stringWithFormat:@"打车约%i元",taxiPrice],
                             @"plan":plan
                             };
    [routeInfo addObject:curResult];
   
    turnInfo=[[NSMutableArray alloc] init];
    for (int i=0; i<plan.steps.count; i++){
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        [turnInfo addObject:transitStep.entraceInstruction];
    }
    [self.dataTableView reloadData];
}

-(NSString*)getTime:(BMKTime*)bTime{
    NSString*timeTip=@"";
    if (bTime.dates) {
        timeTip=[NSString stringWithFormat:@"%i天",bTime.dates];
    }
    if (bTime.hours) {
        timeTip=[NSString stringWithFormat:@"%@%i小时",timeTip,bTime.hours];
    }
    if (bTime.minutes) {
        timeTip=[NSString stringWithFormat:@"%@%i分钟",timeTip,bTime.minutes];
    }
    return timeTip;
}

-(int)getTurnInfoWithStr:(NSString*)turnStr{


    NSArray*turnKey=@[@"靠左",@"左前",@"靠右",@"右前",@"左转",@"右转",@"调头",@"直行",@"直走",@"向前"];
    
    for(int i=0;i<turnKey.count;i++){
        if([turnStr rangeOfString:[turnKey objectAtIndex:i]].location !=NSNotFound){
            return i;
        }
    }
    return turnImage.count-1;
}
#pragma mark -
#pragma mark TableViewDelegate
-(void)doReload{
    maptype=mapNone;
    routeInfo=[[NSMutableArray alloc] init];
    turnInfo=[[NSMutableArray alloc] init];
    [self.dataTableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (maptype!=mapNone||indexPath.section!=0) {
        return;
    }else{
        
        
        NSDictionary*curRouteDic=[routeInfo objectAtIndex:indexPath.row];
        NSString*subTitle;
        NSString*title;
        if (mySearchType==searchBus) {
            subTitle=[self getSubTitle:curRouteDic];
            title=curRouteDic[@"busStopName"];
        }else{
            subTitle=curRouteDic[@"taxiPrice"];
            title=curRouteDic[@"title"];
        }
        ShowLineViewController*showLineView=[[ShowLineViewController alloc] init];
        showLineView.info=@{@"title":title,@"subTitle":subTitle,@"plan":curRouteDic[@"plan"]};
        showLineView.mySearchType=mySearchType;
        [self.navigationController pushViewController:showLineView animated:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (maptype==mapNone&&mySearchType!=searchBus) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (maptype==mapNone) {
        if (section==0) {
            return routeInfo.count;
        }else{
            return turnInfo.count;
        }
        
    }else{
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(maptype!=mapNone){
        return self.dataTableView.height;
    }else{
        if (indexPath.section==0) {
            return 70;
        }else{
            return 30;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (maptype!=mapNone) {
        
        ListNoResultCell *noResultCell =[tableView ListNoResultCell];
        noResultCell.width = screenWidth;
        if (maptype==mapNoResult) {
            [noResultCell setInfo:MapNoResult position:screenheight/4-50];
        }else if(maptype==mapBadNetWork){
            [noResultCell setInfo:MapBadNetWork position:screenheight/4-50];
        }else if(maptype==mapBadService){
            [noResultCell setInfo:MapBadService position:screenheight/4-50];
        }
        
        return noResultCell;
    }
    if (indexPath.section==0) {
        BusInfoCell *cell=[tableView BusInfoCell];
        NSDictionary*curRouteDic=[routeInfo objectAtIndex:indexPath.row];
        if (mySearchType==searchBus) {
            cell.title.text=curRouteDic[@"busStopName"];
            cell.subTitle.text=[self getSubTitle:curRouteDic];
            cell.lineView.hidden=NO;
        }
        if (mySearchType==searchCar||mySearchType==searchWalk) {
            if (indexPath.section==0) {
                cell.title.text=curRouteDic[@"title"];
                cell.subTitle.text=curRouteDic[@"taxiPrice"];
                cell.lineView.hidden=YES;
            }
            
        }
        
        return cell;
    }else{
        static NSString *cellWithIdentifier = @"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
        if(nil==cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1   reuseIdentifier:cellWithIdentifier];
        }
        
        cell.textLabel.text=[turnInfo objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.textLabel setTextColor:titleLableColor];
        //FIXME:UILineBreakModeWordWrap->NSLineBreakByWordWrapping 6.0废弃
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines=2;
        cell.imageView.image=[UIImage imageNamed:[turnImage objectAtIndex:[self getTurnInfoWithStr:[turnInfo objectAtIndex:indexPath.row]]]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1&&turnInfo.count>0) {
        return 30.0f;
    }
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.dataTableView.width, 30)];
    headView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel*headLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    [headLable setFont:[UIFont systemFontOfSize:14]];
    headLable.text=@"路线规划";
    [headLable setTextColor:titleLableColor];
    [headLable setCenterY:headView.height/2];
    [headView addSubview:headLable];
    if (section==1&&turnInfo.count>0) {
        return headView;
    }
    return nil;
}
-(NSString*)getSubTitle:(NSDictionary*)subInfo{
    NSMutableArray*subTitleArr=[[NSMutableArray alloc] init];
    [subTitleArr addObject:[NSString stringWithFormat:@"总站数:%@",subInfo[@"busStopCount"]]];
    [subTitleArr addObject:[NSString stringWithFormat:@"大约用时:%@",[self getTime:subInfo[@"time"]]]];
    [subTitleArr addObject:[NSString stringWithFormat:@"距离%@米",subInfo[@"distance"]]];
    NSString*subTitle=[subTitleArr componentsJoinedByString:@" | "];
    return subTitle;
}
//初始化视图和tableView
-(void)initView
{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    chooseImage=@[@"btnBus_choose",@"btnWalk_choose",@"btnCar_choose"];
    unchooseImage=@[@"btnBus_unchoose",@"btnWalk_unchoose",@"btnCar_unchoose"];
    
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 110)];
    NSArray*btnTitleArr=@[@"公交",@"步行",@"自驾"];
    startLable=[[UILabel alloc]initWithFrame:CGRectMake(35, 10, screenWidth-100, 30)];
    endLable=[[UILabel alloc]initWithFrame:CGRectMake(35, 45, screenWidth-100, 20)];
    chooseBtn=[[UIButton alloc]initWithFrame:CGRectMake(35, 10, screenWidth-50, 30)];
    [chooseBtn addTarget:nil action:@selector(chooseLocationInMap) forControlEvents:UIControlEventTouchUpInside];
    [startLable setFont:[UIFont systemFontOfSize:13]];
    [endLable setFont:[UIFont systemFontOfSize:12]];
    [startLable setTextColor:titleLableColor];
    [endLable setTextColor:subTitleLableColor];
    startLable.text= @"正在为您定位";
    endLable.text= self.info[@"address"];
    searchPosImg=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-70, 10, 40, 30)];
    [searchPosImg setImage:[UIImage imageNamed:@"searchPos"]];
    searchPosImg.tag=searchImageTag;
    changePosBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 70)];
    [changePosBtn addTarget:nil action:@selector(changePos) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*changePosImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 12, 22)];
    [changePosImage setImage:[UIImage imageNamed:@"changePos"]];
    topView.backgroundColor=[UIColor whiteColor];
    UIImageView*topPointImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 10, 52)];
    UIView*startToEndLineView=[[UIView alloc]initWithFrame:CGRectMake(35, 40, screenWidth-50, 0.5)];
    [startToEndLineView setBackgroundColor:[UIColor splitlineGray]];
    [topView addSubview:searchPosImg];
    [topView addSubview:startToEndLineView];
    [topPointImage setImage:[UIImage imageNamed:@"topPoint"]];
    //[topView addSubview:topPointImage];
    [topView addSubview:startLable];
    [topView addSubview:endLable];
    [topView addSubview:chooseBtn];
    [topView addSubview:changePosBtn];
    [topView addSubview:changePosImage];
    topView.layer.shadowColor=[UIColor blackColor].CGColor;
    topView.layer.shadowRadius=2.0f;
    [self.view addSubview:topView];
    
    
    images=[[NSMutableArray alloc]init];
    
    downLineView=[[NSMutableArray alloc]init];
    UIView*btnView=[[UIView alloc]initWithFrame:CGRectMake(0, btnPosition, screenWidth, btnHeigh)];
    for(int i=0;i<btnTitleArr.count;i++)
    {
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(i*(screenWidth/3), 0, screenWidth/3, 50)];
        btn.tag=i+100;
        [btn addTarget:self action:@selector(changeSearch:) forControlEvents:UIControlEventTouchUpInside];
        float positionX=screenWidth*(CGFloat)((2.0f*i+1.0f)/6.0f);
        UIImageView *cur_ImageView=[[UIImageView alloc]initWithFrame:CGRectMake(positionX- 20 , 0, 40,40)];
        //[btn setBackgroundColor:[UIColor blackColor]];
        UIView*lineView;
        if (i==0) {
            lineView=[[UIView alloc ]initWithFrame:CGRectMake(5, 37, screenWidth/3.0f-5, 3)];
            [cur_ImageView setImage:[UIImage imageNamed:chooseImage[i]]];
            lineView.backgroundColor=[UIColor colorWithRed:122/255.0f green:124/255.0f blue:128/255.0f alpha:1.0f];
            
        }
        else if (i==1){
            lineView=[[UIView alloc ]initWithFrame:CGRectMake(screenWidth/3.0f, 37, screenWidth/3.0f, 3)];
            [cur_ImageView setImage:[UIImage imageNamed:unchooseImage[i]]];
            lineView.backgroundColor=[UIColor clearColor];
            
        }
        else{
            lineView=[[UIView alloc ]initWithFrame:CGRectMake(2*screenWidth/3.0f, 37, screenWidth/3.0f-5, 3)];
            [cur_ImageView setImage:[UIImage imageNamed:unchooseImage[i]]];
            lineView.backgroundColor=[UIColor clearColor];
            
        }
        UIView*cutLineView=[[UIView alloc] initWithFrame:CGRectMake(i*screenWidth/3.0f, 5, 0.5, 30)];
        cutLineView.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
        
        cur_ImageView.contentMode=UIViewContentModeCenter;
        [cur_ImageView setBackgroundColor:[UIColor clearColor]];
        
        [images addObject:cur_ImageView];
        UIView*topLineView=[[UIView alloc]initWithFrame:CGRectMake(0, -0.5, screenWidth, 0.5)];
        [topLineView setBackgroundColor:[UIColor splitlineGray]];
        [btnView addSubview:btn];
        [btnView addSubview:topLineView];
        btnView.backgroundColor=[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
        
        [btnView addSubview:lineView];
        [downLineView addObject:lineView];
        [btnView addSubview:cur_ImageView];
        [btnView addSubview:cutLineView];
        
    }
    
    self.dataTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 184, screenWidth, screenheight-164)];
    
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.dataTableView setDelegate:self];
    [self.dataTableView setDataSource:self];
    self.dataTableView.backgroundColor=[UIColor whiteColor];

    [topView addSubview:btnView];
   
    [self.view addSubview:self.dataTableView];
    
}

-(void)back
{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    routeSearch.delegate=nil;
    geocodesearch.delegate=nil;
    locService.delegate=nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    routeSearch.delegate=self;
    geocodesearch.delegate=self;
    locService.delegate=self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc{
    routeSearch.delegate=nil;
    routeSearch=nil;
    geocodesearch.delegate=nil;
    geocodesearch=nil;
    locService.delegate=nil;
    locService=nil;
    NSLog(@"mapSearchView dealloc");
}
@end
