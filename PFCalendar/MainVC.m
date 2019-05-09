//
//  MainVC.m
//  PFCalendar
//
//  Created by 原鹏飞 on 2016/12/26.
//  Copyright © 2016年 Galanz. All rights reserved.
//

#import "MainVC.h"
#import "PFCalendarManager.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface MainVC ()<PFCalendarEventSource>{
    NSMutableDictionary *eventsByDate;
}

@property (weak, nonatomic) IBOutlet UILabel *label;


@property (nonatomic,strong)PFCalendarManager *manager;


@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCalendar];
}


- (void)initCalendar {
    self.manager = [PFCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[PFCalendarWeekDayView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[PFCalendarSV alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame))];
    [self.view addSubview:self.manager.calenderScrollView];
    [self createRandomEvents];
    self.automaticallyAdjustsScrollViewInsets = false;
    //设置默认滑动选中
    //[PFCalendarAppearance share].defaultSelected = false;
    //设置显示单周时滑动默认选中星期几
    //[PFCalendarAppearance share].singWeekDefaultSelectedIndex = 2;
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

// 当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    self.label.text =  key;
    NSArray *events = eventsByDate[key];
    self.title = key;
    NSLog(@"%@",date);
    if (events.count>0) {
        
        //该日期有事件    tableView 加载数据
    }
}

- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month{
    NSLog(@"当前年份：%d,当前月份：%d", year, month);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createRandomEvents {
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
    [self.manager reloadAppearanceAndData];
}


- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return dateFormatter;
}


- (IBAction)changeColor:(id)sender {
     [PFCalendarAppearance share].calendarBgColor = RandColor;
     [PFCalendarAppearance share].weekDayBgColor = RandColor;
     [PFCalendarAppearance share].dayCircleColorSelected = RandColor;
     [PFCalendarAppearance share].dayCircleColorToday = RandColor;
     [PFCalendarAppearance share].dayBorderColorToday = RandColor;
     [PFCalendarAppearance share].dayDotColor = RandColor;
     [PFCalendarAppearance share].dayDotColor = RandColor;
    [PFCalendarAppearance share].lunarDayTextColor = RandColor;
    
    [self.manager reloadAppearanceAndData];
}


- (IBAction)goBackToday:(id)sender {
    [self.manager goToDate:[NSDate date]];
}


- (IBAction)allweek:(id)sender {
    [self.manager showAllWeek];
}


- (IBAction)singleweek:(id)sender {
    [self.manager showSingleWeek];
}


// 是否显示农历
- (IBAction)isShowLunar:(id)sender {
    [PFCalendarAppearance share].isShowLunarCalender = ![PFCalendarAppearance share].isShowLunarCalender;
    // 重新加载外观
    [self.manager reloadAppearanceAndData];
}

// 下个月
- (IBAction)nextMonth:(id)sender {
    [self.manager loadNextPage];
}

// 上个月
- (IBAction)previousMonth:(id)sender {
    [self.manager loadPreviousPage];
}


// 周一开始
- (IBAction)monday:(id)sender {
    [PFCalendarAppearance share].firstWeekday = 2;
    [self.manager reloadAppearanceAndData];
}

// 周日开始
- (IBAction)sunday:(id)sender {
    [PFCalendarAppearance share].firstWeekday = 1;

    [self.manager reloadAppearanceAndData];
}

// 日格式：星期几
- (IBAction)full:(id)sender {
    [PFCalendarAppearance share].weekDayFormat = PFCalendarWeekDayFormatFull;
    [self.manager.weekDayView reloadAppearance];
}

// 日格式：周几
- (IBAction)fullShort:(id)sender {
    [PFCalendarAppearance share].weekDayFormat = PFCalendarWeekDayFormatShort;
    [self.manager.weekDayView reloadAppearance];
}

// 日格式：几
- (IBAction)single:(id)sender {
    [PFCalendarAppearance share].weekDayFormat = PFCalendarWeekDayFormatSingle;
    [self.manager.weekDayView reloadAppearance];
}

@end
