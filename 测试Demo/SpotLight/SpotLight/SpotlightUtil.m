//
//  SpotlightUtil.m
//  SpotLight
//
//  Created by sinagame on 16/3/1.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import "SpotlightUtil.h"

@implementation SpotlightUtil

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    static SpotlightUtil *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SpotlightUtil alloc]init];
    });
    return shareInstance;
}

- (void)insertSearchableItem:(NSData *)photo
              spotlightTitle:(NSString *)spotlightTitle
                 description:(NSString *)spotlightDesc
                    keywords:(NSArray *)keywords
               spotlightInfo:(NSString *)spotlightInfo
                    domainId:(NSString *)domainId {
    
    
    //1.创建一个属性集合
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:(NSString *)kUTTypeJPEG
                                                  ];
    attributeSet.thumbnailData = photo;
    attributeSet.title = spotlightTitle;
    attributeSet.contentDescription = spotlightDesc;
    attributeSet.keywords = keywords;
    
    // spotlightInfo 可以作为一些数据传递给接受的地方
    // domainId      id,通过这个id来判断是哪个spotlight
    CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:spotlightInfo domainIdentifier:domainId attributeSet:attributeSet];
    // 设置过期时间，默认为1个月
    item.expirationDate = [NSDate dateWithTimeIntervalSinceNow:20];
    
    
    [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"indexSearchableItems erro is %@",error.localizedDescription);
        }
    }];
}

- (void)deleteAllSeachableItems {
    
    [[CSSearchableIndex defaultSearchableIndex]deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"deleteAllSearchableItems erro is %@",error.localizedDescription);

    }];
}

- (void)deleteSearchableItemWithDomainIdentifiers:(NSString *)domainId {
    
    [[CSSearchableIndex defaultSearchableIndex]deleteSearchableItemsWithDomainIdentifiers:@[domainId] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"defaultSearchableIndex erro is %@",error.localizedDescription);
    }];
}


@end
