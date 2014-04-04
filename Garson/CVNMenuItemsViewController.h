//
//  CVNRestaurantMenuViewControllerTableViewController.h
//  Garson
//
//  Created by Kerem Karatal on 3/30/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNOrder.h>

#import "CVNMenuItemCell.h"

@interface CVNMenuItemsViewController : UITableViewController<CVNMenuItemDataChange>
@property(nonatomic, strong) NSArray *menuItems;
@property(nonatomic, strong) CVNOrder *order;
@end
