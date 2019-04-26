//
//  PFCalendarCLCell.m
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import "PFCalendarCLCell.h"
#import "PFCircleView.h"
#import "PFCalendarAppearance.h"
@interface PFCalendarCLCell(){
    UIView *backgroundView;
    PFCircleView *circleView;
    UILabel *textLabel;
    UILabel *lunarTextLabel;
    PFCircleView *dotView;
    int isToday;
    NSString *cacheCurrentDateText;
}

@end


@implementation PFCalendarCLCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
   
    backgroundView = [UIView new];
    [self addSubview:backgroundView];
    
    circleView = [PFCircleView new];
    [self addSubview:circleView];
    circleView.color = [UIColor clearColor];
    
    textLabel = [UILabel new];
    textLabel.font = [PFCalendarAppearance share].dayTextFont;
    
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    
    lunarTextLabel = [UILabel new];
    lunarTextLabel.font = [PFCalendarAppearance share].lunarDayTextFont;
    lunarTextLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lunarTextLabel];
    
    dotView = [PFCircleView new];
    [self addSubview:dotView];
    dotView.hidden = YES;
}

- (void)setItem:(PFCalendarDayItem *)item {
    _item = item;
    static NSArray *dayArray;
    static NSArray *monthArray;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        dayArray = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
        
        monthArray = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    });
    
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [PFCalendarAppearance share].calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    
    textLabel.text = [dateFormatter stringFromDate:item.date];
    
    //获取农历
#ifdef __IPHONE_8_0
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:item.date];
#else
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
#endif
    
    lunarTextLabel.text = dayArray[localeComp.day-1];
    if (localeComp.day-1 == 0) {
        lunarTextLabel.text = monthArray[localeComp.month-1];
    }
    
    isToday = -1;
    cacheCurrentDateText = nil;
    
    dotView.hidden = !item.showEventDot;
    dotView.color = item.eventDotColor;
    
    self.isSelected = item.isSelected;
    [self configureConstraintsForSubviews];
}

- (void)setIsSelected:(BOOL)isSelected{
    [self setSelected:isSelected animated:YES];
    self.item.isSelected = isSelected;
}

- (void)layoutSubviews {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [PFCalendarAppearance share].calendar.timeZone;
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
}

- (void)configureConstraintsForSubviews{
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, [PFCalendarAppearance share].dayTextFont.pointSize-4);
    
    lunarTextLabel.frame = CGRectMake(0, 0, self.frame.size.width, [PFCalendarAppearance share].lunarDayTextFont.pointSize);
    
    
    
    
    CGFloat sizeCircle = [PFCalendarAppearance share].dayCircleSize;
    
    CGFloat sizeDot = [PFCalendarAppearance share].dayDotSize;
    
    
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., circleView.center.y);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    circleView.layer.masksToBounds = YES;
    
    circleView.layer.borderWidth = 1;
    
    //是否显示农历
    
    if ([PFCalendarAppearance share].isShowLunarCalender) {
        lunarTextLabel.hidden =  NO;
        textLabel.center =  CGPointMake(circleView.center.x, circleView.center.y- CGRectGetHeight(textLabel.frame)/2);
        lunarTextLabel.center = CGPointMake(circleView.center.x, circleView.center.y + CGRectGetHeight(lunarTextLabel.frame)/2+2);
    }
    else{
        textLabel.center = circleView.center;
        
        lunarTextLabel.hidden = YES;
    }
    
    
    dotView.frame = CGRectMake(0, CGRectGetMaxY(circleView.frame)+1, sizeDot, sizeDot);
    dotView.center = CGPointMake(self.frame.size.width / 2., dotView.center.y );
    
    dotView.layer.cornerRadius = sizeDot / 2.;
    
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [PFCalendarAppearance share].calendar.timeZone;
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.item.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated{
    
    
    if(isSelected == self.item.isSelected){
        animated = NO;
        
    }
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    if(isSelected){
        if(!self.item.isOtherMonth || [PFCalendarAppearance share].isShowSingleWeek){
            circleView.color = [PFCalendarAppearance share].dayCircleColorSelected;
            circleView.layer.borderColor = [UIColor clearColor].CGColor;
            textLabel.textColor = [PFCalendarAppearance share].dayTextColorSelected;
            lunarTextLabel.textColor = [PFCalendarAppearance share].lunarDayTextColorSelected;
            
        }
        if ([self isToday]) {
             circleView.color = [PFCalendarAppearance share].dayCircleColorToday;
        }
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }else {
        circleView.color = [UIColor clearColor];
        if ([self isToday]){
            
            circleView.layer.borderColor = [PFCalendarAppearance share].dayBorderColorToday.CGColor;
            
            
            textLabel.textColor = [PFCalendarAppearance share].dayTextColor;
            lunarTextLabel.textColor = [PFCalendarAppearance share].lunarDayTextColor;
            
            
            
            
        }
        else{
            if(!self.item.isOtherMonth ){
                
                textLabel.textColor = [PFCalendarAppearance share].dayTextColor;
                lunarTextLabel.textColor = [PFCalendarAppearance share].lunarDayTextColor;
                
            }
            else{
                textLabel.textColor = [PFCalendarAppearance share].dayTextColorOtherMonth;
                lunarTextLabel.textColor = [PFCalendarAppearance share].lunarDayTextColorOtherMonth;
            }
            
            circleView.layer.borderColor = [UIColor clearColor].CGColor;
            
        }
        
    }
    if(animated){
        [UIView animateWithDuration:.1 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
    
}

- (BOOL)isToday
{
    if(isToday == 0){
        return NO;
    }
    else if(isToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            isToday = 1;
            return YES;
        }
        else{
            isToday = 0;
            return NO;
        }
    }
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = [PFCalendarAppearance share].calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

@end
