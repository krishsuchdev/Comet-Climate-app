//
//  RootPageViewController.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

- (void)updateViews;

@end

NS_ASSUME_NONNULL_END
