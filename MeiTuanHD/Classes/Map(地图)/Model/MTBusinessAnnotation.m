
//
//  MTBusinessAnnotation.m
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTBusinessAnnotation.h"

@implementation MTBusinessAnnotation

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = [subtitle copy];
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}
- (BOOL)isEqual:(MTBusinessAnnotation *)object
{
    return [_title isEqualToString: object.title];
}
@end
