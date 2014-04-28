//
//  CVNMenuItemCell.m
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuItemCell.h"
@interface CVNMenuItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *itemCountBackgroundImage;
@end

@implementation CVNMenuItemCell {
  NSInteger _internalCount;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
  // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void) updateItemCountLabelWithCount:(NSInteger) count {
  if (count == 0) {
    self.itemCountLabel.hidden = YES;
    self.itemCountBackgroundImage.hidden = YES;
  } else {
    self.itemCountBackgroundImage.hidden = NO;
    self.itemCountLabel.hidden = NO;
  }
  self.itemCountStepper.value = count;
  self.itemCountLabel.text = [NSString stringWithFormat:@"%d", count];
}

- (IBAction)counterValueChanged:(id)sender {
  UIStepper *stepper = (UIStepper *) sender;
  NSInteger value = stepper.value;
  [self updateItemCountLabelWithCount:value];
  [self.delegate menuItemCell:self itemCountChanged:(NSInteger) stepper.value];
}

@end
