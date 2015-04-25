//
//  SHCategoriesHeader.m
//  TUTCafeterias
//
//  Created by Aleksander Grzyb on 25/04/15.
//  Copyright (c) 2015 Aleksander Grzyb. All rights reserved.
//

#import "SHCategoriesHeader.h"

@implementation SHCategoriesHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 15, 2, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
