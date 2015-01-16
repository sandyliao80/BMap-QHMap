//
//  ShowLineViewController.m
//  AmapTest
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "ShowLineViewController.h"
#import "DDAnnotation.h"
#import "CustomMapAnnView.h"
#import "DDAnnotation.h"
#define startStr                       @"起点"
#define endStr                         @"终点"
#define botomViewDownTag               999
#define botomViewTopTag                1000
#define mapLogoPoint                   CGPointMake(30, 10)
#define botomGestureViewDefaultCenterY       (screenheight+20-70)
#define topViewMaxMove                 (240-70)
@interface ShowLineViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>
{
    NSDictionary *curAnnInfo;
    UIView*botomView;
    UIImageView*showMoreImage;
    BMKMapView*mapView;
    NSMutableArray*planArr;
    NSMutableArray*annmations;
    UIView*notifiView;
    UIView*botomGestureView;
    CGPoint botomViewDefaultCenter;
    CGPoint beganGestureStatus;
}
@end

@implementation ShowLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenheight-44)];
    mapView.delegate=self;
    [self.view addSubview:mapView];
    
    [self initTableView];
    [self loadData];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    planArr=[[NSMutableArray alloc] init];
    annmations=[[NSMutableArray alloc] init];
    if (self.mySearchType==searchBus) {
        [self setBusAnn];
    }else if(self.mySearchType==searchWalk){
        [self setWalkAnn];
    }else{
        [self setCarAnn];
    }
}


-(void)setBusAnn{
        BMKTransitRouteLine* plan =self.info[@"plan"];
        int planPointCounts = 0;
        for (int i=0; i<plan.steps.count; i++) {
            if (i==0) {
                DDAnnotation*ann=[[DDAnnotation alloc] init];
                ann.coordinate=plan.starting.location;
                ann.title=startStr;
                ann.customInfo=@{@"image":@"pos_start"};
                [annmations addObject:ann];
            }
            if (i==plan.steps.count-1) {
                DDAnnotation*ann=[[DDAnnotation alloc] init];
                ann.coordinate=plan.terminal.location;
                ann.title=endStr;
                ann.customInfo=@{@"image":@"pos_end"};
                [annmations addObject:ann];
            }
            
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            [planArr addObject:[MapCommUtility removeFormatWithStr:transitStep.instruction]];
            if (transitStep.stepType==BMK_BUSLINE ||transitStep.stepType==BMK_SUBWAY) {
                DDAnnotation*ann=[[DDAnnotation alloc] init];
                ann.coordinate=transitStep.entrace.location;;
                ann.title=transitStep.vehicleInfo.title;
                ann.subtitle=[MapCommUtility removeFormatWithStr:transitStep.instruction];
                ann.customInfo=@{@"image":@"pos_bus"};
                [annmations addObject:ann];
            }else{
                DDAnnotation*ann=[[DDAnnotation alloc] init];
                ann.title=[MapCommUtility removeFormatWithStr:transitStep.instruction];
                ann.coordinate=transitStep.entrace.location;;
                ann.customInfo=@{@"image":@"pos_walk"};
                [annmations addObject:ann];
            }
             planPointCounts += transitStep.pointsCount;
        }
    BMKMapPoint  temppoints[planPointCounts];
    int i = 0;
    for (int j = 0; j < plan.steps.count; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [mapView addOverlay:polyLine];
    
    [mapView addAnnotations:annmations];
    BMKCoordinateRegion region;
    region = [MapCommUtility regionForAnnotations:mapView.annotations];
    [mapView setRegion:region];
    [mapView regionThatFits:region];
    [self.dataTableView reloadData];
    
}

-(void)setWalkAnn{
    BMKWalkingRouteLine* plan =self.info[@"plan"];
    int planPointCounts = 0;
    for (int i=0; i<plan.steps.count; i++) {
        if (i==0) {
            DDAnnotation*ann=[[DDAnnotation alloc] init];
            ann.coordinate=plan.starting.location;
            ann.title=startStr;
            ann.customInfo=@{@"image":@"pos_start"};
            [annmations addObject:ann];
        }

        
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
        [planArr addObject:[MapCommUtility removeFormatWithStr:transitStep.instruction]];
        
            DDAnnotation*ann=[[DDAnnotation alloc] init];
            ann.title=[MapCommUtility removeFormatWithStr:transitStep.instruction];
            ann.coordinate=transitStep.entrace.location;;
            ann.customInfo=@{@"image":@"pos_walk_small"};
            [annmations addObject:ann];
        
        if (i==plan.steps.count-1) {
            DDAnnotation*ann=[[DDAnnotation alloc] init];
            ann.coordinate=plan.terminal.location;
            ann.title=endStr;
            ann.customInfo=@{@"image":@"pos_end"};
            [annmations addObject:ann];
        }
        planPointCounts += transitStep.pointsCount;
        
    }
    BMKMapPoint  temppoints[planPointCounts];
    int i = 0;
    for (int j = 0; j < plan.steps.count; j++) {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [mapView addOverlay:polyLine];
    
    [mapView addAnnotations:annmations];
    BMKCoordinateRegion region;
    
    region = [MapCommUtility regionForCarAnnotations:annmations];

    [mapView setRegion:region];
    [mapView regionThatFits:region];
    [self.dataTableView reloadData];

}
-(void)setCarAnn{
    BMKDrivingRouteLine* plan =self.info[@"plan"];
    int planPointCounts = 0;
    for (int i=0; i<plan.steps.count; i++) {
        if (i==0) {
            DDAnnotation*ann=[[DDAnnotation alloc] init];
            ann.coordinate=plan.starting.location;
            ann.title=startStr;
            ann.customInfo=@{@"image":@"pos_start"};
            [annmations addObject:ann];
        }
        if (i==plan.steps.count-1) {
            DDAnnotation*ann=[[DDAnnotation alloc] init];
            ann.coordinate=plan.terminal.location;
            ann.title=endStr;
            ann.customInfo=@{@"image":@"pos_end"};
            [annmations addObject:ann];
        }
        
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        [planArr addObject:[MapCommUtility removeFormatWithStr:transitStep.instruction]];
        
        DDAnnotation*ann=[[DDAnnotation alloc] init];
        ann.title=[MapCommUtility removeFormatWithStr:transitStep.instruction];
        ann.coordinate=transitStep.entrace.location;;
        ann.customInfo=@{@"image":@"pos_car_small"};
        [annmations addObject:ann];
        planPointCounts += transitStep.pointsCount;
        
    }
    BMKMapPoint  temppoints[planPointCounts];
    int i = 0;
    for (int j = 0; j < plan.steps.count; j++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [mapView addOverlay:polyLine];
    
    [mapView addAnnotations:annmations];
    BMKCoordinateRegion region;
//   region = [MapCommUtility regionForAnnotations:mapView.annotations];
    region = [MapCommUtility regionForCarAnnotations:annmations];

    [mapView setRegion:region];
    [mapView regionThatFits:region];
    [self.dataTableView reloadData];
    

    
    
}
#pragma mark-
#pragma mapDelegate

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1.0f];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
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
    annotationView.image = [UIImage imageNamed:ann.customInfo[@"image"]];
    annotationView.canShowCallout =YES;
    
    
    return annotationView;
}



#pragma UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  planArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(nil==cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1   reuseIdentifier:CellWithIdentifier];
    }

    cell.textLabel.text=planArr[(int)indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.textLabel setTextColor:titleLableColor];
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines=2;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row+1<annmations.count) {
        [mapView selectAnnotation:[annmations objectAtIndex:indexPath.row+1] animated:YES];
        BMKCoordinateRegion region;
        NSArray*curAnnArr=@[[annmations objectAtIndex:indexPath.row+1]];
        region = [MapCommUtility regionForAnnotations:curAnnArr];
        [mapView setRegion:region];
        [mapView regionThatFits:region];
    
    }
}

#pragma mark initView


-(void)hideNotifiView{
    if (notifiView.height>0) {
        [UIView animateWithDuration:0.3f animations:^{
            [notifiView setHeight:0];
        }];
    }
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    
    CGPoint translation = [recognizer translationInView:self.view];
    if (botomView.center.y+translation.y<=botomViewDefaultCenter.y
         &&botomView.center.y+translation.y>=botomViewDefaultCenter.y-topViewMaxMove) {
        botomView.centerY+=translation.y;
        
    }
    if (botomViewDefaultCenter.y-botomView.center.y>topViewMaxMove/2){
        [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_down"]];
    }else{
        [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_top"]];
    }
    
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        beganGestureStatus=botomView.center;
    }
    
    if (recognizer.state== UIGestureRecognizerStateEnded) {
        if (beganGestureStatus.y+20>=botomViewDefaultCenter.y) {
            [self showBotomView];
            
        }else{
            [self hideBotomView];
        }
        
    }
 
    [recognizer setTranslation:CGPointZero inView:self.navigationController.view];
}
- (void) handleTap:(UITapGestureRecognizer*) recognizer{
    if (botomViewDefaultCenter.y-botomView.center.y<topViewMaxMove/2) {
        [self showBotomView];
    }else{
        [self hideBotomView];
    }
}

-(void)showBotomView{
     [self topViewRemoveGesture];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        botomView.centerY= botomViewDefaultCenter.y-topViewMaxMove;
    } completion:^(BOOL finished) {
        [self topViewAddGesture];
        [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_down"]];
        
        if (finished&&notifiView.tag==900) {
            [UIView animateWithDuration:0.3f animations:^{
                notifiView.tag=1000;
                [notifiView setHeight:30];
                [self performSelector:@selector(hideNotifiView) withObject:nil afterDelay:2];
                
            }];
        }

    }];

   

}
-(void)hideBotomView{
     [self topViewRemoveGesture];
    
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        botomView.centerY= botomViewDefaultCenter.y;
    } completion:^(BOOL finished) {
        [self topViewAddGesture];
        [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_down"]];
        
        if (finished&&notifiView.tag==900) {
            [UIView animateWithDuration:0.3f animations:^{
                [self topViewAddGesture];
                [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_top"]];
                
            }];
        }
        
    }];
}
-(void)initTableView
{
    botomView=[[UIView alloc] initWithFrame:CGRectMake(0, botomGestureViewDefaultCenterY, screenWidth, 240)];
    botomView.backgroundColor=[UIColor clearColor];
    botomView.tag=botomViewDownTag ;
    [botomView setAlpha:0.9f];
    botomViewDefaultCenter=botomView.center;
    
    botomGestureView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    UILabel*titleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, screenWidth-20, 20)];
    titleLable.text=self.info[@"title"];
    [titleLable setFont:[UIFont systemFontOfSize:14]];
    [titleLable setTextColor:titleLableColor];
    UILabel*subTitleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 40, screenWidth-20, 20)];
    subTitleLable.text=self.info[@"subTitle"];
    [subTitleLable setFont:[UIFont systemFontOfSize:12]];
    [subTitleLable setTextColor:subTitleLableColor];
    
    
    botomGestureView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [botomGestureView addSubview:titleLable];
    [botomGestureView addSubview:subTitleLable];
    [self topViewAddGesture];
    showMoreImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 20, 20)];
    [showMoreImage setImage:[UIImage imageNamed:@"ic_nav_top"]];
    [showMoreImage setCenterX:botomGestureView.width/2];
    [botomGestureView addSubview:showMoreImage];
    
       self.dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, 170)];
    [self.dataTableView setDelegate:self];
    [self.dataTableView setDataSource:self];
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [botomView addSubview:botomGestureView];
    [botomView addSubview:self.dataTableView];
    [self.view addSubview:botomView];
    notifiView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    notifiView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    notifiView.clipsToBounds=YES;
    notifiView.tag=900;
    UILabel*notifiLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenWidth, 20)];
    [notifiLable setFont:[UIFont systemFontOfSize:14]];
    notifiLable.textColor=[UIColor whiteColor];
    notifiLable.textAlignment=NSTextAlignmentCenter;
    notifiLable.text=@"点击具体步骤可以定位到地图上哦";
    [notifiView addSubview:notifiLable];
    [self.dataTableView addSubview:notifiView];

}
-(void)topViewAddGesture{
    [self topViewRemoveGesture];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    UITapGestureRecognizer*tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [botomGestureView addGestureRecognizer:tapGestureRecognizer];
    [botomGestureView addGestureRecognizer:panGestureRecognizer];
}
-(void)topViewRemoveGesture{
    for(UIGestureRecognizer *curGes in botomGestureView.gestureRecognizers){
        [botomGestureView removeGestureRecognizer:curGes];
    }
}
-(void)back{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    mapView.delegate=nil;
    mapView=nil;
}
-(void)dealloc{
    MSLog(@"showLineView dealloc");
    mapView.delegate=nil;
    mapView=nil;
}
@end
