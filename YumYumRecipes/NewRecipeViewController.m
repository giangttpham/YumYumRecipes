//
//  RecipeDetailViewController.m
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "NewRecipeViewController.h"

@interface NewRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addIngredientButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property IBOutlet UITextView *activeField;


@end

@implementation NewRecipeViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)cancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.recipe.managedObjectContext deleteObject:self.recipe];
    [self.delegate newRecipeViewController:self didAddRecipe:nil];
}
/*
- (IBAction)addIngredientBtnPressed:(id)sender {
    CGPoint currButtonCenter = self.addIngredientButton.center;
    
    CGRect frame = CGRectMake(30,currButtonCenter.y, 200, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:17.0];
    textField.placeholder = @"Suchen";
    textField.backgroundColor = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;

    [self.view addSubview:textField];
    currButtonCenter.y += 50;
    self.addIngredientButton.center = currButtonCenter;
    CGPoint currTextViewCenter = self.instructionTextView.center;
    currTextViewCenter.y += 50;
    self.instructionTextView.center = currTextViewCenter;
}
*/
- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    //NSManagedObject *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    
//    //[self.recipe setValue:self.nameTextField.text forKey:@"name"];
//    [self.recipe setValue:self.prepTimeTextField.text forKey:@"prepTime"];
//    [self.recipe setValue:self.instructionTextView.text forKey:@"instructions"];
//    self.recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
    self.recipe.name = self.nameTextField.text;
    self.recipe.prepTime = self.prepTimeTextField.text;
    self.recipe.instructions = self.instructionTextView.text;
    self.recipe.ingredients = self.ingredientTextView.text;
    
    CGRect rect = CGRectMake(0,0,100,100);
    UIGraphicsBeginImageContext( rect.size );
    [self.recipeImage.image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImagePNGRepresentation(newImage);
    //NSData *imageData = UIImagePNGRepresentation(self.recipeImage.image);
    //NSData *imageData = UIImageJPEGRepresentation(self.recipeImage.image, QUALITY);
    //[self.recipe setValue:imageData forKey:@"image"];
    self.recipe.image = imageData;
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate newRecipeViewController:self didAddRecipe:self.recipe];

}

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

- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
    self.activeField = textView;
    textView.textColor = [UIColor blackColor];
    [self animateTextView: YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Green Background.jpg"]  ];
    self.ingredientTextView.delegate = self;
    self.instructionTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }




- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (IBAction)doneEditingButtonPressed:(id)sender {
    [self.instructionTextView resignFirstResponder];
    [self.ingredientTextView resignFirstResponder];
}

@end
