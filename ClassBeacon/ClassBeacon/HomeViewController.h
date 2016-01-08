//
//  HomeViewController.h
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 04/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"

@interface HomeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *notesButton;
@property (weak, nonatomic) IBOutlet UIButton *attendButton;
@property (weak, nonatomic) IBOutlet UIButton *notstartButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic)IBOutlet UILabel *startLabel;
@property (weak, nonatomic)IBOutlet UILabel *roomLabel;
@property (weak, nonatomic)IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconLabel;
@property (strong, nonatomic) IBOutlet UILabel *titelLabel;
@property (strong, nonatomic) IBOutlet PFImageView *roomImage;
@property (strong, nonatomic) IBOutlet PFImageView *teachImage;
@property (nonatomic, weak) IBOutlet UIImageView *rangePulse;
@property (weak, nonatomic) IBOutlet UIView *rangeView;

@end