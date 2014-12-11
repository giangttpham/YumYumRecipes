//
//  RecipeListViewController.m
//  YumYumRecipes
//
//  Created by Giang Pham on 12/2/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeListViewController.h"
#import "RecipeDetailViewController.h"
#import "RecipeAddViewController.h"
#import "RecipeTableCell.h"
#import "Recipe.h"
@interface RecipeListViewController ()
@property (strong) NSMutableArray *recipes;
@property NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *prepTime;
@end

@implementation RecipeListViewController
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green-background.jpg"]  ];
    
    //set managed object context for Core Data and fetch data
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
    NSSortDescriptor *titleSorter= [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleSorter, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    self.recipes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //set font for Navigation Bar title
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:20.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.recipes.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell object
    static NSString *CellIdentifier = @"Cell";
    RecipeTableCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Recipe *recipe = nil;
    //get selected recipe and load data
    recipe = [self.recipes objectAtIndex:indexPath.row];
    cell.nameLabel.text = [recipe valueForKey:@"name"];
    cell.prepTimeLabel.text = [recipe valueForKey:@"prepTime"];
    //format the thumbnail image
    UIImage *recipeImage = [UIImage imageWithData:[recipe valueForKey:@"image"]];
    CGRect rect = CGRectMake(0,0,80,80);
    UIGraphicsBeginImageContext( rect.size );
    [recipeImage drawInRect:rect];
    recipeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = recipeImage;
    
    return cell;
}

- (void)newRecipeViewController:(RecipeAddViewController *)newRecipeViewController didAddRecipe:(Recipe *)recipe {
    
    if (recipe) {
        // show the recipe in the RecipeDetailViewController
        [self performSegueWithIdentifier:@"RecipeDetailSegue" sender:recipe];
    }
    
    // dismiss the RecipeAddViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.recipes objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove recipe from table view
        [self.recipes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"RecipeDetailSegue"]) {
        //if recipe is selected, open RecipeDetailViewController and load data
        RecipeDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Recipe *currRecipe = nil;
        if ([sender isKindOfClass:[Recipe class]])
            currRecipe = sender;
        else {
            [self.recipes objectAtIndex:indexPath.row];
            currRecipe = [self.recipes objectAtIndex:indexPath.row];
        }
        detailVC.recipe = currRecipe;
    }
    
    if ([[segue identifier] isEqualToString:@"NewRecipeSegue"]) {
        //if add button was selected, open RecipeAddViewController
        Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:[self managedObjectContext]];
        RecipeAddViewController* newVC = segue.destinationViewController;
        newVC.recipe = newRecipe;
        newVC.delegate = self;
    }
}

@end
