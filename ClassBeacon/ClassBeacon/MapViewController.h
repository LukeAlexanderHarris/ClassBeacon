//
//  MapViewController.h
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 3/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/Mapkit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
