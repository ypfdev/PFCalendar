//
//  PFCalendarWeekDayView.m
//  scrollTest
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import "PFCalendarWeekDayView.h"
#import "PFCalendarAppearance.h"

@implementation PFCalendarWeekDayView

static NSArray *cacheDaysOfWeeks;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
   [self commonInit];
    
    return self;
}



- (void)commonInit

{
    
    for(NSString *day in [self daysOfWeek]){
        UILabel *view = [UILabel new];
        
        view.font = [PFCalendarAppearance share].weekDayTextFont;
        view.textColor = [PFCalendarAppearance share].weekDayTextColor;
        
        view.textAlignment = NSTextAlignmentCenter;
        view.text = day;
        
        [self addSubview:view];
    }
}

- (NSArray *)daysOfWeek
{
    if(cacheDaysOfWeeks){
        return cacheDaysOfWeeks;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSMutableArray *days = nil;
    
    switch([PFCalendarAppearance share].weekDayFormat) {
        case PFCalendarWeekDayFormatSingle:
            days = [[dateFormatter veryShortStandaloneWeekdaySymbols] mutableCopy];
            break;
        case PFCalendarWeekDayFormatShort:
            days = [[dateFormatter shortStandaloneWeekdaySymbols] mutableCopy];
            break;
        case PFCalendarWeekDayFormatFull:
            days = [[dateFormatter standaloneWeekdaySymbols] mutableCopy];
            break;
    }
    
    for(NSInteger i = 0; i < days.count; ++i){
        NSString *day = days[i];
        [days replaceObjectAtIndex:i withObject:[day uppercaseString]];
    }
    
    // Redorder days for be conform to calendar
    {
        NSCalendar *calendar = [PFCalendarAppearance share].calendar;
        NSUInteger firstWeekday = (calendar.firstWeekday + 6) % 7; // Sunday == 1, Saturday == 7
        
        for(int i = 0; i < firstWeekday; ++i){
            id day = [days firstObject];
            [days removeObjectAtIndex:0];
            [days addObject:day];
        }
    }
    
    cacheDaysOfWeeks = days;
    return cacheDaysOfWeeks;
}

- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat width = self.frame.size.width / 7.;
    CGFloat height = self.frame.size.height;
    
   
        for(UIView *view in self.subviews){
            view.frame = CGRectMake(x, 0, width, height);
            x = CGRectGetMaxX(view.frame);
        }
    
    
    // No need to call [super layoutSubviews]
}

+ (void)beforeReloadAppearance
{
    cacheDaysOfWeeks = nil;
}

- (void)reloadAppearance
{
    for (UIView *view in self.subviews ) {
        [view removeFromSuperview];
        cacheDaysOfWeeks = nil;
        
    }
    [self commonInit];
    self.backgroundColor = [PFCalendarAppearance share].weekDayBgColor;
    for(int i = 0; i < self.subviews.count; ++i){
        UILabel *view = [self.subviews objectAtIndex:i];
        
        view.font = [PFCalendarAppearance share].weekDayTextFont;
        view.textColor = [PFCalendarAppearance share].weekDayTextColor;
        
        view.text = [[self daysOfWeek] objectAtIndex:i];
    }
}

@end
