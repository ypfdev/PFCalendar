//
//  BVC.m
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/25.
//  Copyright © 2019年 Galanz. All rights reserved.
//

#import "BVC.h"
#import "PFCalendarContentView.h"
#import "PFCalendarWeekDayView.h"
@interface BVC ()
@property (nonatomic,strong)PFCalendarContentView *calendarView;
@end

@implementation BVC
- (IBAction)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.calendarView setSingleWeek:sender.isSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFCalendarWeekDayView *dayView = [[PFCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    [self.view addSubview:dayView];
   
    PFCalendarContentView *view = [[PFCalendarContentView alloc]initWithFrame:CGRectMake(0, 64+30, 375, [PFCalendarAppearance share].weekDayHeight*[PFCalendarAppearance share].weeksToDisplay)];
    view.currentDate = [NSDate date];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:view];
    self.calendarView = view;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
