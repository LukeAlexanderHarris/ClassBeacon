//
//  ClassCell.h
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 12/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI/ParseUI.h"

@interface classCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelCategory;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;


@end
