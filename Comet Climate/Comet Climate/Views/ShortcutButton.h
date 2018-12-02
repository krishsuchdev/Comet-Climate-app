//
//  ShortcutButton.h
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface ShortcutButton : UIButton

@property (nonatomic) IBInspectable BOOL roundedCorners;
@property (nonatomic) IBInspectable NSInteger labelNumberOfLines;

@property (nonatomic) IBInspectable NSString *tapURL;

@end

NS_ASSUME_NONNULL_END
