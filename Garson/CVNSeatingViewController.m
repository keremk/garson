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

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIButton+AFNetworking.h>

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface CVNSeatingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *seatingButton;
@property (nonatomic, strong) NSMutableArray *userTiles;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, assign) CGFloat currentSpacingAngle;
@property (nonatomic, assign) CGFloat startingAngle;
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
  [self setupSeatingButton];
  [self startWatchingForSeatingAreas];
  [self setupTopBar];
#ifdef DEBUG
  [self testAddingUserTiles];
#endif
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

- (void) startWatchingForSeatingAreas {
  // Setup Estimote
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

- (void) addUserTileForUser:(CVNUser *) user
                 centeredAt:(CGPoint) center
                   animated:(BOOL) animated
                  withDelay:(CGFloat) delay {
  CVNUserTile *userTile = [CVNUserTile userTile];
  userTile.center = center;
  userTile.userId = user.userId;
  userTile.imageURL = user.imageURL;
  [userTile addTarget:self action:@selector(userTileSelected:)];
  
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

- (IBAction)userTileSelected:(id)sender {
  [self performSegueWithIdentifier:@"UserOrders" sender:self];
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
