//
//  CVNOrderSummaryView.m
//  Garson
//
//  Created by Kerem Karatal on 3/30/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNOrderSummaryView.h"

@interface CVNOrderSummaryView()
@property (weak, nonatomic) IBOutlet UILabel *barSubtotalField;
@property (weak, nonatomic) IBOutlet UILabel *foodSubtotalField;
@property (weak, nonatomic) IBOutlet UILabel *taxField;
@property (weak, nonatomic) IBOutlet UILabel *sfhcField;
@property (weak, nonatomic) IBOutlet UILabel *totalField;

@property (weak, nonatomic) IBOutlet UILabel *barSubtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodSubtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *sfhcLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@end

static NSString * const kFontRegular = @"Lato-Regular";
static NSString * const kFontBold = @"Lato-Bold";
static NSString * const kFontBlack = @"Lato-Black";

@implementation CVNOrderSummaryView

+ (instancetype) orderSummaryView {
  CVNOrderSummaryView *orderSummary = [[[NSBundle mainBundle] loadNibNamed:@"CVNOrderSummaryView" owner:nil options:nil] lastObject];
  
  // make sure customView is not nil or the wrong class!
  if ([orderSummary isKindOfClass:[CVNOrderSummaryView class]])
    return orderSummary;
  else
    return nil;
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self initializeView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initializeView];
  }
  return self;
}

- (void) initializeView {
  [self.barSubtotalLabel setFont:[UIFont fontWithName:kFontBold size:17]];
  [self.foodSubtotalLabel setFont:[UIFont fontWithName:kFontBold size:17]];
  [self.taxLabel setFont:[UIFont fontWithName:kFontBold size:17]];
  [self.sfhcLabel setFont:[UIFont fontWithName:kFontBold size:17]];
  [self.totalLabel setFont:[UIFont fontWithName:kFontBold size:17]];

  [self.barSubtotalField setFont:[UIFont fontWithName:kFontRegular size:17]];
  [self.foodSubtotalField setFont:[UIFont fontWithName:kFontRegular size:17]];
  [self.taxField setFont:[UIFont fontWithName:kFontRegular size:17]];
  [self.sfhcField setFont:[UIFont fontWithName:kFontRegular size:17]];
  [self.totalField setFont:[UIFont fontWithName:kFontRegular size:17]];
}

- (void) initializeContent {
  
}
@end
