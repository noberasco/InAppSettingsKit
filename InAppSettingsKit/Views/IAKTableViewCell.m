//
//  IAKTableViewCell.m
//  InAppSettingsKit
//
//  Created by thorin on 26/09/13.
//  Copyright (c) 2013 InAppSettingsKit. All rights reserved.
//

#import "IAKTableViewCell.h"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSelectedButtonColor [UIColor colorWithRed:26.0/255.0 green:124.0/255.0 blue:218.0/255.0 alpha:1.0]

@implementation IAKTableViewCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  
  if (IOS_VERSION >= 7)
    if (self != nil)
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
  
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (IOS_VERSION >= 7)
    if (self != nil)
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (IOS_VERSION >= 7)
    if (self != nil)
      if (self.selectionStyle == UITableViewCellSelectionStyleBlue)
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
  
  return self;
}

- (void)setSelectionStyle:(UITableViewCellSelectionStyle)selectionStyle {
  [super setSelectionStyle:selectionStyle];
  
  if (IOS_VERSION >= 7)
    switch (selectionStyle) {
      case UITableViewCellSelectionStyleBlue: {
        UIView *bgColorView = [[[UIView alloc] init] autorelease];
        
        bgColorView.backgroundColor     = kSelectedButtonColor;
        bgColorView.layer.masksToBounds = YES;
        
        self.selectedBackgroundView = bgColorView;
        
        break;
      }
      default: {
        self.selectedBackgroundView = nil;
        
        break;
      }
    }
}

@end
