//
// LectureViewController.m
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 18/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import "LectureViewController.h"

@interface LectureViewController ()
{

    
}

@end

@implementation LectureViewController

@synthesize WebView;
@synthesize urlstr;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = @"Lecture Notes";
    self.navigationController.navigationBar.topItem.title = @"";
    
    //Url of the lecture notes file retrieved from parse query, url is loaded into the webview which displays the pdf
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.WebView loadRequest:requestObj];
    
}

@end
