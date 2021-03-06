//
//  wnlViewController.m
//  SKCalendarView
//
//  Created by tangming on 2018/8/2.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

#import "wnlViewController.h"
#import "SKConstant.h"
#import "SKCalendarView-Swift.h"
#import "RemindCell2.h"
#import "TXSakuraKit.h"
#import "../CommonViews/TianGanDiZhi.h"
#import <ActionSheetPicker.h>
#import "../LunarCore/LunarCore.h"

@interface wnlViewController () <SKCalendarViewDelegate>
//@property (nonatomic, strong) SKCalendarView * calendarView;
//@property (nonatomic, strong) UIView * lunarView;
//@property (nonatomic, strong) UIButton * nextButton;
//@property (nonatomic, strong) UIButton * lastButton;
//@property (nonatomic, strong) UILabel * chineseYearLabel;// 农历年
//@property (nonatomic, strong) UILabel * chineseMonthAndDayLabel;
//@property (nonatomic, strong) UILabel * yearLabel;// 公历年
//@property (nonatomic, strong) UILabel * dayLabel;// 公历年
//@property (nonatomic, strong) UILabel * holidayLabel;//节日&节气
@property (nonatomic, strong) UIButton * backToday;// 返回今天
@property (nonatomic, strong) TianGanDiZhi *tianGanDiZhi;

@property (nonatomic, assign) NSUInteger lastMonth;
@property (nonatomic, assign) NSUInteger nextMonth;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) RemindTableViewHelper* helper;
@property (weak, nonatomic) IBOutlet UIView *calendarViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;// 公立天
@property (weak, nonatomic) IBOutlet UILabel *chineseYearLabel;// 农历年
@property (weak, nonatomic) IBOutlet UILabel *chineseMonthAndDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayLabel;//节日&节气
@property (weak, nonatomic) IBOutlet UIView *holidayLabelContainer;
@property (weak, nonatomic) IBOutlet UIView *lunarView;
//@property (weak, nonatomic) IBOutlet UINavigationItem *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *yearLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRemind;//提醒列表
@property (weak, nonatomic) IBOutlet SKCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (nonatomic, assign) NSUInteger contentCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelSolarTerms;

@end

@implementation wnlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tianGanDiZhi = [TianGanDiZhi new];
    self.selectedDate = [NSDate date];
    
    self.navigationController.navigationBar.sakura.titleTextAttributes(@"navBarTitleColor");
    self.navigationController.navigationBar.sakura.tintColor(@"accentColor");
    
    self.dayLabel.sakura.textColor(@"accentColor");
    self.holidayLabel.sakura.textColor(@"accentColor");
    self.yearLabel.sakura.titleColor(@"accentColor", UIControlStateNormal);
    
    self.contentCellHeight = 340;
//    self.reminds = [[NSMutableArray alloc] init];
    self.helper = [RemindTableViewHelper new];
    self.helper.controller = self;
    self.tableViewRemind.dataSource = self.helper;
    self.tableViewRemind.delegate = self.helper;
    UINib *nib = [UINib nibWithNibName:@"RemindCell2" bundle:nil];
    [self.tableViewRemind registerNib:nib forCellReuseIdentifier:@"remindCell"];
//    [self.view addSubview:self.calendarView];
//    [self.view addSubview:self.lunarView];
    
    [self setupCalendarView];
    [self setuplunarView];
    
//    // 查看下个月
//    self.nextButton = [UIButton new];
//    [self.view addSubview:self.nextButton];
//    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
//    [self.nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.calendarView.mas_top).with.offset(-30);
//        make.right.equalTo(self.calendarView.mas_right).with.offset(-10);
//    }];
//    [self.nextButton addTarget:self action:@selector(checkNextMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.title = [NSString stringWithFormat:@"%@月", @(self.nextMonth)];
//    
//    // 查看上个月
//    self.lastButton = [UIButton new];
//    [self.view addSubview:self.lastButton];
//    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
//    [self.lastButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.calendarView.mas_top).with.offset(-30);
//        make.left.equalTo(self.calendarView.mas_left).with.offset(10);
//    }];
//    [self.lastButton addTarget:self action:@selector(checkLastMonthCalendar) forControlEvents:UIControlEventTouchUpInside];
    self.lastButton.title = [NSString stringWithFormat:@"%@月", @(self.lastMonth)];
    
//    
//    // 公历年
//    self.yearLabel = [UILabel new];
//    [self.view addSubview:self.yearLabel];
//    self.yearLabel.font = [UIFont systemFontOfSize:18];
//    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];
//    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.calendarView.mas_top).with.offset(-25);
//        make.centerX.equalTo(self.calendarView);
//    }];
//    printf("%s", [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)]);
    [self.yearLabel setTitle:[NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)] forState:UIControlStateNormal];
    // 公历日
//    self.dayLabel = [UILabel new];
//    [self.lunarView addSubview:self.dayLabel];
//    self.dayLabel.textColor = [UIColor colorWithRed:255/255.0 green:103/255.0 blue:0/255.0 alpha:1];
//    self.dayLabel.font = [UIFont systemFontOfSize:35];
    self.dayLabel.text = [NSString stringWithFormat:@"%@", self.calendarView.gongcalendarDate[self.calendarView.todayInMonth]];
//    self.dayLabel.textAlignment = NSTextAlignmentCenter;
//    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.calendarView.mas_bottom).with.offset(50);
//        make.centerX.equalTo(self.calendarView.mas_left).with.offset(50);
//    }];
    
    // 农历月日
//    self.chineseMonthAndDayLabel = [UILabel new];
//    [self.lunarView addSubview:self.chineseMonthAndDayLabel];
//    self.chineseMonthAndDayLabel.font = [UIFont systemFontOfSize:20];
    //self.chineseMonthAndDayLabel.textColor = [UIColor redColor];
    // 默认农历日期 今天
    self.chineseMonthAndDayLabel.text = [NSString stringWithFormat:@"农历%@%@", self.calendarView.chineseCalendarMonth[self.calendarView.todayInMonth - 1], getNoneNil(self.calendarView.chineseCalendarDay[self.calendarView.todayInMonth])];
//    self.chineseMonthAndDayLabel.textAlignment = NSTextAlignmentCenter;
//    [self.chineseMonthAndDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.calendarView.mas_bottom).with.offset(50);
//        make.centerX.equalTo(self.calendarView.mas_left).with.offset(170);
//    }];
    
    // 农历年
//    self.chineseYearLabel = [UILabel new];
//    [self.lunarView addSubview:self.chineseYearLabel];
//    self.chineseYearLabel.font = [UIFont systemFontOfSize:18];
//    self.chineseYearLabel.textColor = [UIColor grayColor];
//    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];
    self.chineseYearLabel.text = [self.tianGanDiZhi getTiDiResult:[NSDate new]];
//    self.chineseYearLabel.textAlignment = NSTextAlignmentCenter;
//    [self.chineseYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.chineseMonthAndDayLabel.mas_bottom).with.offset(5);
//        make.centerX.equalTo(self.chineseMonthAndDayLabel);
//    }];
    
    // 节日&节气
//    self.holidayLabel = [UILabel new];
//    [self.lunarView addSubview:self.holidayLabel];
//    self.holidayLabel.font = [UIFont systemFontOfSize:20];
//    self.holidayLabel.textColor = [UIColor purpleColor];
//    self.holidayLabel.textAlignment = NSTextAlignmentCenter;
    // 获取节日，注意：此处传入的参数为chineseCalendarDay(包含不节日等信息)
    NSString *str = [self.calendarView getHolidayAndSolarTermsWithChineseDay:getNoneNil(self.calendarView.chineseCalendarDay[self.calendarView.todayInMonth])];
    if ([CalendarUtil isJieQiWithStr:str]) {
        self.holidayLabel.text = str;
        self.holidayLabelContainer.hidden = false;
    } else {
        self.holidayLabel.text = @"";
        self.holidayLabelContainer.hidden = true;
    }
//    [self.holidayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.top.equalTo(self.chineseMonthAndDayLabel.mas_left);
//        //        make.centerX.equalTo(self.chineseMonthAndDayLabel);
//        make.top.equalTo(self.calendarView.mas_bottom).with.offset(50);
//        make.centerX.equalTo(self.calendarView.mas_left).with.offset(300);
//    }];
    
    // 返回今天
    //    self.backToday = [UIButton new];
    //    [self.view addSubview:self.backToday];
    //    [self.backToday setTitle:@"返回今天" forState:UIControlStateNormal];
    //    [self.backToday setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    //    [self.backToday mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.calendarView.mas_bottom).with.offset(30);
    //        make.centerX.equalTo(self.calendarView);
    //    }];
    //    [self.backToday addTarget:self action:@selector(clickBackToday) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.contentCellHeight;
    return self.tableView.frame.size.height - 114;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"editRemind"]) {
        CreateRemindViewController *controller = (CreateRemindViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        controller.remind = (Remind *)sender;
    }
}

- (void)viewDidAppear:(BOOL)animated {
//    NSArray<Remind *> *list = [RemindViewController getRemindList];
//    if (list.count == 0) {
//        self.contentCellHeight = 340;
//    } else {
//        self.contentCellHeight = 340 + 70;
//        self.helper.reminds = list;
//    }
//    [self.tableView reloadData];
//    [self.tableViewRemind reloadData];
//
    [super viewDidAppear:animated];
    [self updateRemindList:self.selectedDate];
    [self.calendarView checkCalendarWithAppointDate:self.selectedDate];
    [self.calendarView returnToToday];
    [self clickBackToday];
}

- (void)updateRemindList:(NSDate *)date {
    NSMutableArray<Remind *> *reminds = [[NSMutableArray<Remind *> alloc] init];
    NSArray<Remind *> *list = [RemindDataBase list];
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [c components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger weekday = components.weekday;
    NSLog(@"selected date: %ld %ld %ld", components.year, components.month, components.day);
    for (NSInteger i = 0; i < list.count; i++) {
        Remind *remind = [list objectAtIndex:i];
        
        NSDateComponents *components1 = [c components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:remind.date];
        NSInteger year1 = components1.year;
        NSInteger month1 = components1.month;
        NSInteger day1 = components1.day;
        NSInteger weekday1 = components1.weekday;
        NSLog(@"remind date: %ld %ld %ld %ld", components1.year, components1.month, components1.day, components1.weekday);
        
        BOOL shouldBeAdded = false;
        switch (remind.repeatType) {
            case RemindRepeatTypeNorepeat:
                if (year == year1 && month == month1 && day == day1) {
                    shouldBeAdded = true;
                }
                break;
            case RemindRepeatTypeRepeatPerYear:
                if (month == month1 && day == day1) {
                    if (year >= year1) {
                        shouldBeAdded = true;
                    }
                }
                break;
            case RemindRepeatTypeRepeatPerMonth:
                if (day == day1) {
                    if (year > year1) {
                        shouldBeAdded = true;
                    }
                    if (year == year1 && month >= month1) {
                        shouldBeAdded = true;
                    }
                }
                break;
            case RemindRepeatTypeRepeatPerWeek:
                if (weekday == weekday1) {
                    if (year > year1) {
                        shouldBeAdded = true;
                    }
                    if (year == year1) {
                        if (month > month1) {
                            shouldBeAdded = true;
                        }
                        if (month == month1 && day >= day1) {
                            shouldBeAdded = true;
                        }
                    }
                }
                break;
            case RemindRepeatTypeRepeatPerDay:
                if (year > year1) {
                    shouldBeAdded = true;
                }
                if (year == year1) {
                    if (month > month1) {
                        shouldBeAdded = true;
                    }
                    if (month == month1 && day >= day1) {
                        shouldBeAdded = true;
                    }
                }
                break;
        }
//        if (components.month == components1.month && components.day == components1.day) {
//            if (components.year == components1.year || (remind.repeatType == RemindRepeatTypeRepeatPerDay)) {
//                [reminds addObject:remind];
//            }
//        }
        if (shouldBeAdded) {
            [reminds addObject:remind];
        }
    }
    if (reminds.count == 0) {
        self.contentCellHeight = 340;
    } else {
        self.contentCellHeight = 340 + 70;
    }
    self.helper.reminds = reminds;
    [self.tableView reloadData];
    [self.tableViewRemind reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setuplunarView {
    _lunarView.layer.borderColor = [UIColor blackColor].CGColor;
    _lunarView.layer.borderWidth =0.1;
    //view添加阴影
    _lunarView.layer.masksToBounds = NO;
    _lunarView.layer.shadowColor = [UIColor blackColor].CGColor;
    _lunarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _lunarView.layer.shadowOpacity = 0.1f;
}

#pragma mark - 添加显示农历的view
//- (UIView *)lunarView
//{
//    if (!_lunarView) {
//        _lunarView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 70)];
//        _lunarView.layer.borderColor = [UIColor blackColor].CGColor;
//        _lunarView.layer.borderWidth =0.1;
//        //view添加阴影
//        _lunarView.layer.masksToBounds = NO;
//        _lunarView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _lunarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//        _lunarView.layer.shadowOpacity = 0.1f;
//
//    }
//
//    return _lunarView;
//}
- (void)setupCalendarView {
    //view添加阴影
    _calendarView.layer.masksToBounds = NO;
    _calendarView.layer.shadowColor = [UIColor blackColor].CGColor;
    _calendarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _calendarView.layer.shadowOpacity = 0.1f;
    
    _calendarView.delegate = self;// 获取点击日期的方法，一定要遵循协议
    _calendarView.calendarTodayTitleColor = [UIColor whiteColor];// 今天标题字体颜色
    _calendarView.calendarTodayTitle = @"今日";// 今天下标题
//    _calendarView.dateColor = [TXSakuraManager tx_colorWithPath:@"accentColor"];// 今天日期数字背景颜色
    _calendarView.calendarTodayColor = [UIColor whiteColor];// 今天日期字体颜色
    _calendarView.dayoffInWeekColor = [UIColor redColor];
    _calendarView.springColor = [UIColor colorWithRed:48 / 255.0 green:200 / 255.0 blue:104 / 255.0 alpha:1];// 春季节气颜色
    _calendarView.summerColor = [UIColor colorWithRed:18 / 255.0 green:96 / 255.0 blue:0 alpha:8];// 夏季节气颜色
    _calendarView.autumnColor = [UIColor colorWithRed:232 / 255.0 green:195 / 255.0 blue:0 / 255.0 alpha:1];// 秋季节气颜色
    _calendarView.winterColor = [UIColor colorWithRed:77 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1];// 冬季节气颜色
    _calendarView.holidayColor = [UIColor redColor];//节日字体颜色
    self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
    self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClick:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.calendarView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClick:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.calendarView addGestureRecognizer:swipeRight];
}

-(void)swipeClick:(UISwipeGestureRecognizer *)swipe{
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"swipe right");
        [self toLastMonth];
    } else if (swipe.direction==UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"swipe left");
        [self toNextMonth];
    }
}

#pragma mark - 日历设置
//- (SKCalendarView *)calendarView
//{
//    if (!_calendarView) {
//        _calendarView = [[SKCalendarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260)];
//        //_calendarView.layer.cornerRadius = 0;
//        //_calendarView.layer.borderColor = [UIColor blackColor].CGColor;
//        //_calendarView.layer.borderWidth = 0.1;
//        //view添加阴影
//        _calendarView.layer.masksToBounds = NO;
//        _calendarView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _calendarView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//        _calendarView.layer.shadowOpacity = 0.1f;
//
//        _calendarView.delegate = self;// 获取点击日期的方法，一定要遵循协议
//        _calendarView.calendarTodayTitleColor = [UIColor redColor];// 今天标题字体颜色
//        _calendarView.calendarTodayTitle = @"今日";// 今天下标题
//        _calendarView.dateColor = [UIColor orangeColor];// 今天日期数字背景颜色
//        _calendarView.calendarTodayColor = [UIColor whiteColor];// 今天日期字体颜色
//        _calendarView.dayoffInWeekColor = [UIColor redColor];
//        _calendarView.springColor = [UIColor colorWithRed:48 / 255.0 green:200 / 255.0 blue:104 / 255.0 alpha:1];// 春季节气颜色
//        _calendarView.summerColor = [UIColor colorWithRed:18 / 255.0 green:96 / 255.0 blue:0 alpha:8];// 夏季节气颜色
//        _calendarView.autumnColor = [UIColor colorWithRed:232 / 255.0 green:195 / 255.0 blue:0 / 255.0 alpha:1];// 秋季节气颜色
//        _calendarView.winterColor = [UIColor colorWithRed:77 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1];// 冬季节气颜色
//        _calendarView.holidayColor = [UIColor redColor];//节日字体颜色
//        self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
//        self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
//    }
//
//    return _calendarView;
//}
- (IBAction)checkNextMonthCalendar:(id)sender {
    [self toNextMonth];
    [self selectDateWithRow:self.calendarView.selectedRow];
}

- (void)toNextMonth {
    self.calendarView.checkNextMonth = YES;// 查看下月
    [self changeButton:self.nextButton isNext:YES];
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:YES];
    //    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
//    self.chineseYearLabel.text = [self.tianGanDiZhi getTiDiResult: self.selectedDate];
    [self.yearLabel setTitle:[NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)] forState:UIControlStateNormal];
    [self selectDateWithRow:self.calendarView.selectedRow];
}

- (IBAction)checkLastMonthCalendar:(id)sender {
    [self toLastMonth];
    [self selectDateWithRow:self.calendarView.selectedRow];
}

- (void)toLastMonth {
    self.calendarView.checkLastMonth = YES;// 查看上月
    [self changeButton:self.lastButton isNext:NO];
    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:NO];
    //    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
//    self.chineseYearLabel.text = [self.tianGanDiZhi getTiDiResult:[NSDate new]];
    [self.yearLabel setTitle:[NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)] forState:UIControlStateNormal];
    [self selectDateWithRow:self.calendarView.selectedRow];
}

#pragma mark - 查看上/下一月份日历
//- (void)checkNextMonthCalendar
//{
//    self.calendarView.checkNextMonth = YES;// 查看下月
//    [self changeButton:self.nextButton isNext:YES];
//    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:YES];
//    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
//    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
//}

//- (void)checkLastMonthCalendar
//{
//    self.calendarView.checkLastMonth = YES;// 查看上月
//    [self changeButton:self.lastButton isNext:NO];
//    [SKCalendarAnimationManage animationWithView:self.calendarView andEffect:SK_ANIMATION_REVEAL isNext:NO];
//    self.chineseYearLabel.text = [NSString stringWithFormat:@"%@年", self.calendarView.chineseYear];// 农历年
//    self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)];// 公历年
//}

// 改变上/下月按钮的月份
//- (void)changeButton:(UIButton *)button isNext:(BOOL)next
//{
//    if (next == YES) {
//        self.lastMonth = self.lastMonth + 1;
//        self.nextMonth = self.nextMonth + 1;
//        if (self.lastMonth > 12) {
//            self.lastMonth = 1;
//        }
//        if (self.nextMonth > 12) {
//            self.nextMonth = 1;
//        }
//    } else {
//        self.lastMonth = self.lastMonth - 1;
//        self.nextMonth = self.nextMonth - 1;
//        if (self.lastMonth < 1) {
//            self.lastMonth = 12;
//        }
//        if (self.nextMonth < 1) {
//            self.nextMonth = 12;
//        }
//    }
//    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
//    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
//}

- (void)changeButton:(UIBarButtonItem *)button isNext:(BOOL)next
{
    if (next == YES) {
        self.lastMonth = self.lastMonth + 1;
        self.nextMonth = self.nextMonth + 1;
        if (self.lastMonth > 12) {
            self.lastMonth = 1;
        }
        if (self.nextMonth > 12) {
            self.nextMonth = 1;
        }
    } else {
        self.lastMonth = self.lastMonth - 1;
        self.nextMonth = self.nextMonth - 1;
        if (self.lastMonth < 1) {
            self.lastMonth = 12;
        }
        if (self.nextMonth < 1) {
            self.nextMonth = 12;
        }
    }
    self.lastButton.title = [NSString stringWithFormat:@"%@月", @(self.lastMonth)];
    self.nextButton.title = [NSString stringWithFormat:@"%@月", @(self.nextMonth)];
}

- (IBAction)yearLabelClicked:(id)sender {
    NSDate *date = [NSDate date];
    void(^doneBlock)(ActionSheetDatePicker *picker, id selectedDate, id origin) = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSLog(@"selected date is: %@", selectedDate);
        [self.calendarView checkCalendarWithAppointDate:selectedDate];
        [self.yearLabel setTitle:[NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)] forState:UIControlStateNormal];
        self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
        self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
        
        self.lastButton.title = [NSString stringWithFormat:@"%@月", @(self.lastMonth)];
        self.nextButton.title = [NSString stringWithFormat:@"%@月", @(self.nextMonth)];
        
        NSString *str = [self.calendarView getHolidayAndSolarTermsWithChineseDay:getNoneNil(self.calendarView.chineseCalendarDay[self.calendarView.todayInMonth])];
        if ([CalendarUtil isJieQiWithStr:str]) {
            self.holidayLabel.text = str;
            self.holidayLabelContainer.hidden = false;
        } else {
            self.holidayLabel.text = @"";
            self.holidayLabelContainer.hidden = true;
        }
        
        [self selectDateWithRow:self.calendarView.selectedRow];
    };
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate doneBlock:doneBlock cancelBlock:nil origin:self.yearLabel];
    [picker showActionSheetPicker];
}

#pragma mark - 点击日期
- (void)selectDateWithRow:(NSUInteger)row
{
    NSLog(@"year: %d month: %d day %d", self.calendarView.year, self.calendarView.month, [self.calendarView.gongcalendarDate[row] integerValue]);
    
    NSInteger day = [self.calendarView.gongcalendarDate[row] integerValue];
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:self.calendarView.year];
    [comps setMonth:self.calendarView.month];
    [comps setDay:day];
    [comps setHour:12];
    [comps setMinute:0];
    [comps setSecond:0];
    self.selectedDate = [c dateFromComponents:comps];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@", self.calendarView.gongcalendarDate[row]];
    self.chineseMonthAndDayLabel.text = [NSString stringWithFormat:@"农历%@%@", self.calendarView.chineseCalendarMonth[row], getNoneNil(self.calendarView.chineseCalendarDay[row])];
    self.chineseYearLabel.text = [self.tianGanDiZhi getTiDiResult: self.selectedDate];
    // 获取节日，注意：此处传入的参数为chineseCalendarDay(不包含节日等信息)
    
    NSMutableDictionary *lunarDateDic = solarToLunar((int)self.calendarView.year, (int)self.calendarView.month, (int)day);
    NSString *term = [lunarDateDic objectForKey:@"term"];
    if ([@"" isEqualToString:term]) {
        self.holidayLabel.text = @"";
        self.holidayLabelContainer.hidden = true;
    } else {
        self.holidayLabel.text = term;
        self.holidayLabelContainer.hidden = false;
    }
    [self updateRemindList:self.selectedDate];
}

#pragma mark - 返回今日
- (void)clickBackToday
{
    [self.calendarView checkCalendarWithAppointDate:[NSDate date]];
    self.lastMonth = _calendarView.lastMonth;// 获取上个月的月份
    self.nextMonth = _calendarView.nextMonth;// 获取下个月的月份
//    [self.lastButton setTitle:[NSString stringWithFormat:@"%@月", @(self.lastMonth)] forState:UIControlStateNormal];
//    [self.nextButton setTitle:[NSString stringWithFormat:@"%@月", @(self.nextMonth)] forState:UIControlStateNormal];
    
    self.lastButton.title = [NSString stringWithFormat:@"%@月", @(self.lastMonth)];
    self.nextButton.title = [NSString stringWithFormat:@"%@月", @(self.nextMonth)];
    [self.yearLabel setTitle:[NSString stringWithFormat:@"%@年%@月", @(self.calendarView.year), @(self.calendarView.month)] forState:UIControlStateNormal];
}

@end

