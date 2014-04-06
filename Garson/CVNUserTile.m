//
//  CVNUserTile.m
//  Garson
//
//  Created by Kerem Karatal on 3/26/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNUserTile.h"
#import <AFNetworking/UIButton+AFNetworking.h>

@interface CVNUserTile()
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
 
@end

@implementation CVNUserTile

+ (instancetype) userTile {
  CVNUserTile *userTile = [[[NSBundle mainBundle] loadNibNamed:@"CVNUserTile" owner:nil options:nil] lastObject];
  
  // make sure customView is not nil or the wrong class!
  if ([userTile isKindOfClass:[CVNUserTile class]])
    return userTile;
  else
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
    [self setupImageButton];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setupImageButton];
  }
  return self;
}

- (void) setupImageButton {  
  self.userImageButton.layer.masksToBounds = YES;
  self.userImageButton.layer.borderColor = [[UIColor colorWithRed:0.99f green:0.50f blue:0.41f alpha:1.0f] CGColor];
  self.userImageButton.layer.borderWidth = 5.0f;
  self.userImageButton.layer.cornerRadius = self.bounds.size.height / 2.0f;
  [self.userImageButton addTarget:self action:@selector(tileSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setImageURL:(NSURL *)imageURL {
  if (imageURL != _imageURL) {
    _imageURL = imageURL;
    [self.userImageButton setImageForState:UIControlStateNormal withURL:imageURL];
    [self setupImageButton]; // Needs to be called here as well.
  }
}

- (IBAction)tileSelected:(id)sender {
  [self.delegate didSelectUserTile:self];
}

@end
