//
//  NotesListViewController.h
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 16/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//


#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface NotesListViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end
