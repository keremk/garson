//
//  CVNOrderSummaryView.h
//  Garson
//
//  Created by Kerem Karatal on 3/30/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNOrder.h>

@protocol CVNOrderUpdate <NSObject>
-(void) addToOrder;
-(void) order;
@end

@interface CVNOrderSummaryView : UIView
+ (instancetype) orderSummaryView;

@property(nonatomic, assign) id<CVNOrderUpdate> delegate;
@property(nonatomic, strong) CVNOrder *order;

- (void) updateContent;
@end
