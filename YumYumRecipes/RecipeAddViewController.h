//
//  RecipeDetailViewController.h
//  YumYumRecipes
//
//  Created by Giang Pham on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@import CoreData;

@protocol RecipeAddDelegate;


@interface RecipeAddViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property Recipe *recipe;
@property (nonatomic, unsafe_unretained) id <RecipeAddDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)choosePhotoBtnPressed:(id)sender;
- (IBAction)takePhotoBtnPressed:(id)sender;
@end

@protocol RecipeAddDelegate <NSObject>
- (void)newRecipeViewController:(RecipeAddViewController *)newRecipeViewController didAddRecipe:(Recipe *)recipe;

@end