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

@protocol NewRecipeDelegate;


@interface NewRecipeViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property Recipe *recipe;
@property (nonatomic, unsafe_unretained) id <NewRecipeDelegate> delegate;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)choosePhotoBtnPressed:(id)sender;
- (IBAction)takePhotoBtnPressed:(id)sender;

@end

@protocol NewRecipeDelegate <NSObject>
- (void)newRecipeViewController:(NewRecipeViewController *)newRecipeViewController didAddRecipe:(Recipe *)recipe;

@end