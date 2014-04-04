//
//  CVNUserTile.h
//  Garson
//
//  Created by Kerem Karatal on 3/26/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNUser.h>

@class CVNUserTile;

@protocol CVNUserSelection<NSObject>
- (void) didSelectUserTile:(CVNUserTile *) userTile;
@end

@interface CVNUserTile : UIView
@property(nonatomic, copy) CVNUser *user;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userDisplayName;
@property(nonatomic, strong) NSURL *imageURL;
@property(nonatomic, weak) id<CVNUserSelection> delegate;

+ (instancetype) userTile;
@end
