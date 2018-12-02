//
//  RootPageViewController.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "RootPageViewController.h"
#import "APIManager.h"
#import "WeatherViewController.h"
#import "TwitterViewController.h"
#import "ShortcutsViewController.h"

@interface RootPageViewController ()

@property (strong, nonatomic) NSArray<UIViewController *> *pageList;
@property (nonatomic) NSInteger currentPage;

@end

@implementation RootPageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Start fetches to server in the background
  dispatch_async(dispatch_get_main_queue(), ^{
    [[APIManager sharedInstance] fetchWeather];
    [[APIManager sharedInstance] fetchTwitter];
  });
  
  // Add all tabs of the app to the pageViewController
  NSMutableArray *pageList = [[NSMutableArray alloc] init];
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
  for (NSString *storyboardID in [NSArray arrayWithObjects:@"Weather", @"Twitter", @"Links", nil])
    [pageList addObject:[mainStoryboard instantiateViewControllerWithIdentifier:storyboardID]];
  self.pageList = [NSArray arrayWithArray:pageList];
  
  // Set UIPageViewController datasource after the UIViewController elements have been added to pageList
  self.dataSource = self;
  
  // Setting the current page to the first in the list
  [self setViewControllers:[NSArray arrayWithObject:self.pageList.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:^(BOOL finished) {
  }];
  self.currentPage = 0;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  // Sets the background of the page control view to be transparent so that it blends in with the background
  for (UIView *view in self.view.subviews) {
    if ([view isKindOfClass:UIScrollView.class])
      view.frame = UIScreen.mainScreen.bounds;
    if ([view isKindOfClass:UIPageControl.class])
      view.backgroundColor = UIColor.clearColor;
  }
}

- (void)updateViews {
  // Updates all data displaying view controllers whenever new content has been fetched
  for (UIViewController *viewController in self.pageList) {
    if ([viewController isKindOfClass:WeatherViewController.class])
      [(WeatherViewController *)viewController updatePresentedData];
    if ([viewController isKindOfClass:TwitterViewController.class])
      [(TwitterViewController *)viewController updatePresentedData];
    if ([viewController isKindOfClass:ShortcutsViewController.class])
      [(ShortcutsViewController *)viewController updatePresentedData];
  }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  // Next view controller is the element at the previous index
  NSUInteger index = [self.pageList indexOfObject:viewController] - 1;
  
  // Allows for the page view to wrap on both sides
  index = (index + self.pageList.count) % self.pageList.count;
  
  return [self.pageList objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  // Next view controller is the element at the next index
  NSUInteger index = [self.pageList indexOfObject:viewController] + 1;
  
  // Allows for the page view to wrap on both sides
  index = (index + self.pageList.count) % self.pageList.count;

  return [self.pageList objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  // The dot indicators in the page view should match the number of UIViewController elements in the pageList
  return self.pageList.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  // Displays the first view controller initially
  return [self.pageList indexOfObject:pageViewController.viewControllers.firstObject];
}

@end
