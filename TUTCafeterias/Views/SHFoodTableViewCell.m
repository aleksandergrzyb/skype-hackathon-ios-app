//
//  SHFoodTableViewCell.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SHFoodTableViewCell.h"
#import "SHConstants.h"
#import <Masonry/Masonry.h>

@interface SHFoodTableViewCell ()
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *priceSmallLabel;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *cafeteriaLabel;
@property (weak, nonatomic) UIImageView *glutenFreeImageView;
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

        UIImageView *glutenFreeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 5.0f)];
        self.glutenFreeImageView = glutenFreeImageView;
        self.glutenFreeImageView.image = [UIImage imageNamed:@"gluten_free"];
        self.glutenFreeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.glutenFreeImageView];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIEdgeInsets smallPricePadding = UIEdgeInsetsMake(5, 0, 0, -30);
    [self.priceSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).with.offset(smallPricePadding.right);
        make.top.equalTo(self.mas_top).with.offset(smallPricePadding.top);
    }];

    UIEdgeInsets pricePadding = UIEdgeInsetsMake(15, 0, 0, -5);
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceSmallLabel.mas_left).with.offset(pricePadding.right);
        make.centerY.equalTo(self);
    }];

    UIEdgeInsets glutenFreeImageViewPadding = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.glutenFreeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(glutenFreeImageViewPadding.left);
        make.centerY.equalTo(self);
    }];

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

    if (self.isGlutenFree) {
        self.glutenFreeImageView.hidden = NO;
    }
    else {
        self.glutenFreeImageView.hidden = YES;
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
