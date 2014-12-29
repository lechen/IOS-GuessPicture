//
//  PictureInfoModel.m
//  0327_超级猜图
//
//  Created by LE on 14/12/19.
//  Copyright (c) 2014年 LE. All rights reserved.
//

#import "PictureInfoModel.h"

@implementation PictureInfoModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.answer = dictionary[@"answer"];
        self.title = dictionary[@"title"];
        self.icon = dictionary[@"icon"];
        self.options = dictionary[@"options"];
    }
    return self;
}

+(instancetype)pictureWithDictionary:(NSDictionary *)dictionary{
    return [[PictureInfoModel alloc] initWithDictionary:dictionary];
}
@end
