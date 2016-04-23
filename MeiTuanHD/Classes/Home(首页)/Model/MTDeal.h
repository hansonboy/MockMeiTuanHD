//
//  MTDeal.h
//  MTHD
//
//  Created by wangjianwei on 16/4/12.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBusiness.h"
@class MTRestriction;
@interface MTDeal : NSObject
/**团购单ID*/
@property (nonatomic ,copy) NSString *deal_id;
/**团购标题*/
@property (nonatomic ,copy) NSString *title;
/**团购描述*/
@property (nonatomic ,copy) NSString *desc;
/**团购包含商品原价值*/
@property (nonatomic ,strong) NSNumber *list_price;
/**团购价格*/
@property (nonatomic ,strong) NSNumber *current_price;
/**团购当前已购买数*/
@property (nonatomic ,assign) NSInteger purchase_count;
/**团购图片链接，最大图片尺寸450×280*/
@property (nonatomic ,copy) NSString *image_url;
/**小尺寸团购图片链接，最大图片尺寸160×100*/
@property (nonatomic ,copy) NSString *s_image_url;
/**团购发布上线日期*/
@property (nonatomic ,copy) NSString *publish_date;
/**团购单的截止购买日期*/
@property (nonatomic ,copy) NSString *purchase_deadline;
/**团购Web页面链接，适用于网页应用*/
@property (nonatomic ,copy) NSString *deal_url;
/**团购HTML5页面链接，适用于移动应用和联网车载应用*/
@property (nonatomic ,copy) NSString *deal_h5_url;
/**团购限制条件*/
@property (nonatomic ,strong)MTRestriction *restrictions;
/**是否编辑状态*/
@property (nonatomic ,assign,getter=isEditing)BOOL editing;
/**是否被选中*/
@property (nonatomic ,assign,getter=isSelected)BOOL selected;
/**商户信息*/
@property (nonatomic ,strong)NSArray *businesses;

//city	string	城市名称，city为＂全国＂表示全国单，其他为本地单，城市范围见相关API返回结果
//regions	list	团购适用商户所在行政区
//categories	list	团购所属分类
//distance	int	团购单所适用商户中距离参数坐标点最近的一家与坐标点的距离，单位为米；如不传入经纬度坐标，结果为-1；如团购单无关联商户，结果为MAXINT
//commission_ratio	float	当前团单的佣金比例
//businesses	list	团购所适用的商户列表
//businesses.name	string	商户名
//businesses.id	int	商户ID
//businesses.url	string	商户页链接

//is_popular	int	是否为热门团购，0：不是，1：是

//notice	string	重要通知(一般为团购信息的临时变更)
//deal_url	string	团购Web页面链接，适用于网页应用
//deal_h5_url	string	团购HTML5页面链接，适用于移动应用和联网车载应用
//commission_ratio	float	当前团单的佣金比例
//businesses	list	团购所适用的商户列表
//businesses.name	string	商户名
//businesses.id	int	商户ID
//businesses.address	string	商户地址
//businesses.latitude	float	商户纬度
//businesses.longitude	float	商户经度
//businesses.url	string	商户页链接
@end
