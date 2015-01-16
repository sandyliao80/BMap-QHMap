//
//  ListNoResultCell.m
//  ticket
//
//  Created by ZQD on 14-1-17.
//  Copyright (c) 2014年 Mibang.Inc. All rights reserved.
//

#import "ListNoResultCell.h"
#import "MSUtil.h"
#import "MapCommUtility.h"
@implementation UITableView(ListNoResultCell)

-(ListNoResultCell*)ListNoResultCell{
    
    static NSString *CellIdentifier = @"List_NoResult_Cell";
	ListNoResultCell *cell = (ListNoResultCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell) {
		cell = [[ListNoResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [MSUtil colorWithHexString:@"#f8f8f8"];
        cell.backgroundView=[[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundView.backgroundColor = [MSUtil colorWithHexString:@"#f8f8f8"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
    
    return cell;
}


@end

@implementation ListNoResultCell
{
    NSDictionary*cityDic;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-13,10, 25, 25)];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,iconView.bottom+5, 150, 15)];
        
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = titleLableColor;
        //        self.backgroundColor = [UIColor redColor];
        [self addSubview:iconView];
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)setInfo:(NoresultType)type position:(float)top{
    iconView.top=top;
    titleLabel.top=iconView.bottom+5;
    [self setInfo:type];
}

-(void)setInfo:(NoresultType)type{
    NSString *icon;
    NSString *title;
    switch (type) {
        case MapNoResult:
            icon = @"ic_tip_noresult";
            title = @"暂时没有导航信息哦\n换其他的方式试试";
            break;
        case MapBadNetWork:
            icon = @"ic_tip_noresult";
            title = @"坑爹的网络出问题啦,稍后试试";
            break;
            
        default:
            icon = @"ic_tip_noresult";
            title = @"服务器出问题啦,稍后试试";
            break;
    }
    [iconView setImage:[UIImage imageNamed:icon]];
    titleLabel.text = title;
    [titleLabel setSize:CGSizeMake(titleLabel.width+10, titleLabel.height)];
    titleLabel.height=[MSUtil countHeightOfString:title WithWidth:150 Font:[UIFont systemFontOfSize:12]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.centerX=self.width/2;
    titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    titleLabel.numberOfLines=0;
    titleLabel.top=iconView.bottom+5;
    iconView.centerX = self.width/2;

  
    
}

@end
