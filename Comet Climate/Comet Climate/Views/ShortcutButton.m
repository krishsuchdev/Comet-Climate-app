//
//  ShortcutButton.m
//  Comet Climate
//
//  Created by Krish Suchdev on 11/21/18.
//  Copyright © 2018 Krish Suchdev. All rights reserved.
//

#import "ShortcutButton.h"

@implementation ShortcutButton

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Rounding the corners of the button
  self.layer.cornerRadius = self.roundedCorners ? 10.0 : 0.0;
  
  // Allow for multi-line buttons
  if (self.titleLabel) {
    self.titleLabel.numberOfLines = self.labelNumberOfLines;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
  }
}

@end
