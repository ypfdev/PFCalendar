//
//  PFCalendarSV.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCalendarContentView.h"
#import "PFCalendarWeekDayView.h"

@interface PFCalendarSV : UIScrollView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PFCalendarContentView *calendarView;
@property (nonatomic,strong) UIColor *bgColor;

- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;

@end

