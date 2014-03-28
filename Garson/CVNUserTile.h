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
@property(nonatomic, strong) UIImage *userImage;
@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, copy) NSString *userDisplayName;
@property(nonatomic, strong) NSURL *imageURL;

@end
