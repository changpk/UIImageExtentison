//
//  UIImage+Extension.m
//  ImageExtension
//
//  Created by sinagame on 16/2/23.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

// http://www.sjsjw.com/kf_mobile/article/13_5168_6703.asp CGContextDrawImage 方法的理解

#import "UIImage+Extension.h"

@interface UIImage (ResizePrivate)
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end

@implementation UIImage (Extension)
static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

-(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width, image.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        
        int offset = 4*x;
        
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        //[cls addObject:clr];
        
    }
    CGContextRelease(context);
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

//// Returns a copy of this image that is squared to the thumbnail size.
//// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality {
//    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
//                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
//                                         interpolationQuality:quality];
//    
//    // Crop out any part of the image that's larger than the thumbnail size
//    // The cropped rect must be centered on the resized image
//    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
//    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
//                                 round((resizedImage.size.height - thumbnailSize) / 2),
//                                 thumbnailSize,
//                                 thumbnailSize);
//    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
//    
//    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
//    
//    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
//}
//
//// Returns a rescaled copy of the image, taking into account its orientation
//// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
//- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
//    BOOL drawTransposed;
//    
//    switch (self.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            drawTransposed = YES;
//            break;
//            
//        default:
//            drawTransposed = NO;
//    }
//    
//    return [self resizedImage:newSize
//                    transform:[self transformForOrientation:newSize]
//               drawTransposed:drawTransposed
//         interpolationQuality:quality];
//}
//
//// Resizes the image according to the given content mode, taking into account the image's orientation
//- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
//                                  bounds:(CGSize)bounds
//                    interpolationQuality:(CGInterpolationQuality)quality {
//    CGFloat horizontalRatio = bounds.width / self.size.width;
//    CGFloat verticalRatio = bounds.height / self.size.height;
//    CGFloat ratio;
//    
//    switch (contentMode) {
//        case UIViewContentModeScaleAspectFill:
//            ratio = MAX(horizontalRatio, verticalRatio);
//            break;
//            
//        case UIViewContentModeScaleAspectFit:
//            ratio = MIN(horizontalRatio, verticalRatio);
//            break;
//            
//        default:
//            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
//    }
//    
//    CGSize newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
//    
//    return [self resizedImage:newSize interpolationQuality:quality];
//}
//
//- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
//{
//    UIImage *sourceImage = self;
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
//    
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
//    {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//        
//        if (widthFactor > heightFactor)
//        {
//            scaleFactor = widthFactor; // scale to fit height
//        }
//        else
//        {
//            scaleFactor = heightFactor; // scale to fit width
//        }
//        scaledWidth = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//        
//        // Center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        }
//        else if (widthFactor < heightFactor)
//        {
//            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//        }
//    }
//    
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    
//    [sourceImage drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if (newImage == nil)
//    {
//        
//    }
//    
//    // Pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//#pragma mark -
//#pragma mark Private helper methods
//
//// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
//// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
//// If the new size is not integral, it will be rounded up
//- (UIImage *)resizedImage:(CGSize)newSize
//                transform:(CGAffineTransform)transform
//           drawTransposed:(BOOL)transpose
//     interpolationQuality:(CGInterpolationQuality)quality {
//    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
//    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
//    CGImageRef imageRef = self.CGImage;
//    
//    // Build a context that's the same dimensions as the new size
//    CGContextRef bitmap = CGBitmapContextCreate(NULL,
//                                                newRect.size.width,
//                                                newRect.size.height,
//                                                CGImageGetBitsPerComponent(imageRef),
//                                                0,
//                                                CGImageGetColorSpace(imageRef),
//                                                CGImageGetBitmapInfo(imageRef));
//    
//    // Rotate and/or flip the image if required by its orientation
//    CGContextConcatCTM(bitmap, transform);
//    
//    // Set the quality level to use when rescaling
//    CGContextSetInterpolationQuality(bitmap, quality);
//    
//    // Draw into the context; this scales the image
//    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
//    
//    // Get the resized image from the context and a UIImage
//    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    
//    // Clean up
//    CGContextRelease(bitmap);
//    CGImageRelease(newImageRef);
//    
//    return newImage;
//}
//
//// Returns an affine transform that takes into account the image orientation when drawing a scaled image
//- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (self.imageOrientation) {
//        case UIImageOrientationDown:           // EXIF = 3
//        case UIImageOrientationDownMirrored:   // EXIF = 4
//            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:           // EXIF = 6
//        case UIImageOrientationLeftMirrored:   // EXIF = 5
//            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:          // EXIF = 8
//        case UIImageOrientationRightMirrored:  // EXIF = 7
//            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//            
//        default:
//            break;
//    }
//    
//    switch (self.imageOrientation) {
//        case UIImageOrientationUpMirrored:     // EXIF = 2
//        case UIImageOrientationDownMirrored:   // EXIF = 4
//            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:   // EXIF = 5
//        case UIImageOrientationRightMirrored:  // EXIF = 7
//            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        default:
//            break;
//    }
//    
//    return transform;
//}
//
//- (UIImage *)resizedImageWithCompressionLevelHighResolution
//{
//    UIImage *resizedImage = nil;
//    
//    if (self.size.width <= 1600 && self.size.height <= 1600)
//    {
//        resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:self.size interpolationQuality:kCGInterpolationDefault];
//    }
//    else
//    {
//        resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1600, 1600) interpolationQuality:kCGInterpolationDefault];
//    }
//    
//    return resizedImage;
//}
//
//- (UIImage *)scaleToSize:(CGSize)size
//{
//    CGFloat width = CGImageGetWidth(self.CGImage);
//    CGFloat height = CGImageGetHeight(self.CGImage);
//    
//    float verticalRadio = size.height*1.0/height;
//    float horizontalRadio = size.width*1.0/width;
//    
//    float radio = 1;
//    if(verticalRadio>1 && horizontalRadio>1)
//    {
//        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
//    }
//    else
//    {
//        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
//    }
//    
//    width = width*radio;
//    height = height*radio;
//    
//    int xPos = (size.width - width)/2;
//    int yPos = (size.height-height)/2;
//    
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    
//    // 绘制改变大小的图片
//    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
//    
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    
//    // 返回新的改变大小后的图片
//    return scaledImage;
//}
//
//- (UIImage *)reSizeByScale:(float)scale autoSize:(BOOL)autoSize
//{
//    float width = self.size.width;
//    float height = self.size.height;
//    if (autoSize) {
//        float maxValue = MAX(width, height);
//        if (maxValue > 1000) {
//            scale = 1000.0/maxValue;
//        }else{
//            scale = 1;
//        }
//    }
//    UIGraphicsBeginImageContext(CGSizeMake(width * scale, height * scale));
//    [self drawInRect:CGRectMake(0, 0, width * scale, height * scale)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}
//
//- (void)scaleImage:(NSData *)imageData maxSize:(float)maxSize result:(NSData **)result
//{
//    float squrt = sqrt(maxSize / [imageData length]);
//    UIImage *image = [UIImage imageWithData:imageData];
//    CGSize rect = CGSizeMake(floor(image.size.width*squrt), floor(image.size.height*squrt));
//    imageData = UIImagePNGRepresentation([image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:rect interpolationQuality:kCGInterpolationDefault]);
//    if ([imageData length] > maxSize)
//    {
//        [self scaleImage:imageData maxSize:maxSize result:result];
//    }
//    else
//    {
//        *result = imageData;
//    }
//    
//}
//
//- (UIImage *)clipImageToFitMaxSize:(float)maxSize
//{
//    NSData *imageData = UIImagePNGRepresentation(self);
//    if ([imageData length] <= maxSize)
//    {
//        return [UIImage imageWithData:imageData];
//    }
//    else
//    {
//        NSData *result = nil;
//        [self scaleImage:imageData maxSize:maxSize result:&result];
//        if (result) {
//            return [UIImage imageWithData:result];
//        }
//        return nil;
//    }
//    return nil;
//}
@end
