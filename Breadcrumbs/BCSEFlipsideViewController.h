//
//  BCSEFlipsideViewController.h
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCSEFlipsideViewController;

@protocol BCSEFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(BCSEFlipsideViewController *)controller;
@end

@interface BCSEFlipsideViewController : UIViewController

@property (weak, nonatomic) id <BCSEFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
