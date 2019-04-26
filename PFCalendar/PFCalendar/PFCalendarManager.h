//
//  PFCalendarManager.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCalendarSV.h"
#import "PFCalendarEventSource.h"
@interface PFCalendarManager : NSObject
@property (nonatomic,strong) PFCalendarSV *calenderScrollView;

@property (nonatomic,strong) PFCalendarWeekDayView *weekDayView;

@property (weak, nonatomic) id<PFCalendarEventSource> eventSource;

@property (nonatomic,strong,readonly) NSDate *currentSelectedDate;


///回到固定某天
- (void)goToDate:(NSDate *)date;

/// 重新加载外观
- (void)reloadAppearanceAndData;

///  前一页。上个月
- (void)loadPreviousPage;
///   下一页 下一个月

- (void)loadNextPage;
- (void)showSingleWeek;
- (void)showAllWeek;
@end
