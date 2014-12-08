//
//  RecipeDetailViewController.m
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;

@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@end

@implementation RecipeDetailViewController

//- (NSManagedObjectContext *)managedObjectContext
//{
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.nameLabel.text = self.nameText;
//    self.prepTimeLabel.text = self.prepTimeText;
//    self.instructionTextView.text = self.instructionsText;
//    self.imageView.image = [UIImage imageWithData:self.recipeImage];
    self.nameLabel.text = self.recipe.name;
    self.prepTimeLabel.text = self.recipe.prepTime;
    self.ingredientTextView.text = self.recipe.ingredients;
    self.instructionTextView.text = self.recipe.instructions;
    self.imageView.image = [UIImage imageWithData:self.recipe.image];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
