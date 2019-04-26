//
//  PFCalendarContentView.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCalendarAppearance.h"
#import "PFCalendarCLFlowLayout.h"
#import "PFCalendarEventSource.h"
@interface PFCalendarContentView : UIView

@property (nonatomic,strong) PFCalendarCLFlowLayout *flowLayout;

@property (nonatomic,strong) UICollectionView *collectionView;
//遮罩
@property (nonatomic,strong)UIView *maskView;
//事件代理
@property (weak, nonatomic) id<PFCalendarEventSource> eventSource;

@property (nonatomic,strong)NSDate *currentDate;
///滚动到单周需要的offset
@property (nonatomic,assign)CGFloat singleWeekOffsetY;
- (void)setSingleWeek:(BOOL)singleWeek;
///下一页
- (void)getDateDatas;
- (void)loadNextPage;
- (void)loadPreviousPage;
- (void)reloadAppearance;
///更新遮罩镂空的位置 
- (void)setUpVisualRegion;
- (void)goBackToday;

- (void)reloadDefaultDate;
@end
