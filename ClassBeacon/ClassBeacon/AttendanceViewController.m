//
//  AttendanceViewController.m
//  ClassBeacon
//
//  Created by lah37@kent.ac.uk on 3/3/2015.
//  Copyright (c) 2015 lah37@kent.ac.uk. All rights reserved.
//
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "AttendanceViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController
NSDate *now;
int el635Attend;
int el635Total;
int el636Attend;
int el636Total;
int el639Attend;
int el639Total;
int el640Attend;
int el640Total;
NSString *el635P;
NSString *el636P;
NSString *el639P;
NSString *el640P;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Attendance";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self AttendanceQuery];
    
   self.title = @"Attendance";
    

   
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // delay view loading of Piechart and percentage labels for 1 second
    NSTimeInterval delay = 1;
    //Use dispatch_after to set the center coordinate after a delay.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(),
                   ^{
                      //Core Parse class names need altering depending on your own values.
                       [self PieChart];
                       _el635Label.text = el635P;
                       _el636Label.text = el636P;
                       _el639Label.text = el639P;
                       _el640Label.text = el640P;
                       
                    }
           
                   );
 

    


    [super viewDidAppear: animated];
}


-(void)AttendanceQuery


{
    now=[NSDate date];

//Query class EL635_Attendance to count the attendance for module EL635
    PFQuery *queryEL635 = [PFQuery queryWithClassName:@"EL635_Attendance"];
    [queryEL635 whereKey:@"author" equalTo:[PFUser currentUser]];
    [queryEL635 countObjectsInBackgroundWithBlock:^(int el635, NSError *error) {
                   // The count request succeeded. Log the count
         el635Attend = el635;
        
        //Query ClassList to count the total number of classes that have taken place for module EL635
        PFQuery *queryEL635Total = [PFQuery queryWithClassName:@"ClassList"];
        [queryEL635Total whereKey:@"Subject" equalTo:@"EL635"];
        [queryEL635Total whereKey:@"end" lessThanOrEqualTo:now];
        [queryEL635Total countObjectsInBackgroundWithBlock:^(int el635Total, NSError *error) {
            
            // The count request succeeded. Log the count
            
            
            // Calculate student/user Attendace percentage of how many they have attended and how many timetabled classes have been held up to the present date.
            float PercentageEl635 = (100 * el635Attend)/el635Total;
            el635P = [NSString stringWithFormat:@"%i%%",(int)round(PercentageEl635)];
            
            
        }];
        
    }];
    
    //Query class EL636_Attendance to count the attendance for module EL636
    PFQuery *queryEL636 = [PFQuery queryWithClassName:@"EL636_Attendance"];
    [queryEL636 whereKey:@"author" equalTo:[PFUser currentUser]];
    [queryEL636 countObjectsInBackgroundWithBlock:^(int el636, NSError *error) {
      
            // The count request succeeded. Log the count
             el636Attend = el636;
        //Query ClassList to count the total number of classes that have taken place for module EL636
        PFQuery *queryEL636Total = [PFQuery queryWithClassName:@"ClassList"];
        [queryEL636Total fromLocalDatastore];
        [queryEL636Total whereKey:@"Subject" equalTo:@"EL636"];
        [queryEL636Total whereKey:@"end" lessThanOrEqualTo:now];
        [queryEL636Total countObjectsInBackgroundWithBlock:^(int el636Total, NSError *error) {
            
            // The count request succeeded. Log the count
            
            
            // Calculate student/user Attendace percentage of how many they have attended and how many timetabled classes have been held up to the present date.
            float PercentageEl636 = (100 * el636Attend)/el636Total;
            el636P = [NSString stringWithFormat:@"%i%%",(int)round(PercentageEl636)];
            
            
            
            
            
        }];

     
    }];
    
    //Query class EL639_Attendance to count the attendance for module EL639
    PFQuery *queryEL639 = [PFQuery queryWithClassName:@"EL639_Attendance"];
    [queryEL639 whereKey:@"author" equalTo:[PFUser currentUser]];
    [queryEL639 countObjectsInBackgroundWithBlock:^(int el639, NSError *error) {
       
            // The count request succeeded. Log the count
           
            el639Attend = el639;
        //Query ClassList to count the total number of classes that have taken place for module EL639
        PFQuery *queryEL639Total = [PFQuery queryWithClassName:@"ClassList"];
        [queryEL639Total fromLocalDatastore];
        [queryEL639Total whereKey:@"Subject" equalTo:@"EL639"];
        [queryEL639Total whereKey:@"end" lessThanOrEqualTo:now];
        [queryEL639Total countObjectsInBackgroundWithBlock:^(int el639Total, NSError *error) {
            
            // The count request succeeded. Log the count
            
            
            // Calculate student/user Attendace percentage of how many they have attended and how many timetabled classes have been held up to the present date.
            float PercentageEl639 = (100 * el639Attend)/el639Total;
            el639P = [NSString stringWithFormat:@"%i%%",(int)round(PercentageEl639)];
            
            
            
            
        }];

       
       
    }];
    //Query class EL640_Attendance to count the attendance for module EL640
    PFQuery *queryEL640 = [PFQuery queryWithClassName:@"EL640_Attendance"];
    [queryEL640 whereKey:@"author" equalTo:[PFUser currentUser]];
    [queryEL640 countObjectsInBackgroundWithBlock:^(int el640, NSError *error) {
        
            // The count request succeeded. Log the count
            
            el640Attend = el640;
        //Query ClassList to count the total number of classes that have taken place for module EL640
        PFQuery *queryEL640Total = [PFQuery queryWithClassName:@"ClassList"];
        
        [queryEL640Total whereKey:@"Subject" equalTo:@"EL640"];
        [queryEL640Total whereKey:@"end" lessThanOrEqualTo:now];
        [queryEL640Total countObjectsInBackgroundWithBlock:^(int el640Total, NSError *error) {
            
            // The count request succeeded. Log the count
            
            
            // Calculate student/user Attendace percentage of how many they have attended and how many timetabled classes have been held up to the present date.
            float PercentageEl640 = (100 * el640Attend)/el640Total;
            el640P = [NSString stringWithFormat:@"%i%%",(int)round(PercentageEl640)];
            
            
        }];

     
    }];
    

    
    

    
       }

-(void) PieChart
{

    NSArray *items = @[[PNPieChartDataItem dataItemWithValue: el635Attend color:PNBlue description:@"EL635"],
                       [PNPieChartDataItem dataItemWithValue: el636Attend color:PNRed description:@"EL636"],
                       [PNPieChartDataItem dataItemWithValue: el639Attend color:PNStarYellow description:@"EL639"],
                       [PNPieChartDataItem dataItemWithValue: el640Attend color:PNFreshGreen description:@"EL640"],
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 20, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = YES;
    self.pieChart.showOnlyValues = YES;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleSerial;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(60, 250, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:self.pieChart];

}




    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
