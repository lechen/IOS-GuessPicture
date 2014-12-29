//
//  PictureInfoModel.h
//  0327_超级猜图
//
//  Created by LE on 14/12/19.
//  Copyright (c) 2014年 LE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureInfoModel : NSObject
/**
 *  答案
 */
@property(nonatomic,copy) NSString *answer;
/**
 *  图片名字
 */
@property(nonatomic,copy) NSString *icon;
/**
 *  图片标题
 */
@property(nonatomic,copy) NSString *title;
/**
 *  选项
 */
@property(nonatomic,strong) NSMutableArray *options;
/**
 *  初始化PictureInfoModel
 *
 *  @param dictionary 字典
 *
 *  @return 初始化后的PictureInfoModel
 */
+(instancetype)pictureWithDictionary:(NSDictionary *)dictionary;
/**
 *  初始化PictureInfoModel
 *
 *  @param dictionary 字典
 *
 *  @return 初始化后的PictureInfoModel
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
