//
//  Recipe.h
//  YumYumRecipes
//
//  Created by Giang Pham on 12/7/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * prepTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) NSString * note;

@end
