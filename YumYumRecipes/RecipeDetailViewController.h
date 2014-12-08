//
//  RecipeDetailViewController.h
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import CoreData;
@interface RecipeDetailViewController : UIViewController
@property NSString *nameText;
@property NSString *prepTimeText;
@property NSString *instructionsText;
@property NSData *recipeImage;
@property Recipe *recipe;
@end
