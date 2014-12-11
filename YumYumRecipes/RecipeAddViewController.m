//
//  RecipeDetailViewController.m
//  YumYumRecipes
//
//  Created by Giang Pham on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeAddViewController.h"

@interface RecipeAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property UIGestureRecognizer *tapper;
@end

@implementation RecipeAddViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green-background.jpg"]  ];
    self.ingredientTextView.delegate = self;
    self.instructionTextView.delegate = self;
    self.tapper = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)cancel:(id)sender {
    [self.recipe.managedObjectContext deleteObject:self.recipe];
    [self.delegate newRecipeViewController:self didAddRecipe:nil];
}

- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //save data to the new recipe
    self.recipe.name = self.nameTextField.text;
    self.recipe.prepTime = self.prepTimeTextField.text;
    self.recipe.instructions = self.instructionTextView.text;
    self.recipe.ingredients = self.ingredientTextView.text;
    self.recipe.note = @"Note:";
    CGRect rect = CGRectMake(0,0,100,100);
    UIGraphicsBeginImageContext( rect.size );
    [self.recipeImage.image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(newImage);
    self.recipe.image = imageData;
    NSError *error = nil;
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    //delegate to RecipeListViewController to open the new recipe detail
    [self.delegate newRecipeViewController:self didAddRecipe:self.recipe];

}

//Button actions to add new photo
- (IBAction)choosePhotoBtnPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhotoBtnPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.recipeImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


//turned off keyboard if click outside text views
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

// move screen up to show text view
- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
    textView.textColor = [UIColor blackColor];
    [self animateTextView: YES];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 150;
    const float movementDuration = 0.3f;
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
