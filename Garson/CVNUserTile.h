//
//  CVNUserTile.h
//  Garson
//
//  Created by Kerem Karatal on 3/26/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVNUserTile : UIView
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userDisplayName;
@property(nonatomic, strong) NSURL *imageURL;

+ (instancetype) userTile;
- (void)addTarget:(id) target action:(SEL)action;
@end
