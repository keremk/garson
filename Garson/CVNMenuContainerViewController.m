//
//  CVNMenuContainerViewController.m
//  Garson
//
//  Created by Kerem Karatal on 4/11/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuContainerViewController.h"
#import "CVNMenuSectionsViewController.h"
#import "CVNMenuItemsViewController.h"
#import "CVNCoverFlowLayout.h"
#import <GarsonAPI/CVNRestaurant.h>

#import <ReactiveCocoa/RACEXTScope.h>

@interface CVNMenuContainerViewController ()
@property(nonatomic, strong) CVNMenuSectionsViewController *menuSectionsVC;
@property(nonatomic, strong) CVNMenuItemsViewController *menuItemsVC;
@property(nonatomic, assign) CGPoint menuSectionsViewCenter;
@property(nonatomic, assign) CGPoint menuItemsViewCenter;

@property(nonatomic, strong) CVNRestaurantMenu *restaurantMenu;

@end

  // http://www.idev101.com/code/User_Interface/sizes.html
static const CGFloat kMenuSectionsViewYOffset = 64.0f;
static const CGFloat kMenuSectionsViewHeight = 120.0f;

@implementation CVNMenuContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  if (self.menuSectionsVCStoryboardId) {
    self.menuSectionsVC = [self.storyboard instantiateViewControllerWithIdentifier:self.menuSectionsVCStoryboardId];
    self.menuSectionsVC.delegate = self;
  }
  
  if (self.menuItemsVCStoryboardId) {
    self.menuItemsVC = [self.storyboard instantiateViewControllerWithIdentifier:self.menuItemsVCStoryboardId];
  }
  CGRect viewBounds;
  if (self.view) {
    viewBounds = self.view.bounds;
  }
  
  CGRect menuSectionsViewFrame = CGRectMake(0.0, kMenuSectionsViewYOffset, viewBounds.size.width, kMenuSectionsViewHeight);
  CGRect menuItemsViewFrame = CGRectMake(0.0, kMenuSectionsViewYOffset + kMenuSectionsViewHeight, viewBounds.size.width, viewBounds.size.height - kMenuSectionsViewHeight);
  self.menuSectionsViewCenter = CGPointMake(CGRectGetMidX(menuSectionsViewFrame), CGRectGetMidY(menuSectionsViewFrame));
  self.menuItemsViewCenter = CGPointMake(CGRectGetMidX(menuItemsViewFrame), CGRectGetMidY(menuItemsViewFrame));
  
  [self presentMenuSectionsViewControllerInFrame:menuSectionsViewFrame];
  [self presentMenuItemsViewControllerInFrame:menuItemsViewFrame];
}

- (void) presentMenuSectionsViewControllerInFrame:(CGRect) frame {
  if(self.menuSectionsVC){
    [self removeChildViewController:self.menuSectionsVC];
  }
  [self presentChildViewController:self.menuSectionsVC];
  self.menuSectionsVC.view.frame = frame;
  CVNCoverFlowLayout *coverFlowLayout = [[CVNCoverFlowLayout alloc] init];
  [self.menuSectionsVC.collectionView setCollectionViewLayout:coverFlowLayout];
}

- (void) presentMenuItemsViewControllerInFrame:(CGRect) frame {
  if(self.menuItemsVC) {
    [self removeChildViewController:self.menuItemsVC];
  }
  [self presentChildViewController:self.menuItemsVC];
  self.menuItemsVC.view.frame = frame;
}


-(void)presentChildViewController:(UIViewController *)viewController {
  [self addChildViewController:viewController];
  viewController.view.frame = self.view.frame;
  [self.view addSubview:viewController.view];
  [viewController didMoveToParentViewController:self];
}

- (void) removeChildViewController:(UIViewController *) viewController {
  [viewController willMoveToParentViewController:nil];
  [viewController.view removeFromSuperview];
  [viewController removeFromParentViewController];
}



- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  CVNRestaurant *restaurant = [CVNRestaurant currentRestaurant];
  @weakify(self);
  [restaurant currentMenuWithSuccess:^(CVNRestaurantMenu *menu) {
    @strongify(self);
    self.restaurantMenu = menu;
    self.menuSectionsVC.restaurantMenu = menu;
    NSDictionary *itemsAndOffsets = [self flattenSectionsToItemsForMenu:menu];
    self.menuItemsVC.menuItems = [itemsAndOffsets objectForKey:@"items"];
    self.menuItemsVC.itemOffsetsPerSection = [itemsAndOffsets objectForKey:@"offsets"];
    self.menuSectionsVC.order = self.order;
//    self.menuItemsVC.menuSection = [menu.sections objectAtIndex:0];
  } failure:^(NSError *error) {
    
  }];
}

- (NSDictionary *) flattenSectionsToItemsForMenu:(CVNRestaurantMenu *) menu {
  NSMutableArray *items = [NSMutableArray array];
  NSMutableArray *sectionOffsets = [NSMutableArray array];
  
  __block NSInteger offset = 0;
  [menu.sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSNumber *offsetNumber = [NSNumber numberWithInteger:offset];
    [sectionOffsets addObject:offsetNumber];

    CVNMenuSection *menuSection = (CVNMenuSection *) obj;
    [items addObjectsFromArray:menuSection.items];
    offset = offset + [menuSection.items count];
  }];
  return @{@"items": items, @"offsets": sectionOffsets};
}

- (void) setOrder:(CVNOrder *)order {
  if (_order != order) {
    _order = order;
    self.menuItemsVC.order = self.order;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) didSelectMenuSection:(CVNMenuSection *) menuSection atIndex:(NSUInteger) sectionIndex{
//  self.menuItemsVC.menuSection = menuSection;
  NSNumber *scrollToIndexNumber = [self.menuItemsVC.itemOffsetsPerSection objectAtIndex:sectionIndex];
  NSIndexPath *scrollToIndex = [NSIndexPath indexPathForRow:[scrollToIndexNumber integerValue] inSection:0];
  [self.menuItemsVC.tableView scrollToRowAtIndexPath:scrollToIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end