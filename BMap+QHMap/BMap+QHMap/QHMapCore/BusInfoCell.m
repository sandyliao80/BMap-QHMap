//
//  BusInfoCell.m
//  AmapTest
//
//  Created by caomei on 14/11/14.
//  Copyright (c) 2014年 caomei. All rights reserved.
//

#import "BusInfoCell.h"

 
@implementation UITableView(BusInfoCell)
-(BusInfoCell*)BusInfoCell
{
    static NSString*CellIdentifier=@"BusInfoCell";
    BusInfoCell*Cell=(BusInfoCell*)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil==Cell)
    {
        UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];
        Cell = (BusInfoCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return Cell;
}
@end
@implementation BusInfoCell

-(void)setInfo:(NSDictionary *)info
{
    self.title.text=info[@"title"]!=nil?info[@"title"]:@"";
    self.subTitle.text=info[@"subTitle"]!=nil?info[@"subTitle"]:@"";

}
- (void)awakeFromNib {
    // Initialization code
    [_lineView setBackgroundColor:[UIColor splitlineGray]];
    [self.title setTextColor:titleLableColor];
    [self.subTitle setTextColor:subTitleLableColor];
}
-(CGFloat)getHeightWidthInfo:(NSDictionary*)info{
    [self setInfo:info];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height ;
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
