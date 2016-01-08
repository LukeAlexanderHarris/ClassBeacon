//
//  MapViewController.m
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 3/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//


//no current functionality

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/Mapkit.h>

@interface MapViewController ()

@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [_mapView setDelegate:self];
    _mapView.showsUserLocation = YES;
    
   
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}

//zoom to users location

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.07;
    mapRegion.span.longitudeDelta = 0.07;
    
    [mapView setRegion:mapRegion animated: YES];
}



@end

