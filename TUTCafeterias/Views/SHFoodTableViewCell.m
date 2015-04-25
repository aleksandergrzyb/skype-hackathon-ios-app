//
//  SHFoodTableViewCell.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHFoodTableViewCell.h"

@interface SHFoodTableViewCell ()
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *cafeteriaLabel;
@end

@implementation SHFoodTableViewCell

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        [self addSubview:self.priceLabel];

        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        [self addSubview:self.nameLabel];

        UILabel *cafeteriaLabel = [[UILabel alloc] init];
        self.cafeteriaLabel = cafeteriaLabel;
        [self addSubview:self.cafeteriaLabel];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.priceLabel.frame = CGRectMake(300, 10, 100, 100);
    self.cafeteriaLabel.frame = CGRectMake(10, 10, 100, 100);
    self.nameLabel.frame = CGRectMake(20, 10, 200, 100);
}

#pragma mark -
#pragma mark Setters

- (void)setCafeteria:(NSString *)cafeteria
{
    if (_cafeteria == cafeteria) {
        return;
    }
    _cafeteria = cafeteria;
    self.cafeteriaLabel.text = cafeteria;
    [self setNeedsDisplay];
}

- (void)setName:(NSString *)name
{
    if (_name == name) {
        return;
    }
    _name = name;
    self.nameLabel.text = name;
    [self setNeedsDisplay];
}

- (void)setPrice:(NSNumber *)price
{
    if (_price == price) {
        return;
    }
    _price = price;
    NSNumber *priceValue;
    if (price.doubleValue < 0 || price.doubleValue > 10000) {
        priceValue = @(0);
    } else {
        priceValue = @(price.doubleValue * 0.01);
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = 2;
    self.priceLabel.text = [numberFormatter stringFromNumber:priceValue];
    [self setNeedsDisplay];
}

@end
