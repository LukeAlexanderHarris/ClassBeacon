//
//  PNPieChartDataItem.m
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import "PNPieChartDataItem.h"
#import <UIKit/UIKit.h>

@implementation PNPieChartDataItem


+ (instancetype)dataItemWithValue:(double)value
                            color:(UIColor*)color{
	PNPieChartDataItem *item = [PNPieChartDataItem new];
	item.value = value;
	item.color  = color;
	return item;
}

+ (instancetype)dataItemWithValue:(double)value
                            color:(UIColor*)color
                      description:(NSString *)description {
	PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:color];
	item.textDescription = description;
	return item;
}

- (void)setValue:(double)value{
    NSAssert(value >= 0, @"value should >= 0");
    if (value != _value){
        _value = value;
    }
}

@end
