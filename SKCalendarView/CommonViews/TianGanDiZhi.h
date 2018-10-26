//
//  TianGanDiZhi.h
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/27.
//  Copyright © 2018年 shevchenko. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface TianGanDiZhi : NSObject

@property (nonatomic, strong) NSArray *arrTian;
@property (nonatomic, strong) NSArray *arrDi;
@property (nonatomic, strong) NSArray *arrShengxiao;
@property (nonatomic, strong) NSMutableDictionary *tian;
@property (nonatomic, strong) NSMutableDictionary *di;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;

- (NSString *)getTiDiResult:(NSDate *)date;

@end
