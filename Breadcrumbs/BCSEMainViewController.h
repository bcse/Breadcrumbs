//
//  BCSEMainViewController.h
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BCSESettingsViewController.h"

@interface BCSEMainViewController : UIViewController <BCSESettingsViewControllerDelegate, CLLocationManagerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextView *logTextView;

- (void)settingsChanged:(NSNotification *)notification;
- (void)switchToBackgroundMode:(BOOL)background;

@end
