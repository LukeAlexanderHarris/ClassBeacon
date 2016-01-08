//
//  IntroView.h
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 04/10/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface IntroView : UIView
@property id<IntroViewDelegate> delegate;

@end
