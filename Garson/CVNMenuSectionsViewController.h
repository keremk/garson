//
//  CVNMenuSectionsViewController.h
//  Garson
//
//  Created by Kerem Karatal on 3/31/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNOrder.h>
#import <GarsonAPI/CVNMenuSection.h>
#import <GarsonAPI/CVNRestaurantMenu.h>

@protocol CVNMenuSelectionChanged <NSObject>
- (void) didSelectMenuSection:(CVNMenuSection *) menuSection atIndex:(NSUInteger) sectionIndex;
@end

@interface CVNMenuSectionsViewController : UICollectionViewController<UIScrollViewDelegate>
@property(nonatomic, strong) CVNOrder *order;
@property(nonatomic, strong) CVNRestaurantMenu *restaurantMenu;
@property(nonatomic, assign) id<CVNMenuSelectionChanged> delegate;
@end
