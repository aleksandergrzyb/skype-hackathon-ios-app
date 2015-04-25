//
//  SHCafeteria.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHCafeteria.h"

@implementation SHCafeteria

@dynamic name;
@dynamic start_hour_week;
@dynamic end_hour_week;
@dynamic open_sat;
@dynamic start_hour_sat;
@dynamic end_hour_sat;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Cafeteria";
}

@end
