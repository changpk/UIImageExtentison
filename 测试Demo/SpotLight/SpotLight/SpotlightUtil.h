//
//  SpotlightUtil.h
//  SpotLight
//
//  Created by sinagame on 16/3/1.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@interface SpotlightUtil : NSObject

+ (instancetype)shareInstance;

- (void)insertSearchableItem:(NSData *)photo
              spotlightTitle:(NSString *)spotlightTitle
                 description:(NSString *)spotlightDesc
                    keywords:(NSArray *)keywords
               spotlightInfo:(NSString *)spotlightInfo
                    domainId:(NSString *)domainId;
- (void)deleteSearchableItemWithDomainIdentifiers:(NSString *)domainId;
- (void)deleteAllSeachableItems;
@end
