//
//  CVFirstViewController.m
//  Garson
//
//  Created by Kerem Karatal on 11/23/13.
//  Copyright (c) 2013 CodingVentures. All rights reserved.
//

#import "CVNSeatingViewController.h"
#import "CVNUser.h"
#import "CVNUserTile.h"
#import "CVNSeating.h"
#import "CVNOrderViewController.h"
#import "CVNUtils.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIButton+AFNetworking.h>

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

static const NSInteger kSeatingDistance = 0.2f;

@interface CVNSeatingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *seatingButton;
@property (nonatomic, strong) NSMutableArray *userTiles;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, assign) CGFloat currentSpacingAngle;
@property (nonatomic, assign) CGFloat startingAngle;

@property (nonatomic, strong) CVNSeating *currentSeating;

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@end

@implementation CVNSeatingViewController

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Initial View

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.userTiles = [NSMutableArray array];
  self.currentSpacingAngle = M_PI / 2.0;
  self.startingAngle = M_PI / 2.0; // Start at 90
  
  self.currentSeating = nil;
  [self setupSeatingButton];
  [self setupTopBar];
#ifdef DEBUG
  [self testAddingUserTiles];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self setupBeaconMonitoring];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [self.beaconManager stopRangingBeaconsInRegion:self.region];
}

- (void) setupTopBar {
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
}

- (void) setupSeatingButton {
  self.seatingButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.seatingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  
  @weakify(self);
  self.seatingButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self);
    [self enterSeatingAreaNumber];
    return [RACSignal empty];
  }];
}

- (void) setupBeaconMonitoring {
  self.beaconManager = [[ESTBeaconManager alloc] init];
  self.beaconManager.delegate = self;
  
  /*
   * Creates sample region object (you can additionaly pass major / minor values).
   *
   * We specify it using only the ESTIMOTE_PROXIMITY_UUID because we want to discover all
   * hardware beacons with Estimote's proximty UUID.
   */
  self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                    identifier:@"EstimoteSampleRegion"];
  
  self.region.notifyOnEntry = YES;
  self.region.notifyOnExit = NO;

  self.beaconManager.avoidUnknownStateBeacons = YES;
  
  /*
   * Starts looking for Estimote beacons.
   * All callbacks will be delivered to beaconManager delegate.
   */
  [self.beaconManager startRangingBeaconsInRegion:self.region];
  [self.beaconManager startMonitoringForRegion:self.region];
  [self.beaconManager requestStateForRegion:self.region];
}

#pragma mark - Test Stuff
- (void) testAddingUserTiles {
  CVNSeating *seating = [[CVNSeating alloc] init];
  [seating seating:@"123" willNotifyWhenUsersCheckin:^(NSArray *users) {
    [self updateUserTilesWithUsers:users];
  }];
}

#pragma mark - Manual entry for seating number

- (void) enterSeatingAreaNumber {
  
}

#pragma mark - Proximity Watch

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
  self.beaconsArray = beacons;

  __block float minDistance = 10.0f;
  __block ESTBeacon *selectedBeacon = nil;
  [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    ESTBeacon *beacon = (ESTBeacon *) obj;
    NSLog(@"Beacon Detected %lu, distance: %f", (long)[beacon.minor integerValue], [beacon.distance floatValue]);
    float distance = [beacon.distance floatValue];
    if (distance >= 0 && distance < minDistance) {
      minDistance = distance;
      selectedBeacon = beacon;
    }
  }];
  if (minDistance <= 0.2f) {
    // This is our seat!
    NSInteger restaurantBeaconId = [selectedBeacon.major integerValue];
    NSInteger seatingId = [selectedBeacon.minor integerValue];
    NSLog(@"Beacon is closer: %lu", (long) seatingId);
    if (!(self.currentSeating.seatingId == seatingId)) {
      NSLog(@"New Seating");
      [self clearUserTiles];
      @weakify(self);
      [CVNSeating findBySeatingId:seatingId success:^(CVNSeating *seating) {
        @strongify(self);
        [seating.registeredUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          CVNUser *testUser = (CVNUser *)obj;
          NSLog(@"User Id: %@", testUser.displayName);
        }];
        [self.seatingButton setTitle:[NSString stringWithFormat:@"Table\n%lu", (long)seatingId] forState:UIControlStateNormal];
        self.currentSeating = seating;
        self.startingAngle = M_PI / 2.0; // Start at 90

        [self updateUserTilesWithUsers:seating.registeredUsers];
      } failure:^(NSError *error) {
        
      }];
    }
  }
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
  UILocalNotification *notification = [UILocalNotification new];
  notification.alertBody = @"Enter region notification";
  NSLog(@"Region entered");
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
  UILocalNotification *notification = [UILocalNotification new];
  notification.alertBody = @"Exit region notification";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ESTBeaconRegion *)region {
  if(state == CLRegionStateInside) {
    NSLog(@"In the region..");
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Enter region notification";
    NSLog(@"Region entered");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

  }
  else {
    NSLog(@"Outside the region..");
  }
}

- (void) isCloseToSeatingArea:(NSInteger) seatingNo {
  // Update the view with table number
  
  [self.seatingButton setTitle:[NSString stringWithFormat:@"Table\n%d", seatingNo] forState:UIControlStateNormal];
}

#pragma mark - User Tiles

- (void) updateUserTilesWithUsers:(NSArray *) users {
  CGRect seatingAreaFrame = self.seatingButton.frame;
  CGFloat distance = seatingAreaFrame.size.height;
  CGPoint seatingCenter = self.seatingButton.center;
  __block NSTimeInterval delay = 0.4f;
  [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // Check if tile is created
    CVNUser *user = (CVNUser *) obj;
    if (![self isUserTileCreatedForUserId:user.userId]) {
      // Add the tile
      CGPoint tileCenter = [self calculateCenterPointAround:seatingCenter withDistance:distance];
      [self addUserTileForUser:user centeredAt:tileCenter animated:YES withDelay:delay];
      delay += 0.4f;
    }
  }];
}

- (void) clearUserTiles {
  [self.userTiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CVNUserTile *userTile = (CVNUserTile *) obj;
    [userTile removeFromSuperview];
    userTile.delegate = nil;
    [self.userTiles removeObject:userTile];
  }];
  self.userTiles = [NSMutableArray array];
}

- (void) addUserTileForUser:(CVNUser *) user
                 centeredAt:(CGPoint) center
                   animated:(BOOL) animated
                  withDelay:(CGFloat) delay {
  CVNUserTile *userTile = [CVNUserTile userTile];
  userTile.user = user;
  userTile.center = center;
  userTile.userId = user.userId;
  userTile.imageURL = user.imageURL;
  userTile.delegate = self;
  
  [self.userTiles addObject:userTile];
  [self.view addSubview:userTile];
  
  if (animated) {
    userTile.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.75f
                          delay:delay
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                          userTile.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        } completion:^(BOOL finished) {
                        }];
  }
}

- (void) didSelectUserTile:(CVNUserTile *)userTile {
  [self performSegueWithIdentifier:@"UserOrders" sender:userTile];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  
  if ([segue.identifier isEqualToString:@"UserOrders"]) {
    CVNUserTile *userTile = (CVNUserTile *) sender;
    CVNUser *user = userTile.user;
    CVNOrderViewController *orderVC = [segue destinationViewController];
    orderVC.user = user;
  }
}

- (BOOL) isUserTileCreatedForUserId:(NSString *) userId {
  __block BOOL isCreated = NO;
  
  [self.userTiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CVNUserTile *userTile = (CVNUserTile *) obj;
    
    if ([userTile.userId isEqualToString:userId]) {
      // Found it
      *stop = YES;
      isCreated = YES;
    }
  }];
  return isCreated;
}

- (CGPoint) calculateCenterPointAround:(CGPoint) tableCenter withDistance:(CGFloat) distance{
  CGFloat numOfTiles = (CGFloat)[self.userTiles count];
  
  CGFloat translateX = (CGFloat) (distance * sinf((CGFloat)numOfTiles * self.currentSpacingAngle));
  CGFloat translateY = (CGFloat) (distance * cosf((CGFloat)numOfTiles * self.currentSpacingAngle));
  CGPoint centerPoint = CGPointMake(tableCenter.x + translateX, tableCenter.y - translateY);
  return centerPoint;
}


@end
