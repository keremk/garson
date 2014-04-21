//
//  CVNMenuItemCell.m
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuItemCell.h"
@interface CVNMenuItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *valueBackground;
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
  UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeftGesture:)];
  leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [self addGestureRecognizer:leftRecognizer];
  
  UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleRightGesture:)];
  rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [self addGestureRecognizer:rightRecognizer];
  
}

- (void)handleLeftGesture:(UIGestureRecognizer *)gestureRecognizer {
  UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *) gestureRecognizer;

  self.itemCountStepper.value -= 1;
  NSLog(@"Swipe Left %f", self.itemCountStepper.value);
  if (self.itemCountStepper.value < 0) {
    self.itemCountStepper.value = 0;
  }
  [self updateItemCountLabelWithCount:self.itemCountStepper.value];
  [self.delegate menuItemCell:self itemCountChanged:(NSInteger) self.itemCountStepper.value];
}

- (void)handleRightGesture:(UIGestureRecognizer *)gestureRecognizer {
  UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *) gestureRecognizer;

  self.itemCountStepper.value += 1;
  NSLog(@"Swipe Right %f", self.itemCountStepper.value);
  [self updateItemCountLabelWithCount:self.itemCountStepper.value];
  [self.delegate menuItemCell:self itemCountChanged:(NSInteger) self.itemCountStepper.value];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void) updateItemCountLabelWithCount:(NSInteger) count {
  if (count == 0) {
    self.itemCountLabel.hidden = YES;
    self.valueBackground.hidden = YES;
  } else {
    self.valueBackground.hidden = NO;
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
