//
//  PFCalendarEventSource.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//  点击有事件日期。。。

#import <Foundation/Foundation.h>
@class PFCalendarManager;

@protocol PFCalendarEventSource <NSObject>

/**
 该日期是否有事件
 @param date  NSDate
 @return BOOL
 */
@optional
- (BOOL)calendarHaveEventWithDate:(NSDate *)date;
- (UIColor *)calendarHaveEventDotColorWithDate:(NSDate *)date;

/**
 点击 日期后的执行的操作
 @param date 选中的日期
 */
- (void)calendarDidSelectedDate:(NSDate *)date;

//获取当前滑动的年月
- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month;
/**
 翻页完成后的操作

 */
- (void)calendarDidLoadPageCurrentDate:(NSDate *)date;

@end
