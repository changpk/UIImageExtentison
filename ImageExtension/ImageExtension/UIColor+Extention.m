//
//  UIColor+Extention.m
//  ImageExtension
//
//  Created by sinagame on 16/2/24.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import "UIColor+Extention.h"

@implementation UIColor (Extention)

- (CGFloat)alphaForColor {
    CGFloat r, g, b, a, w, h, s, l;
    BOOL compatible = [self getWhite:&w alpha:&a];
    if (compatible) {
        return a;
    } else {
        compatible = [self getRed:&r green:&g blue:&b alpha:&a];
        if (compatible) {
            return a;
        } else {
            [self getHue:&h saturation:&s brightness:&l alpha:&a];
            return a;
        }
    }
}

+(BOOL)isDarkColor:(UIColor *)newColor {
    if ([newColor alphaForColor]<10e-5) {
        return YES;
    }
    const CGFloat *componentColors = CGColorGetComponents(newColor.CGColor);
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5){
        NSLog(@"Color is dark");
        return YES;
    }
    else{
        NSLog(@"Color is light");
        return NO;
    }
}


@end
