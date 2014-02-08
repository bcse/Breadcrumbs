//
//  BCSEMainViewController.h
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "BCSEFlipsideViewController.h"

@interface BCSEMainViewController : UIViewController <BCSEFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
