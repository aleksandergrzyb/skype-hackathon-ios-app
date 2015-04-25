//
//  SHFood.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHCafeteria.h"
#import "SHType.h"
#import "SHDishType.h"

@interface SHFood : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL gluten_free;
@property (strong, nonatomic) SHCafeteria *cafe_id;
@property (strong, nonatomic) SHDishType *dish_type_id;
@property (strong, nonatomic) SHType *type_id;

+ (NSString *)parseClassName;

@end
