//
//  NotesViewController.h
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 16/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NotesViewController : UIViewController

@property (nonatomic, strong) PFObject *note;

@end
