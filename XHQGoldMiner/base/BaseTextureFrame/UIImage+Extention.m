//
//  UIImage+Extention.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/26.
//  Copyright © 2019 apple. All rights reserved.
//

#import "UIImage+Extention.h"


@implementation UIImage (Extention)
+ (UIImage *)RoateImage:(UIImage *)orignalImage  Oritation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, orignalImage.size.height, orignalImage.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, orignalImage.size.height, orignalImage.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, orignalImage.size.width, orignalImage.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, orignalImage.size.width, orignalImage.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), orignalImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
 }

+ (UIImage *)RoateImage:(UIImage *)orignalImage
{
    long double rotate = 0.0;
    CGRect rect;

    rotate = M_PI_2;
    rect = CGRectMake(0, 0, orignalImage.size.width, orignalImage.size.height);

    UIGraphicsBeginImageContext(CGSizeMake(rect.size.height, rect.size.width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.width);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), orignalImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    return newImage;
}

+ (UIImage *)RoateImageInLargerSize:(UIImage *)orignalImage  StartPoint:(CGPoint)point TargetSize:(CGSize)targetSize
{
    CGRect rect = CGRectMake(0, 0, orignalImage.size.width, orignalImage.size.height);
    CGFloat newY = targetSize.height - orignalImage.size.width - point.y;
    CGFloat newX = targetSize.width - orignalImage.size.height - point.x;
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, targetSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, M_PI_2);
    CGContextTranslateCTM(context, newY, -targetSize.width+newX);
    //CGContextTranslateCTM(context, point.x, newY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), orignalImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    
    return newImage;
}
+(UIImage *)PutImageInLargerSize:(UIImage *)orignalImage  StartPoint:(CGPoint)point TargetSize:(CGSize)targetSize
{
    CGRect rect;
    
    rect = CGRectMake(0, 0, orignalImage.size.width, orignalImage.size.height);
    CGFloat newY = targetSize.height - orignalImage.size.height - point.y;
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, targetSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, point.x, newY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), orignalImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     
    return newImage;
}

+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)cutRect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, cutRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
