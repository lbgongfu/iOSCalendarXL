//
//  RemindCell2.m
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/6.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

#import "RemindCell2.h"
#import "TXSakuraKit.h"

@implementation RemindCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewArrow.sakura.tintColor(@"accentColor");
    UIImage *image = [UIImage imageNamed:@"next"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageViewArrow.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
