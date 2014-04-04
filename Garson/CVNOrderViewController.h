//
//  CVNOrderViewController.h
//  Garson
//
//  Created by Kerem Karatal on 3/28/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVNOrderSummaryView.h"
#import <GarsonAPI/CVNUser.h>

@interface CVNOrderViewController : UITableViewController<CVNOrderUpdate, CVNOrderChange>
@property(nonatomic, strong) CVNUser *user;
@end
