//
//  SHFood.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHFood.h"

@implementation SHFood

@dynamic name;
@dynamic price;
@dynamic date;
@dynamic gluten_free;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Food";
}

@end
