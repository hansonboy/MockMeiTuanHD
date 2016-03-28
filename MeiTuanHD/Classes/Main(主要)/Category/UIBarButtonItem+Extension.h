//
//  UIBarButtonItem+Extension.h
//  微博
//
//  Created by wangjianwei on 15/12/9.
//  Copyright © 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem*)itemWithTarget:(id)target action:(SEL)action imageName:(NSString*)imageName selecteImageName:(NSString*)selectedImageName;
@end
