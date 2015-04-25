//
//  SHType.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <Parse/Parse.h>

@interface SHType : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;

+ (NSString *)parseClassName;

@end
