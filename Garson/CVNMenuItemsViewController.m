//
//  CVNRestaurantMenuViewControllerTableViewController.m
//  Garson
//
//  Created by Kerem Karatal on 3/30/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuItemsViewController.h"
#import "CVNMenuItemCell.h"

#import <GarsonAPI/CVNMenuItem.h>

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CVNMenuItemsViewController ()

@end

@implementation CVNMenuItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    self.menuItems = [NSArray array];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.menuSection = nil;
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (self.menuSection) {
    self.menuItems = self.menuSection.items;
  }

  return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CVNMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
  
  // Configure the cell...
  if (self.menuSection) {
    self.menuItems = self.menuSection.items;
  }
  CVNMenuItem *menuItem = [self.menuItems objectAtIndex:indexPath.row];
  
  cell.delegate = self;
  cell.itemIndex = indexPath.row;
  cell.titleLabel.text = menuItem.name;
  cell.descriptionLabel.text = menuItem.description;
  [cell.itemImageView setImageWithURL:menuItem.imageURL];
  cell.priceLabel.text = [menuItem formattedPrice];
  
  NSInteger orderCount = [self.order itemCountForMenuItem:menuItem];
  [cell updateItemCountLabelWithCount:orderCount];
  return cell;
}

- (void) menuItemCell:(CVNMenuItemCell *) cell itemCountChanged:(NSInteger) itemCount {
  [self updateOrderForItemIndex: cell.itemIndex forItemCount:itemCount];
}

- (void) updateOrderForItemIndex:(NSInteger) itemIndex forItemCount:(NSInteger) itemCount {
  CVNMenuItem *menuItem = [self.menuItems objectAtIndex:itemIndex];
  [self.order addMenuItem:menuItem forItemCount:itemCount];
  [self.order.delegate didChangeOrder:self.order];
}

@end
