//
//  CVNMenuSectionsViewController.h
//  Garson
//
//  Created by Kerem Karatal on 3/31/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNOrder.h>


@interface CVNMenuSectionsViewController : UICollectionViewController
@property(nonatomic, strong) CVNOrder *order;
@end
