//
//  RecipeDetailViewController.m
//  YumYumRecipes
//
//  Created by Giang Pham on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *ingredientTextView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@property UIGestureRecognizer *tapper;
@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *context = [self managedObjectContext];
    self.tapper = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapper];
    
    //load data of selected recipe
    self.nameLabel.text = self.recipe.name;
    self.prepTimeLabel.text = self.recipe.prepTime;
    self.ingredientTextView.text = self.recipe.ingredients;
    self.instructionTextView.text = self.recipe.instructions;
    self.imageView.image = [UIImage imageWithData:self.recipe.image];
    self.noteTextView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green-background.jpg"]  ];
    self.noteTextView.text = self.recipe.note;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        //back button was pressed, save note to recipe
        self.recipe.note = self.noteTextView.text;
    }
    [super viewWillDisappear:animated];
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

// move screen up to show text view from behind keyboard
- (void) textViewDidBeginEditing:(UITextView *) textView {
    textView.textColor = [UIColor blackColor];
    [self animateTextView: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//turn off keyboard if tap outside of text view
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end
