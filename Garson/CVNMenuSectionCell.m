//
//  CVNMenuSectionCell.m
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuSectionCell.h"
#import <JBKenBurnsView/JBKenBurnsView.h>

@interface CVNMenuSectionCell()
@property(nonatomic, weak) JBKenBurnsView *kenBurnsView;
@end

@implementation CVNMenuSectionCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
  }
  return self;
}

- (void) setMenuSection:(CVNMenuSection *)menuSection {
  if (menuSection != self.menuSection) {
    self.menuSection = menuSection;
    [self updateKenBurnsImages];
  }
}

- (void) updateKenBurnsImages {
  
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
