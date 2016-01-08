//
//  ClassListViewController.m
//    ClassBeacon
//
//  Created by lah37@kent.ac.uk on 12/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import "ClassListViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "ClassCell.h"
#import "SWRevealViewController.h"
#import "ClassDetailsViewController.h"


@interface ClassListViewController ()
{
    NSArray *ClassTimetable;
    
    UIRefreshControl *refreshControl;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation ClassListViewController
//object type Parse file
PFFile *notes;


-(void)viewDidLoad
{
    [super viewDidLoad];
    // refresh control initilisation and settings
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0.1922 green:0.3804 blue:0.7922 alpha:1.0];
    [self.refreshControl addTarget:self action:@selector(getObjects) forControlEvents:UIControlEventValueChanged];
    
    //Prevents user selcting more than one cell
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //sidebar looaded
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //refresh control are called and executed
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

//query parse to retrieve the list of timetbled classes that have yet to take place
-(void)getObjects
{
    //current date needed for query date format includes time
    NSDate *now=[NSDate date];
    //query argument if the current date is less the end date of lectures.
    //All lectures that have not ended yet are retreived and stored in objects array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ < end)",now ];
    PFQuery *query = [PFQuery queryWithClassName:@"ClassList" predicate:predicate];
    // Query the Local Datastore
    [query fromLocalDatastore];
    [query orderByAscending:@"start"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     
     {
         //once objects are retrieved end the refresh animation
         [self.refreshControl endRefreshing];
         
         //initialising an array to store object ids for populating tableview cells
         NSArray *classObjectIds = [ClassTimetable valueForKey:@"objectId"];
         
         NSMutableArray *_mutableClassTimetable = [[NSMutableArray alloc] initWithArray:ClassTimetable];
         
         for (PFObject *object in objects)
         {
             if ([classObjectIds containsObject:object.objectId] == NO)
             {
                 [_mutableClassTimetable addObject:object];
             }
         }
         ClassTimetable = _mutableClassTimetable;
         
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
     }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ClassTimetable.count;
}

//population of tableview cells with each classes infroamtion
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    classCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([classCell class]) forIndexPath:indexPath];
    
    PFObject *object = [ClassTimetable objectAtIndex:indexPath.row];
    
    // Configure the cell to show class object
    
    NSDate *date = [object objectForKey:@"start"];
    
    cell.labelTitle.text    = [object objectForKey:@"Title"];
    cell.labelCategory.text = [object objectForKey:@"Location"];
    
    cell.labelDate.text     = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    
    
    return cell;
}


//prepare for segue to class details view once a cell is clicked its id is stored and the object is sent to the new view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        ClassDetailsViewController *controller = (ClassDetailsViewController *)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.object = [ClassTimetable objectAtIndex:indexPath.row];
        
    }
}




@end



