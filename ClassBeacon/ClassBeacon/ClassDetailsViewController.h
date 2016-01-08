//
//  ClassDetailsViewController.h
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 18/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface ClassDetailsViewController : UITableViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelType;
@property (strong, nonatomic) IBOutlet UILabel *labelRoom;
@property (strong, nonatomic) IBOutlet UILabel *labelSubject;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UITextView *textDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelWeek;
@property (strong, nonatomic) IBOutlet PFImageView *teachImage;
@property(nonatomic, assign) PFObject *object;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
