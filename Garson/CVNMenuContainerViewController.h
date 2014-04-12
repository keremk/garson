//
//  CVNMenuContainerViewController.h
//  Garson
//
//  Created by Kerem Karatal on 4/11/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNMenuSection.h>
#import <GarsonAPI/CVNOrder.h>
#import "CVNMenuSectionsViewController.h"

@interface CVNMenuContainerViewController : UIViewController<CVNMenuSelectionChanged>
@property(nonatomic, strong) NSString *menuSectionsVCStoryboardId;
@property(nonatomic, strong) NSString *menuItemsVCStoryboardId;
@property(nonatomic, strong) CVNOrder *order;
@end
