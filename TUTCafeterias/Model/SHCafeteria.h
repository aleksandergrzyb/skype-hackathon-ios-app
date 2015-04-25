//
//  SHCafeteria.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <Parse/Parse.h>

@interface SHCafeteria : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *start_hour_week;
@property (strong, nonatomic) NSNumber *end_hour_week;
@property (nonatomic) BOOL open_sat;
@property (strong, nonatomic) NSNumber *start_hour_sat;
@property (strong, nonatomic) NSNumber *end_hour_sat;

+ (NSString *)parseClassName;

@end
