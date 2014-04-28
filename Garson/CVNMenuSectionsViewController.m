//
//  CVNMenuSectionsViewController.m
//  Garson
//
//  Created by Kerem Karatal on 3/31/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import "CVNMenuSectionsViewController.h"
#import "CVNMenuSectionCell.h"
#import "CVNMenuItemsViewController.h"
#import "CVNCoverFlowLayout.h"

#import <GarsonAPI/CVNRestaurant.h>
#import <GarsonAPI/CVNMenuSection.h>

#import <ReactiveCocoa/RACEXTScope.h>
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface CVNMenuSectionsViewController ()
@property(nonatomic, weak) UIPageControl *pageControl;
@end

@implementation CVNMenuSectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) addPageControl {
  if (self.pageControl == nil) {
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.tintColor = [UIColor whiteColor];
    self.pageControl = pageControl;
    [self updatePageControl:pageControl forNumberOfPages:4];
    [self.view insertSubview:pageControl aboveSubview:self.collectionView];
  } else {
    [self updatePageControl:self.pageControl forNumberOfPages:[[self.restaurantMenu sections] count]];
  }
}

- (void) updatePageControl:(UIPageControl *)pageControl forNumberOfPages:(NSUInteger) pages {
  CGSize size = [pageControl sizeForNumberOfPages:pages];
  CGFloat centeredX = self.view.bounds.size.width - size.width / 2;
  CGFloat y = self.view.bounds.size.height - size.height - 10.0;
  CGRect frame = CGRectMake(centeredX, y, size.width, size.height);
  [pageControl setFrame:frame];
}

- (void) setRestaurantMenu:(CVNRestaurantMenu *) menu {
  if (menu != self.restaurantMenu) {
    self.restaurantMenu = menu;
    [self addPageControl];
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSInteger itemCount = 0;
  if (self.restaurantMenu != nil) {
    itemCount = [[self.restaurantMenu sections] count];
  }
  return itemCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CVNMenuSectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuSectionCell"
                                                                       forIndexPath:indexPath];
  
  cell.layer.cornerRadius = 10;

  NSArray *menuSections = [self.restaurantMenu sections];
  CVNMenuSection *menuSection = [menuSections objectAtIndex:indexPath.row];
  [cell.sectionImageView setImageWithURL:menuSection.imageURL];
  cell.sectionTitleLabel.text = menuSection.title;
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *menuSections = [self.restaurantMenu sections];
  CVNMenuSection *menuSection = [menuSections objectAtIndex:indexPath.row];
  
  [self.delegate didSelectMenuSection:menuSection atIndex:indexPath.row];
//  [self performSegueWithIdentifier:@"MenuItemsDisplaySegue" sender:menuSection];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.

  if ([segue.identifier isEqualToString:@"MenuItemsDisplaySegue"]) {
    CVNMenuItemsViewController *menuItemsVC = [segue destinationViewController];
    CVNMenuSection *section = (CVNMenuSection *) sender;
    menuItemsVC.menuItems = section.items;
    menuItemsVC.order = self.order;
  }
}

#pragma mark - ScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat offset = scrollView.contentOffset.x;
  CVNCoverFlowLayout *layout = (CVNCoverFlowLayout *) self.collectionViewLayout;
  CGFloat spacing = layout.itemSize.width - layout.minimumLineSpacing;
  NSUInteger selectedItemNo = ceil(offset/spacing);
  NSLog(@"Stopped at %f, Selected = %d", offset, selectedItemNo);
  NSArray *menuSections = [self.restaurantMenu sections];
  CVNMenuSection *menuSection = [menuSections objectAtIndex:selectedItemNo];

  [self.delegate didSelectMenuSection:menuSection atIndex:selectedItemNo];
}

@end
