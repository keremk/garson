//
//  CVNMenuItemCell.h
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVNMenuItemCell;

@protocol CVNMenuItemDataChange
- (void) menuItemCell:(CVNMenuItemCell *) cell itemCountChanged:(NSInteger) itemCount;
@end

@interface CVNMenuItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UIStepper *itemCountStepper;

@property (weak, nonatomic) id<CVNMenuItemDataChange> delegate;
@property (assign, nonatomic) NSInteger itemIndex;

- (void) updateItemCountLabelWithCount:(NSInteger) count;
@end
