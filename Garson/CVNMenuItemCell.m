//
//  CVNMenuItemCell.m
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuItemCell.h"
@interface CVNMenuItemCell()
@property (weak, nonatomic) IBOutlet UIStepper *itemCountStepper;
@end

@implementation CVNMenuItemCell {
  NSInteger _internalCount;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)counterValueChanged:(id)sender {
  UIStepper *stepper = (UIStepper *) sender;
  self.itemCountLabel.text = [NSString stringWithFormat:@"%lu Items", (long)stepper.value ];
  [self.delegate menuItemCell:self itemCountChanged:(NSInteger) stepper.value];
}

@end
