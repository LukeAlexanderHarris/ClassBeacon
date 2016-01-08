//
//  LogOutViewController.m
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 04/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import "LogOutViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>


@interface LogOutViewController ()
@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Logout";
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO"forKey:@"intro_screen_viewed"];
    [defaults synchronize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    }







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end