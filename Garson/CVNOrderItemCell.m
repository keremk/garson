//
//  CVNOrderItemCell.m
//  Garson
//
//  Created by Kerem Karatal on 3/30/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNOrderItemCell.h"

@interface CVNOrderItemCell()
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@end

@implementation CVNOrderItemCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      // Initialization code
  }
  return self;
}

- (void) awakeFromNib {
  // Initialization code
  [super awakeFromNib];
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}


@end
