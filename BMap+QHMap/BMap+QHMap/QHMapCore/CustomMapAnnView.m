//
//  CustomMapAnnView.m
//  weekend
//
//  Created by imqiuhang on 15/1/15.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "CustomMapAnnView.h"
#import "CustomCalloutView.h"

#define subheigh 60.0f
#define nosubHeigh 40.0f
@implementation CustomMapAnnView

-(void)rightBtnEvent{
    
    if ([self.delegate respondsToSelector:@selector(rightBtnClicked)]) {
        [self.delegate rightBtnClicked];
    }
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            
            CGSize subTitleSize = [self.subTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
            float rightBtnWidth=0.0f;
            
            float screenWidth=screenWidth = [[UIScreen mainScreen] bounds].size.width-80;
            
            
            float callWidth=titleSize.width>subTitleSize.width?titleSize.width:subTitleSize.width;
            callWidth=callWidth+40;
            float callHeigh=self.subTitle==nil?nosubHeigh:subheigh;
            
            callWidth=callWidth>screenWidth?screenWidth:callWidth;
            
            
            if (self.showRigthBtn) {
                callWidth=callWidth+40;
                rightBtnWidth=40.0f;
            }
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, callWidth, callHeigh)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            
            
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, callWidth-20-rightBtnWidth, 20)];
            
            titleLable.textColor=titleLableColor;
            [titleLable setFont:[UIFont systemFontOfSize:14]];
            titleLable.text=self.title;
            
            [self.calloutView addSubview:titleLable];
            
            if (self.subTitle) {
                UILabel *subtitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, callWidth-10-rightBtnWidth, 30)];
                subtitleLable.textColor=subTitleLableColor;
                [subtitleLable setFont:[UIFont systemFontOfSize:11]];
                subtitleLable.text=self.subTitle;
                [self.calloutView addSubview:subtitleLable];
            }
            if (self.showRigthBtn) {
                
                UIButton*rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.calloutView.width-40, 0, 40, self.calloutView.height-10)];
                UIView*lineView=[[UIView alloc] initWithFrame:CGRectMake(self.calloutView.width-40, 0, 0.5, self.calloutView.height-10)];
                lineView.backgroundColor=[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
                
                [self.calloutView addSubview:lineView];
                
                [rightBtn setImage:[UIImage imageNamed:@"mylocalGo"] forState:UIControlStateNormal];
                [rightBtn addTarget:nil action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
         
                [self.calloutView addSubview:rightBtn];
            }
            
            
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
        
    }
    
  [super setSelected:selected animated:animated];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
     
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //~自定义的相当于image的View
    }
    
    return self;
}







@end
