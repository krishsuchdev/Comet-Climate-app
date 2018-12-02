//
//  ShortcutsViewController.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "ShortcutsViewController.h"
#import "APIManager.h"
#import "ShortcutButton.h"
#import <SafariServices/SafariServices.h>

@interface ShortcutsViewController ()

@end

@implementation ShortcutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // Refresh content before user sees the view controller
  [self updatePresentedData];
}

- (void)updatePresentedData {
  if ([APIManager sharedInstance].fetchedWeather) {
    // Get current weather data
    WeatherObject *weather = [[APIManager sharedInstance].weather objectAtIndex:0];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitDay) fromDate:weather.date];
    
    // Set the background designated for the current weather conditions
    [self.backgroundImage setImage:[WeatherObject imageForWeatherCondition:weather.condition asBackground:true]];
    // Show a darker background if it is night-time or early morning
    if (dateComponents.hour <= 6 || dateComponents.hour > 12 + 6)
      [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    else
      [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
  }
}


- (IBAction)shortcutTapped:(ShortcutButton *)sender {
  NSURL *tapURL = [NSURL URLWithString:sender.tapURL];
  
  // Sets up color scheme for in-app browser
  SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:tapURL];
  [safariVC setPreferredBarTintColor:UIColor.blackColor];
  [safariVC setPreferredControlTintColor:UIColor.whiteColor];
  
  // Presents the web page within the app
  [self presentViewController:safariVC animated:true completion:^{
  }];
}

@end
