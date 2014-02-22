//
//  BCSESettingsViewController.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "BCSESettingsViewController.h"

@interface BCSESettingsViewController ()

@property (nonatomic, strong) IBOutlet UISwitch *toggleBackgroundUpdateButton;
@property (nonatomic, strong) IBOutlet UISwitch *toggleBestAccuracyButton;

- (IBAction)toggleBackgroundUpdate:(id)sender;
- (IBAction)toggleBestAccuracy:(id)sender;
- (IBAction)exportGPX:(id)sender;
- (IBAction)resetDB:(id)sender;

@end

@implementation BCSESettingsViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Load user settings
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL backgroundUpdateEnabled = [settings boolForKey:@"BackgroundUpdateEnabled"];
    BOOL bestAccuracyEnabled = [settings boolForKey:@"BestAccuracyEnabled"];
    [self.toggleBackgroundUpdateButton setOn:backgroundUpdateEnabled];
    [self.toggleBestAccuracyButton setOn:bestAccuracyEnabled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)toggleBackgroundUpdate:(id)sender
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:self.toggleBackgroundUpdateButton.isOn forKey:@"BackgroundUpdateEnabled"];
}

- (IBAction)toggleBestAccuracy:(id)sender
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:self.toggleBestAccuracyButton.isOn forKey:@"BestAccuracyEnabled"];
}

- (IBAction)exportGPX:(id)sender
{
    [self.delegate settingsViewControllerPerformExportGPX:self];
}

- (IBAction)resetDB:(id)sender
{
    [self.delegate settingsViewControllerPerformResetDB:self];
}

@end
