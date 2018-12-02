//
//  TwitterViewController.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterTableViewCell.h"
#import "APIManager.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Reverses background image to make the view controller transitions look smooth
  self.backgroundImage.transform = CGAffineTransformMakeScale(-1.0, 1.0);
  
  // Adds the refresh indicator when the user swipes downward
  self.tweetsRefresh = [[UIRefreshControl alloc] init];
  [self.tweetsRefresh setTintColor:UIColor.whiteColor];
  [self.tweetsRefresh addTarget:self action:@selector(updatePresentedData) forControlEvents:UIControlEventValueChanged];
  [self.tweetsTableView addSubview:self.tweetsRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // Refresh content before user sees the view controller
  [self updatePresentedData];
}

- (void)refreshTableView {
  // Manually fetches new data upon user request (swipe gesture)
  [[APIManager sharedInstance] fetchTwitter];
}

- (void)updatePresentedData {
  // Reload all content without stopping any ongoing animations
  
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
  
  // End refreshing animation in background thread
  if (self.tweetsRefresh.isRefreshing)
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tweetsRefresh endRefreshing];
    });
  
  // Refresh tweets
  [self.tweetsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return MAX(0, [APIManager sharedInstance].tweets.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Get tweet data for row
  TwitterObject *tweet = [[APIManager sharedInstance].tweets objectAtIndex:indexPath.row];
  
  // Indicates whether a photo is available for the tweet
  BOOL hasMedia = tweet.contentMediaPhoto;
  
  // Get the starting template for the cell depending on whether or not there is media available in the tweet
  TwitterTableViewCell *cell = (TwitterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:hasMedia ? @"MediaPhotoTweet" : @"BasicTweet"];
  
  // Update labels and images
  [cell.displayNameLabel setText:tweet.displayName];
  [cell.usernameLabel setText:[NSString stringWithFormat:@"@%@", tweet.username]];
  [cell.profileImage setImage:tweet.profilePicture];
  [cell.contentTextView setText:tweet.contentText];
  [cell.likesDataLabel setText:[NSString stringWithFormat:@"%lu", tweet.likes]];
  [cell.retweetsDataLabel setText:[NSString stringWithFormat:@"%lu", tweet.retweets]];

  if (hasMedia) [cell.contentMediaImageView setImage:tweet.contentMediaPhoto];
  
  // Masking the profile image to a circle (like in Twitter)
  cell.profileImage.layer.masksToBounds = true;
  cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2.0;
  
  // Logic for what units to show for the date of the tweet
  NSString *difference = @"";
  NSInteger minuteDifference = -[tweet.datePosted timeIntervalSinceNow] / 60;
  if (minuteDifference < 60)
    difference = [NSString stringWithFormat:@"%lum", minuteDifference];
  else
    if (minuteDifference < 60 * 24)
      difference = [NSString stringWithFormat:@"%luh", minuteDifference / 60];
    else
      if (minuteDifference < 60 * 24 * 7)
        difference = [NSString stringWithFormat:@"%lud", minuteDifference / 60 / 24];
      else difference = [NSString stringWithFormat:@"%luw", minuteDifference / 60 / 24 / 7];
  [cell.dateLabel setText:difference];
  
  // Sets a dark background view for cell highlight indicator
  UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
  selectedView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
  cell.selectedBackgroundView = selectedView;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Turn off selection highlight when tapped
  if ([tableView.indexPathForSelectedRow isEqual:indexPath])
    [tableView deselectRowAtIndexPath:indexPath animated:true];
  
  // Gets the deep link and opens in Twitter App or Mobile Safari
  TwitterObject *tweet = [[APIManager sharedInstance].tweets objectAtIndex:indexPath.row];
  NSURL *tweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@", tweet.username, tweet.tweetID]];
  [[UIApplication sharedApplication] openURL:tweetURL options:@{} completionHandler:^(BOOL success) {
  }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Estimating the height of the cell since it is also dependent on the numer of lines of text in the tweet
  
  TwitterObject *tweet = [[APIManager sharedInstance].tweets objectAtIndex:indexPath.row];
  BOOL hasMedia = tweet.contentMediaPhoto;
  
  // Cells with media should be larger
  return hasMedia ? 190.0 : 80.0;
}

@end
