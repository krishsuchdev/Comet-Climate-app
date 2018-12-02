//
//  ShortcutsViewController.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortcutsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

- (void)updatePresentedData;

@end

NS_ASSUME_NONNULL_END
