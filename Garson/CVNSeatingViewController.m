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

#ifdef DEBUG
  [self testAddingUserTiles];
#endif
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
  __block NSTimeInterval delay = 0.0;
  [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // Check if tile is created
    CVNUser *user = (CVNUser *) obj;
    if (![self isUserTileCreatedForUserId:user.userId]) {
      // Add the tile
      CGRect position = [self calculatePositionToAddAround:seatingAreaFrame];
//      CVNUserTile *userTile = [[CVNUserTile alloc] initWithFrame:position];
      CGRect positionStart = CGRectMake(position.origin.x, position.origin.y, position.size.width/20.0, position.size.height/20.0);
      UIButton *userTile = [[UIButton alloc] initWithFrame:positionStart];
      userTile.layer.masksToBounds = YES;
      userTile.layer.borderColor = [[UIColor colorWithRed:0.99f green:0.50f blue:0.41f alpha:1.0f] CGColor];
      userTile.layer.borderWidth = 5.0f;
      [userTile addTarget:self action:@selector(userTileSelected:) forControlEvents:UIControlEventTouchUpInside];
      [userTile setImageForState:UIControlStateNormal withURL:user.imageURL];
      [self.userTiles addObject:userTile];
      [self.view addSubview:userTile];
      [UIView animateWithDuration:0.50f
                            delay:delay
           usingSpringWithDamping:0.6
            initialSpringVelocity:0.8
                          options:UIViewAnimationOptionCurveEaseIn animations:^{
                            userTile.layer.cornerRadius = CGRectGetHeight(position) / 2.0;
                            [userTile setFrame:position];
                          } completion:^(BOOL finished) {
                            
                          }];
//      userTile.userId = user.userId;
//      userTile.imageURL = user.imageURL;
      delay += 0.4f;
    }
  }];
}

- (IBAction)userTileSelected:(id)sender {
  [self performSegueWithIdentifier:@"UserOrders" sender:self];
}

- (BOOL) isUserTileCreatedForUserId:(NSString *) userId {
  __block BOOL isCreated = NO;
  
//  [self.userTiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//    CVNUserTile *userTile = (CVNUserTile *) obj;
//    
//    if ([userTile.userId isEqualToString:userId]) {
//      // Found it
//      *stop = YES;
//      isCreated = YES;
//    }
//  }];
  return isCreated;
}

- (CGRect) calculatePositionToAddAround:(CGRect) seatingAreaFrame {
  CGFloat tableRadius = seatingAreaFrame.size.width / 2.0f;
  CGPoint tableCenter = CGPointMake(CGRectGetMidX(seatingAreaFrame),
                                    CGRectGetMidY(seatingAreaFrame));

  CGFloat numOfTiles = (CGFloat)[self.userTiles count];
  
  CGFloat distance = 2.0f * tableRadius;
  
  CGFloat translateX = (CGFloat) (distance * sinf((CGFloat)numOfTiles * self.currentSpacingAngle));
  CGFloat translateY = (CGFloat) (distance * cosf((CGFloat)numOfTiles * self.currentSpacingAngle));
  CGPoint centerPoint = CGPointMake(tableCenter.x + translateX, tableCenter.y - translateY);
  
  NSLog(@"Centerpoint: (%f, %f)", tableCenter.x + distance * sin(numOfTiles * self.currentSpacingAngle), tableCenter.y + distance * cos(numOfTiles * self.currentSpacingAngle));
  CGRect frame = CGRectMake(centerPoint.x - 35, centerPoint.y - 35, 70, 70);
  return frame;

}


@end
