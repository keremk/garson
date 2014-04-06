//
//  CVFirstViewController.h
//  Garson
//
//  Created by Kerem Karatal on 11/23/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVNUserTile.h"

#import <EstimoteSDK/ESTBeaconManager.h>

@interface CVNSeatingViewController : UIViewController<CVNUserSelection, ESTBeaconManagerDelegate>

@end
