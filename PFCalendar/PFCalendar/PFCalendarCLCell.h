//
//  PFCalendarCLCell.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCalendarDayItem.h"
@interface PFCalendarCLCell : UICollectionViewCell
@property (nonatomic,strong)PFCalendarDayItem *item;
@property (nonatomic,assign)BOOL isSelected;
@end
