//
//  ClassDeailsViewController.m
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 18/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Foundation/Foundation.h>
#import "ClassDetailsViewController.h"
#import "ClassListViewController.h"
#import "LectureViewController.h"

@interface ClassDetailsViewController (){
    
    
    
}

@end

@implementation ClassDetailsViewController

//web url of the lecture notes retrieved from parse
NSString *notesUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.object)
        
    {
        self.navigationController.navigationBar.topItem.title = @"";
        [self.navigationItem setTitle:[self.object objectForKey:@"Title"]];
        
        //population of UI from the correlating object sent from the classlistview controller
        NSDate *date = [self.object objectForKey:@"start"];
        _labelDate.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        _labelType.text = [self.object objectForKey:@"Type"];
        _labelTitle.text = [self.object objectForKey:@"Title"];
        _labelRoom.text  = [self.object objectForKey:@"Location"];
        _labelWeek.text = [self.object objectForKey:@"Weeks"];
        _textDescription.text  = [self.object objectForKey:@"Description"];
        _labelSubject.text = [self.object objectForKey:@"Subject"];
        
        [_mapView setDelegate:self];
        _mapView.showsUserLocation = YES;
        
        CLLocationDegrees latitude = 51.298147;
        CLLocationDegrees longitude = 1.064077;
        
        CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion mapRegion;
        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;
        
        [_mapView setRegion:mapRegion animated: YES];
        _mapView.centerCoordinate = mapCenter;

        
        self.teachImage.file = [self.object objectForKey:@"image"];
        [self.teachImage loadInBackground];
        
        _teachImage.layer.cornerRadius =   _teachImage.frame.size.height/2 ;
        _teachImage.layer.masksToBounds = YES;
        _teachImage.layer.borderWidth = 0.6f;
        _teachImage.layer.borderColor =[UIColor colorWithRed:0.1922 green:0.3804 blue:0.7922 alpha:1.0].CGColor;
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//prepare segue for loading and view lecture notes once the button is pressed the segue"lecture" is executed anf the lectureviewcontroller is pushed.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LectureViewController *webController = [[LectureViewController alloc] init];
    
    if ([[segue identifier] isEqualToString:@"lecture"]) {
        NSString *urlstr=[NSString stringWithFormat:@"%@", notesUrl];
        webController = [segue destinationViewController];
        webController.urlstr = urlstr;
    }
}



@end
