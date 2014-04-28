//
//  CVNMenuSectionCell.h
//  Garson
//
//  Created by Kerem Karatal on 4/2/14.
//  Copyright (c) 2014 CodingVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GarsonAPI/CVNMenuSection.h>

@interface CVNMenuSectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (strong, nonatomic) CVNMenuSection *menuSection;
@end
