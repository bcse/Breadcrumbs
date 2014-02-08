//
//  BCSEFlipsideViewController.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "BCSEFlipsideViewController.h"

@interface BCSEFlipsideViewController ()

@end

@implementation BCSEFlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
