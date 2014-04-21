//
//  CVNOrderViewController.m
//  Garson
//
//  Created by Kerem Karatal on 3/28/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNOrderViewController.h"
#import "CVNOrderItemCell.h"
#import "CVNMenuSectionsViewController.h"
#import "CVNMenuContainerViewController.h"

#import <GarsonAPI/CVNOrder.h>
#import <GarsonAPI/CVNOrderItem.h>

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CVNOrderViewController ()
@end

@implementation CVNOrderViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  CVNOrderSummaryView *orderSummaryView = [CVNOrderSummaryView orderSummaryView];
  orderSummaryView.delegate = self;
  self.tableView.tableFooterView = orderSummaryView;
  [self setupTopBar];
  [self setupCurrentOrder];
}

- (void) setupTopBar {
//  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                forBarMetrics:UIBarMetricsDefault];
//  self.navigationController.navigationBar.shadowImage = [UIImage new];
//  self.navigationController.navigationBar.translucent = YES;
}

- (void) setupCurrentOrder {
  if (self.user.currentOrder == nil) {
    self.user.currentOrder = [[CVNOrder alloc] init];
  }
  self.user.currentOrder.delegate = self;
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
  CVNOrderSummaryView *orderSummaryView = (CVNOrderSummaryView *) self.tableView.tableFooterView;
  orderSummaryView.order = self.user.currentOrder;
  [orderSummaryView updateContent];
  NSUInteger numOfItems = [[self.user.currentOrder orderItems] count];

  return numOfItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CVNOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell" forIndexPath:indexPath];
  NSArray *orderItems = [self.user.currentOrder orderItems];
  CVNOrderItem *orderItem = [orderItems objectAtIndex:indexPath.row];
  
  // Configure the cell...
  cell.nameLabel.text = orderItem.name;
  cell.descriptionLabel.text = orderItem.description;
  [cell.itemImageView setImageWithURL:orderItem.imageURL];
  cell.countLabel.text = [orderItem formattedItemCount];
  cell.priceLabel.text = [orderItem formattedPrice];
  return cell;
}

#pragma mark - CVNOrderUpdate

- (IBAction)add:(id)sender {
  [self performSegueWithIdentifier:@"RestaurantMenuDisplaySegue2" sender:self];
}

- (void) addToOrder {
  [self performSegueWithIdentifier:@"RestaurantMenuDisplaySegue2" sender:self];
}

#pragma mark - CVNOrderChange

- (void) didChangeOrder:(CVNOrder *)order {
  self.user.currentOrder = order;
  [self.tableView reloadData];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    NSArray *orderItems = [self.user.currentOrder orderItems];
    CVNOrderItem *orderItem = [orderItems objectAtIndex:indexPath.row];
    [self.user.currentOrder removeItemByName:orderItem.name];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"RestaurantMenuDisplaySegue"]) {
    CVNMenuSectionsViewController *menuSectionsVC = [segue destinationViewController];
    menuSectionsVC.order = self.user.currentOrder;
  } else if ([segue.identifier isEqualToString:@"RestaurantMenuDisplaySegue2"]) {
    CVNMenuContainerViewController *menuContainerVC = [segue destinationViewController];
    menuContainerVC.order = self.user.currentOrder;
  }

}

@end
