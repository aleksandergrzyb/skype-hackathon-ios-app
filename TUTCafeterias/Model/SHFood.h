//
//  SHFood.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <Parse/Parse.h>

@interface SHFood : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL gluten_free;

+ (NSString *)parseClassName;

@end
