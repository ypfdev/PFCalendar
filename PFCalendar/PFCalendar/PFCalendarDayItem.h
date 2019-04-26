//
//  PFCalendarDayItem.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface PFCalendarDayItem : NSObject
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL isOtherMonth;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,strong)UIColor *eventDotColor;
@property (nonatomic,assign)BOOL showEventDot;
@end
