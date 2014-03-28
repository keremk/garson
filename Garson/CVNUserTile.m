//
//  CVNUserTile.m
//  Garson
//
//  Created by Kerem Karatal on 3/26/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNUserTile.h"
#import <AGMedallionView/AGMedallionView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation CVNUserTile

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
    self.userImageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:self.userImageView];
  }
  return self;
}

- (void) setImageURL:(NSURL *)imageURL {
  if (imageURL != _imageURL) {
    _imageURL = imageURL;
    [self.userImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"User-Pic"]];
    [self setNeedsDisplay];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
