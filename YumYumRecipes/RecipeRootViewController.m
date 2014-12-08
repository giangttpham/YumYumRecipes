//
//  RecipeRootViewController.m
//  YumYumRecipes
//
//  Created by Tra` Beo' on 12/7/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "RecipeRootViewController.h"
#import "RecipeDetailViewController.h"
#import "NewRecipeViewController.h"
#import "Recipe.h"
@interface RecipeRootViewController ()
@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong) NSMutableArray *recipes;
@property NSArray *searchResults;
@end

@implementation RecipeRootViewController
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Recipe"];
    self.recipes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.recipeTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.recipeTableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return self.recipes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    //NSManagedObject *recipe = [self.recipes objectAtIndex:indexPath.row];
    Recipe *recipe = nil;
    if (self.recipeTableView == self.searchDisplayController.searchResultsTableView) {
        recipe = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        recipe = [self.recipes objectAtIndex:indexPath.row];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [recipe valueForKey:@"name"], [recipe valueForKey:@"prepTime"]]];
    [cell.detailTextLabel setText:[recipe valueForKey:@"instructions"]];
    //    cell.imageView.image = [UIImage imageNamed:@"scrambled-eggs.jpg"];
    return cell;
}

- (void)newRecipeViewController:(NewRecipeViewController *)newRecipeViewController didAddRecipe:(Recipe *)recipe {
    
    if (recipe) {
        // show the recipe in the RecipeDetailViewController
        [self performSegueWithIdentifier:@"RecipeDetailSegue" sender:recipe];
    }
    
    // dismiss the RecipeAddViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.recipes filteredArrayUsingPredicate:resultPredicate];
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
