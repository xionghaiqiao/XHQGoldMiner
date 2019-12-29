//
//  UIImage+Extention.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/26.
//  Copyright © 2019 apple. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extention)
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)cutRect;
+(UIImage *)RoateImageInLargerSize:(UIImage *)orignalImage  StartPoint:(CGPoint)point TargetSize:(CGSize)targetSize;
+ (UIImage *)RoateImage:(UIImage *)orignalImage;
+(UIImage *)PutImageInLargerSize:(UIImage *)orignalImage  StartPoint:(CGPoint)point TargetSize:(CGSize)targetSize;
@end

NS_ASSUME_NONNULL_END
