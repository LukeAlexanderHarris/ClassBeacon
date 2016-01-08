//
//  HomeViewController.m
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 04/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <ESTBeaconManager.h>
#import "IntroView.h"
#import "PulsingHaloLayer.h"
#import "LectureViewController.h"

@interface HomeViewController ()<ESTBeaconManagerDelegate, CLLocationManagerDelegate,IntroViewDelegate>
@property IntroView *introView;


@property (nonatomic, strong) ESTBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *beaconRegion;
@property (nonatomic, strong) PFObject *attend;

@property (nonatomic, weak) PulsingHaloLayer *halo;

@end

@implementation HomeViewController

NSString *sep;
NSNumber *minor;
NSNumber *one;
NSNumber *major;
NSString *title;
NSString *type;
NSString *subject;
NSString *room;
NSDate *now;
NSString *minorString;
NSDate *start;
NSDate *end;
PFObject *objects;
NSArray *array;
NSString *notesUrl;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ClassBeacon";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[IntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:self.introView];
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    
    
    //Set up iBeacon ranging, region, monitoring find beacons with Estmotes UUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@""]; //input your Estimote UUID or alter to use with other iBeacon brands
    
    //set up the beacon manager
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    //set up the beacon region
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                                                            identifier:@"RegionIdenifier"
                                                               secured:self.beacon.isSecured];
    //start  monitorinf
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    [self.beaconManager requestStateForRegion:self.beaconRegion];
    //start the ranging
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    //MUST have for IOS8
    [self.beaconManager requestAlwaysAuthorization];
    //let us know when we exit and enter a region
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    _teachImage.layer.cornerRadius =   _teachImage.frame.size.height/2 ;
    _teachImage.layer.masksToBounds = YES;
    _teachImage.layer.borderWidth = 2.0f;
    
    _attendButton.hidden = YES;
    _notstartButton.hidden = YES;
    
    ///setup single halo layer
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.position = self.view.center;
    [self.view.layer insertSublayer:self.halo above:_rangePulse.layer];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

    
}


//BEACON MANAGER

//check for region failure
-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Region Did Fail: Manager:%@ Region:%@ Error:%@",manager, region, error);
}

//checks permission status
-(void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Status:%d", status);
}

//Beacon manager did enter region
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region

{
    
        //Adding a custom local notification to be presented
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"Confirm attendance";
    notification.soundName = @"Default.mp3";
    NSLog(@"Youve entered");
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}


//Beacon Manager did exit the region
- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
      [self leftClass];
    //adding a custon local notification
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"You've left class!";
    NSLog(@"Youve exited");
    [self saveAttend];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

//beacon ranging closest beacon
-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    if (beacons.count > 0) {
        ESTBeacon *firstBeacon = [beacons firstObject];
        
        self.beaconLabel.text     = [self textForProximity:firstBeacon.proximity];
        
        minor = firstBeacon.minor;
        major = firstBeacon.major;

        
        [self Query];
        _titelLabel.text =  title;
        _classLabel.text =  [NSString stringWithFormat:@"%@", subject];
      
        NSDateFormatter *endFormat = [[NSDateFormatter alloc] init];
        [endFormat setDateFormat:@"HH:mm"];

        NSDateFormatter *startFormat = [[NSDateFormatter alloc] init];
        [startFormat setDateFormat:@"HH:mm"];
        
        _startLabel.text =[NSString stringWithFormat:@"%@ - %@", [startFormat stringFromDate:start],[endFormat stringFromDate:end]];
        
        [_notesButton setTitle: [NSString stringWithFormat:@"%@ Notes",type] forState: UIControlStateNormal];
        minorString = [NSString stringWithFormat:@"%i",[[[beacons objectAtIndex:0] valueForKey: @"minor"] intValue]];

        //minor values are examples that correspond to each beacon for each classroom, coded for only three beacons.
        if ([minorString  isEqual: @"199"]) {
            
            _teachImage.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:70.0f/255.0f blue:131.0f/255.0f alpha:1.0].CGColor;
            
        }
        else if ([minorString  isEqual: @"198"])
        {
             _teachImage.layer.borderColor = [UIColor colorWithRed:155.0f/255.0f green:202.0f/255.0f blue:178.0f/255.0f alpha:1.0].CGColor;
        }
        else if ([minorString  isEqual: @"197"])
        {
            _teachImage.layer.borderColor = [UIColor colorWithRed:149.0f/255.0f green:197.0f/255.0f blue:223.0f/255.0f alpha:1.0].CGColor;
        }
        
        else{
            
       _teachImage.layer.borderColor = [UIColor colorWithRed:49.0f/255.0f green:97.0f/255.0f blue:202.0f/255.0f alpha:1.0].CGColor;
            

        }
        
    };
}

-(NSString *)textForProximity:(CLProximity)proximity
{
    
    switch (proximity) {
        case CLProximityFar:
            _rangeView.hidden = YES;
               self.halo.hidden = YES;
            NSLog(@"far");
            return @"Far";
            break;
        case CLProximityNear:
            NSLog(@"near");
            _rangeView.hidden = YES;
            self.beaconLabel.textColor = [UIColor purpleColor];
               self.halo.hidden = YES;
            return @"Near";
            break;
        case CLProximityImmediate:
            NSLog(@"immediate");
            _rangeView.hidden = YES;
            self.beaconLabel.textColor = [UIColor redColor];
            self.halo.hidden = YES;
            
            return @"Immediate";
            break;
        case CLProximityUnknown:
            NSLog(@"unknown " );
            _rangeView.hidden = NO;
            self.halo.hidden = NO;
            return @"Unknown";
            break;
        default:
            break;
    }
}


//Parse query therefore class names dependant on what you use for your core parse classes and the names of each row.

-(void)Query
{
    PFQuery *query = [PFQuery queryWithClassName:@"iBeacons"];
    // Query the Local Datastore
    [query fromLocalDatastore];
    [query whereKey:@"minor" equalTo: minor ];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *ibeacons, NSError *error)
     
     {
         
         room = ibeacons[@"room"];
         _roomLabel.text = room;
         self.roomImage.file = [ibeacons objectForKey:@"image"];
         [self.roomImage loadInBackground];
         
         
         
         now=[NSDate date];
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(start <= %@) AND (%@ < end)", now, now ];
         PFQuery *queryClass = [PFQuery queryWithClassName:@"ClassList" predicate:predicate];
         // Query the Local Datastore
         [queryClass fromLocalDatastore];
         [queryClass whereKey:@"Location" matchesKey:@"room" inQuery:query];
         [queryClass getFirstObjectInBackgroundWithBlock:^(PFObject *class, NSError *error) {
             
             if(!error)
             {
                 type = class[@"Type"];
                 title = class[@"Title"];
                 subject = class[@"Subject"];
                 end = class[@"end"];
                 start = class[@"start"];
                 self.teachImage.file = [class objectForKey:@"image"];
                 [self.teachImage loadInBackground];
                 _teachImage.layer.cornerRadius =   _teachImage.frame.size.height/2 ;
                 _teachImage.layer.masksToBounds = YES;
                 _teachImage.layer.borderWidth = 2.0f;
                 PFFile *file = class[@"Notes"];
                 notesUrl = [file url];
                 
                 _attendButton.hidden = NO;
                 _notstartButton.hidden = YES;
             }
             
             else{
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(start > %@)", now];
                 PFQuery *queryClass = [PFQuery queryWithClassName:@"ClassList" predicate:predicate];
                 // Query the Local Datastore
                 [queryClass fromLocalDatastore];
                 [query orderByAscending:@"start"];
                 [queryClass whereKey:@"Location" matchesKey:@"room" inQuery:query];
                 [queryClass getFirstObjectInBackgroundWithBlock:^(PFObject *class, NSError *error)
                  
                  {
                      if(!error)
                      {
                      
                      type = class[@"Type"];
                      title = class[@"Title"];
                      subject = class[@"Subject"];
                      start = class[@"start"];
                      end = class[@"end"];
                      self.teachImage.file = [class objectForKey:@"image"];
                      [self.teachImage loadInBackground];
                          
                          PFFile *file = class[@"Notes"];
                          notesUrl = [file url];
                          
                      _attendButton.hidden = YES;
                      _notstartButton.hidden = NO;
                      }
                      else
                      {
                          title = @"No Timetabled Classes.";
                          subject = @"Please ask";
                          type = @"staff for details.";
                          start = now;
                          end = now;
                          _teachImage.image =[UIImage imageNamed:@"iTunesArtwork"];
                          _attendButton.hidden = YES;
                          _notstartButton.hidden = NO;

                      }
                      
                      
                      
                  }];
             }
             
         }];
         
     }];
    
}


- (IBAction)AttendButtonTapAction:(id)sender {

    [self saveAttend];
}

- (void)leftClass
{
    
    PFQuery *query = [PFQuery queryWithClassName:[subject stringByAppendingString: @"_Attendance"]];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:[self.attend objectId] block:^(PFObject *leftClass, NSError *error) {
        
        if (error) {
            AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Error" andText:@"Please try again!" andCancelButton:NO forAlertType:AlertFailure];
            [alertView.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
            alertView.cornerRadius = 3.0f;
            //        [self.view addSubview:alertView];
            [alertView show];
        }
        else {
            leftClass[@"leftClass"] = [NSDate date];;
           
            
            [leftClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Error" andText:@"Please try again!" andCancelButton:NO forAlertType:AlertFailure];
                    [alertView.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
                    alertView.cornerRadius = 3.0f;
                    //        [self.view addSubview:alertView];
                    [alertView show];
                }
            }];
        }
        
    }];
}

- (void)saveAttend
{
    PFObject *newAttend = [PFObject objectWithClassName:[subject stringByAppendingString: @"_Attendance"]];
    newAttend[@"title"] = title;
    newAttend[@"subject"] = subject;
    newAttend[@"author"] = [PFUser currentUser];
    newAttend[@"attendance"] = [NSNumber numberWithBool:YES];
    newAttend[@"classStart"] = start;
    newAttend[@"classEnd"] = end;
    newAttend[@"room"] = room;
    
    _attend = newAttend;
    
    [newAttend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if (succeeded) {
            
            [self.navigationController popViewControllerAnimated:YES];
            AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initDropAlertWithTitle:@"Success" andText:[NSString stringWithFormat:@"Attandance for %@ confirmed!",subject] andCancelButton:NO forAlertType:AlertSuccess];
            [alertView.defaultButton setTitle:@"Great" forState:UIControlStateNormal];
            alertView.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
                if(button == alertObj.defaultButton) {
                    NSLog(@"Default");
                } else {
                    NSLog(@"Others");
                }
            };
            
            alertView.cornerRadius = 3.0f;
            [alertView show];
            
        }
        
        else {
            AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Sorry about this!" andText:@"Please try again!" andCancelButton:NO forAlertType:AlertFailure];
            [alertView.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
            alertView.cornerRadius = 3.0f;
            //        [self.view addSubview:alertView];
            [alertView show];            }
    }];
    
}
// Open lecture note PDF via webview
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LectureViewController *webController = [[LectureViewController alloc] init];
    
    if ([[segue identifier] isEqualToString:@"lecture"]) {
        NSString *urlstr=[NSString stringWithFormat:@"%@", notesUrl];
        webController = [segue destinationViewController];
        webController.urlstr = urlstr;
    }
}




// Parse LOGINVIEW

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
      [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
