//
//  BCSESettingsViewController.h
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCSESettingsViewController;


@protocol BCSESettingsViewControllerDelegate

- (void)settingsViewControllerPerformExportGPX:(BCSESettingsViewController *)controller;
- (void)settingsViewControllerPerformResetDB:(BCSESettingsViewController *)controller;

@end


@interface BCSESettingsViewController : UITableViewController

@property (weak, nonatomic) id <BCSESettingsViewControllerDelegate> delegate;

@end
