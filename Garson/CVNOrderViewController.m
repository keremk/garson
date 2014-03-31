//
//  CVNOrderViewController.m
//  Garson
//
//  Created by Kerem Karatal on 3/28/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNOrderViewController.h"
#import "CVNOrderSummaryView.h"
#import "CVNOrderItemCell.h"

#import <GarsonAPI/CVNOrder.h>
#import <GarsonAPI/CVNOrderItem.h>

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CVNOrderViewController ()
@end

@implementation CVNOrderViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.tableHeaderView = [CVNOrderSummaryView orderSummaryView];
  [self setupTopBar];
}

- (void) setupTopBar {
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  NSUInteger numOfItems = [[[CVNOrder currentOrder] orderItems] count];

  return numOfItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CVNOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell" forIndexPath:indexPath];
  NSArray *orderItems = [[CVNOrder currentOrder] orderItems];
  CVNOrderItem *orderItem = [orderItems objectAtIndex:indexPath.row];
  
  // Configure the cell...
  cell.nameLabel.text = orderItem.name;
  cell.descriptionLabel.text = orderItem.description;
  [cell.itemImageView setImageWithURL:orderItem.imageURL];
  cell.countLabel.text = [orderItem formattedItemCount];
  cell.priceLabel.text = [orderItem formattedPrice];
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the row from the data source
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}
*/

@end
