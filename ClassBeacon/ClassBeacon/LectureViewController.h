//
//  LectureViewController.h
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 18/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureViewController : UIViewController {
    NSString *urlstr;
}

@property (strong, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) NSString *urlstr;
@end

