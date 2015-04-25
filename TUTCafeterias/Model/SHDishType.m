//
//  SHDishType.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHDishType.h"

@implementation SHDishType

@dynamic name;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"DishType";
}

@end
