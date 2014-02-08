//
//  BCSEMainViewController.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/8.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import <LevelDB.h>
#import "BCSEMainViewController.h"
#import "NSDate+Additions.h"
#import "UIDevice+Additions.h"
#import "UITextViewLogger.h"

@interface BCSEMainViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LevelDB *database;

- (IBAction)clearLogTextView:(id)sender;

@end

@implementation BCSEMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Create the logger
    UITextViewLogger *textViewLogger = [[UITextViewLogger alloc] init];
    textViewLogger.autoScrollsToBottom = YES;
    [DDLog addLogger:textViewLogger];
    textViewLogger.textView = self.logTextView;

    // Connect database
    self.database = [LevelDB databaseInLibraryWithName:@"Locations"];

    DDLogInfo(@"DeferredLocationUpdatesAvailable = %@", [CLLocationManager deferredLocationUpdatesAvailable] ? @"YES" : @"NO");

    // Note: we are using Core Location directly to get the user location updates.
    // We could normally use MKMapView's user location update delegation but this does not work in
    // the background.  Plus we want "kCLLocationAccuracyBestForNavigation" which gives us a better accuracy.
    //
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; // Tells the location manager to send updates to this object

    // By default the location manager pause location updates when an app is in the background and
    // the location data is unlikely to change.
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    [self.locationManager startUpdatingLocation];

    [self applySettings];
}

- (void)dealloc
{
    self.locationManager.delegate = nil;
    [self.database close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Settings"]) {
        BCSESettingsViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.delegate = self;
    }
}

- (void)switchToBackgroundMode:(BOOL)background
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL backgroundUpdateEnabled = [settings boolForKey:@"BackgroundUpdateEnabled"];

    if (background)
    {
        if (!backgroundUpdateEnabled)
        {
            [self.locationManager stopUpdatingLocation];
            self.locationManager.delegate = nil;
        }
    }
    else
    {
        if (!backgroundUpdateEnabled)
        {
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (IBAction)clearLogTextView:(id)sender
{
    self.logTextView.text = @"";
}

#pragma mark - Settings

- (void)applySettings
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL backgroundUpdateEnabled = [settings boolForKey:@"BackgroundUpdateEnabled"];
    BOOL bestAccuracyEnabled = [settings boolForKey:@"BestAccuracyEnabled"];

    DDLogInfo(@"BackgroundUpdateEnabled: %@", backgroundUpdateEnabled ? @"YES" : @"NO");
    DDLogInfo(@"BestAccuracyEnabled: %@", bestAccuracyEnabled ? @"YES" : @"NO");

    // By default use the best accuracy setting (kCLLocationAccuracyBest)
    //
    // You mau instead want to use kCLLocationAccuracyBestForNavigation, which is the highest possible
    // accuracy and combine it with additional sensor data.  Note that level of accuracy is intended
    // for use in navigation applications that require precise position information at all times and
    // are intended to be used only while the device is plugged in.
    //
    if (bestAccuracyEnabled)
    {
        // better accuracy
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    else
    {
        // normal accuracy
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)settingsChanged:(NSNotification *)notification
{
    [self applySettings];
}

#pragma mark - BCSESettingsViewControllerDelegate

- (void)settingsViewControllerPerformExportGPX:(BCSESettingsViewController *)controller;
{
    DDLogInfo(@"Exporting to GPX...");
    __block NSMutableString *xmlString = [NSMutableString stringWithString:
                                          @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                          @"<gpx xmlns=\"http://www.topografix.com/GPX/1/1\" version=\"1.1\" creator=\"Breadcrumbs\">"
                                          @"<trk><trkseg>"];
    [self.database enumerateKeysAndObjectsUsingBlock:^(LevelDBKey *key, id value, BOOL *stop) {
        CLLocation *location = value;
        [xmlString appendFormat:
         @"<trkpt lat=\"%f\" lon=\"%f\">"
         @"<ele>%f</ele>"
         @"<time>%@</time>"
         @"<src>%@</src>"
         @"</trkpt>",
         location.coordinate.latitude, location.coordinate.longitude,
         location.altitude, [location.timestamp bcse_ISO8601String], [[UIDevice currentDevice] bcse_machine]];
    }];
    [xmlString appendString:@"</trkseg></trk></gpx>"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSString stringWithFormat:@"Breadcrumbs-%f.gpx", [[NSDate date] timeIntervalSinceReferenceDate]];
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    NSData *fileContents = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:filePath contents:fileContents attributes:nil];
    DDLogInfo(@"Exporting to GPX finished!");
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        NSTimeInterval timeInterval = location.timestamp.timeIntervalSinceReferenceDate;
        NSData *key = [NSData dataWithBytes:&timeInterval length:sizeof(NSTimeInterval)];
        [self.database setObject:location forKey:key];

        NSString *timestamp = [NSDateFormatter localizedStringFromDate:location.timestamp
                                                             dateStyle:NSDateFormatterNoStyle
                                                             timeStyle:NSDateFormatterMediumStyle];
        DDLogInfo(@"%@  (%f, %f)", timestamp, location.coordinate.latitude, location.coordinate.longitude);
    }
}

@end
