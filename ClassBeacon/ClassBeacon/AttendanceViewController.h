//
//  AttendanceViewController.h
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 3/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface AttendanceViewController :UITableViewController<PNChartDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic) PNPieChart *pieChart;
@property (weak, nonatomic)IBOutlet UILabel *el635Label;
@property (weak, nonatomic)IBOutlet UILabel *el636Label;
@property (weak, nonatomic)IBOutlet UILabel *el639Label;
@property (weak, nonatomic)IBOutlet UILabel *el640Label;

@end
