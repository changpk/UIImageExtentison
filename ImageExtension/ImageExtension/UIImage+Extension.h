//
//  UIImage+Extension.h
//  ImageExtension
//
//  Created by sinagame on 16/2/23.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
-(UIColor*)mostColor:(UIImage*)image;

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)resizedImageWithCompressionLevelHighResolution;
//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)reSizeByScale:(float)scale autoSize:(BOOL)autoSize;
/*
 * 将图片缩小到一定的大小 微博,微信sdk传递的数据会用到
 * 返回的是NSData
 */

- (UIImage *)clipImageToFitMaxSize:(float)maxSize;
@end
