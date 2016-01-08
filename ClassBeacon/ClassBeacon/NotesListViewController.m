//
//  NotesListViewController.m
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 16/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//


#import "NotesListViewController.h"
#import "NotesViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SWRevealViewController.h"

@interface NotesListViewController ()
{
 UIRefreshControl *refreshControl;
}
@end

@implementation NotesListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Notes"];
    self = [super initWithCoder:aDecoder];
    if (self) {
      
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0.1922 green:0.3804 blue:0.7922 alpha:1.0];
    [self.refreshControl addTarget:self action:@selector(loadObjects) forControlEvents:UIControlEventValueChanged];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
   }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - PFQueryTableViewController

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [object createdAt];
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"title"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
    
    
    return cell;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    // Create a query
    PFQuery *query = [PFQuery queryWithClassName:@"Notes"];
    
    // Follow relationship
    if ([PFUser currentUser]) {
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
    }
    else {
        // I added this so that when there is no currentUser, the query will not return any data
        // Without this, when a user signs up and is logged in automatically, they briefly see a table with data
        // before loadObjects is called and the table is refreshed.
        // There are other ways to get an empty query, of course. With the below, I know that there
        // is no such column with the value in the database.
        [query whereKey:@"nonexistent" equalTo:@"doesn't exist"];
    }
    
    return query;

}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNote"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        NotesViewController *note = (NotesViewController *)segue.destinationViewController;
        note.note = object;
    }
}




@end
