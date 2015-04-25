//
//  SHFoodTableViewCell.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHFoodTableViewCell.h"
#import "SHConstants.h"

@interface SHFoodTableViewCell ()
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *priceSmallLabel;
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
        self.priceLabel.font = [UIFont systemFontOfSize:28.0f];
        self.priceLabel.textColor = [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1];
        [self addSubview:self.priceLabel];

        UILabel *priceSmallLabel = [[UILabel alloc] init];
        self.priceSmallLabel = priceSmallLabel;
        self.priceSmallLabel.font = [UIFont systemFontOfSize:18.0f];
        self.priceSmallLabel.textColor = [UIColor colorWithRed:0.82 green:0.07 blue:0.13 alpha:1];
        [self addSubview:self.priceSmallLabel];

        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        [self addSubview:self.nameLabel];

        UILabel *cafeteriaLabel = [[UILabel alloc] init];
        self.cafeteriaLabel = cafeteriaLabel;
        self.cafeteriaLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.cafeteriaLabel];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.priceLabel.frame = CGRectMake(PRICE_LABEL_LEFT_OFFSET, 0, self.priceLabel.frame.size.width,
                                       self.frame.size.height);

    self.priceSmallLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + PRICE_SMALL_LABEL_LEFT_OFFSET,
                                            PRICE_SMALL_LABEL_TOP_OFFSET,
                                            self.priceSmallLabel.frame.size.width,
                                            self.priceSmallLabel.frame.size.height);

    switch (self.cellType) {
        case FoodTableViewCellTypeCafeteria:
            [self.nameLabel sizeToFit];
            self.nameLabel.frame = CGRectMake(LEFT_OFFSET, NAME_LABEL_TOP_OFFSET,
                                              self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
            self.cafeteriaLabel.hidden = NO;
            self.cafeteriaLabel.frame = CGRectMake(LEFT_OFFSET,
                                                   CGRectGetMaxY(self.nameLabel.frame) +CAFETERIA_LABEL_TOP_OFFSET,
                                              self.cafeteriaLabel.frame.size.width, self.cafeteriaLabel.frame.size.height);
            break;

        case FoodTableViewCellTypeNonCafeteria:
            self.nameLabel.frame = CGRectMake(LEFT_OFFSET, 0,
                                              self.nameLabel.frame.size.width, self.frame.size.height);
            self.cafeteriaLabel.hidden = YES;
            break;
    }

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
    [self.cafeteriaLabel sizeToFit];
    [self setNeedsDisplay];
}

- (void)setName:(NSString *)name
{
    if (_name == name) {
        return;
    }
    _name = name;
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
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

    int priceMajor = floor(priceValue.doubleValue);
    double priceDiff = priceValue.doubleValue - priceMajor;
    int priceMinor = round(priceDiff * 100.0);


    NSString *priceMinorString;
    if (priceMinor < 10 && priceMinor > 1) {
        priceMinorString = [NSString stringWithFormat:@"0%d", priceMinor];
    }
    else if (priceMinor == 0 || priceMinor < 0 || priceMinor > 99) {
        priceMinorString = [NSString stringWithFormat:@"00"];
    }
    else if (priceMinor > 10 && priceMinor < 100) {
        priceMinorString = [NSString stringWithFormat:@"%d", priceMinor];
    }

    // Setting labels
    self.priceSmallLabel.text = priceMinorString;
    [self.priceSmallLabel sizeToFit];

    self.priceLabel.text = [NSString stringWithFormat:@"%d", priceMajor];
    [self.priceLabel sizeToFit];

    [self setNeedsDisplay];
}

@end
