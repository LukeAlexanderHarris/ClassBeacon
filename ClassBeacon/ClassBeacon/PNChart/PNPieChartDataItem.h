//
//  PNPieChartDataItem.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNPieChartDataItem : NSObject

+ (instancetype)dataItemWithValue:(double)value
                            color:(UIColor*)color;

+ (instancetype)dataItemWithValue:(double)value
                            color:(UIColor*)color
                      description:(NSString *)description;

@property (nonatomic) double  value;
@property (nonatomic) UIColor  *color;
@property (nonatomic) NSString *textDescription;

@end
