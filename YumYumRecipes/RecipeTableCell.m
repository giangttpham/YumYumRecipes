//
//  RecipeTableViewCell.m
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/3/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeTableCell.h"

@implementation RecipeTableCell
@synthesize nameLabel = _nameLabel;
@synthesize prepTimeLabel = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
