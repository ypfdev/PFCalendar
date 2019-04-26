//
//  PFCalendarManager.m
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import "PFCalendarManager.h"

@implementation PFCalendarManager
- (void)setCalenderScrollView:(PFCalendarSV *)calenderScrollView{
    _calenderScrollView = calenderScrollView;
    calenderScrollView.calendarView.eventSource = self.eventSource;

}
- (void)setEventSource:(id<PFCalendarEventSource>)eventSource{
    _eventSource = eventSource;
    self.calenderScrollView.calendarView.eventSource = self.eventSource;
   
}

- (void)goToDate:(NSDate *)date{
    [PFCalendarAppearance share].defaultDate = date;
    [self.calenderScrollView.calendarView reloadDefaultDate];
    [self.calenderScrollView.calendarView reloadAppearance];
//    if ([PFCalendarAppearance share].isShowSingleWeek) {
//        [self.calenderScrollView scrollToSingleWeek];
//    }
    
}
/// 重新加载外观和数据
- (void)reloadAppearanceAndData{
    [self.weekDayView reloadAppearance];
    [self.calenderScrollView.calendarView reloadAppearance];
}

- (void)showSingleWeek{
    [self.calenderScrollView scrollToSingleWeek];
}
- (void)showAllWeek{
    [self.calenderScrollView scrollToAllWeek];
}

///  前一页。上个月
- (void)loadPreviousPage{
    [self.calenderScrollView.calendarView loadPreviousPage];
}
///   下一页 下一个月

- (void)loadNextPage{
    [self.calenderScrollView.calendarView loadNextPage];
}
- (NSDate *)currentSelectedDate{
    return self.calenderScrollView.calendarView.currentDate;
}

@end
