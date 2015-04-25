//
//  SHCategoriesTableViewCell.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHCategoriesTableViewCell.h"

@implementation SHCategoriesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cellSelectedView = [[UIView alloc] initWithFrame:self.frame];
        cellSelectedView.backgroundColor = [UIColor colorWithRed:0.176 green:0.176 blue:0.176 alpha:1];
        self.selectedBackgroundView = cellSelectedView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
