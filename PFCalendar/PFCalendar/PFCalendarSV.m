//
//  PFCalendarSV.m
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import "PFCalendarSV.h"


@interface PFCalendarSV()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *line;
@end
@implementation PFCalendarSV

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)initUI{
    
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [PFCalendarAppearance share].scrollBgcolor;
    PFCalendarContentView *calendarView = [[PFCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [PFCalendarAppearance share].weekDayHeight*[PFCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame))];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.scrollEnabled = [PFCalendarAppearance share].isShowSingleWeek;
    
    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [PFCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView != self) {
        return;
    }
  
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([PFCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
    [self.calendarView setUpVisualRegion];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}

//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (appearce.isShowSingleWeek) {
            return;
        }
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
}

- (void)scrollToSingleWeek{
    PFCalendarAppearance *appearce =  [PFCalendarAppearance share];
    if (!appearce.isShowSingleWeek) {
        [self.calendarView setUpVisualRegion];
    }
    /// 表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[PFCalendarAppearance share].weekDayHeight*([PFCalendarAppearance share].weeksToDisplay-1));
}

@end
