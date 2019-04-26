//
//  PFCalendarCollectionViewFlowLauout.h
//  PFCalendar
//
//  Created by 原鹏飞 on 2019/4/26.
//  Copyright © 2019 yuanpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFCalendarCLFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
