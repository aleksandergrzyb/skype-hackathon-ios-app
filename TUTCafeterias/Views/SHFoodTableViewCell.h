//
//  SHFoodTableViewCell.h
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHFoodTableViewCell : UITableViewCell

@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *cafeteria;

@end
