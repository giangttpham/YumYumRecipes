//
//  RecipeDetailViewController.h
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@interface NewRecipeViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)choosePhotoBtnPressed:(id)sender;
- (IBAction)takePhotoBtnPressed:(id)sender;


@end
