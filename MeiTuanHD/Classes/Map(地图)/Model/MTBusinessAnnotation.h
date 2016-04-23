//
//  MTBusinessAnnotation.h
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class MTDeal;
@interface MTBusinessAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void)setTitle:(NSString * _Nullable)title;
- (void)setSubtitle:(NSString * _Nullable)subtitle;

@end
