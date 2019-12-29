//
//  XHQTextureFrame.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XHQTextureFrame.h"
#import "UIImage+Extention.h"

@implementation XHQTextureFrame

- (XHQTextureFrame *)initTextureFrameWithDict:(NSDictionary *)dict FullTexture:(SKTexture *)fullTexture FullImage:(UIImage *)fullImage
{
    _fullTexture    = fullTexture;
    _fullImage      = fullImage;
    _rotated        = [dict[@"rotated"]boolValue] ;
    _sourceSize     = CGSizeFromString(dict[@"sourceSize"]);
    _offset         = CGPointFromString(dict[@"offset"]);
    _sourceColorRect= CGRectFromString(dict[@"sourceColorRect"]);
    //从上述数据计算anchorPoint和实际的Frame;
    //感觉应该是frame中的起始位置+sourceSize中的长和宽，组成的rect才是实际位置；
    
    _frame = CGRectFromString(dict[@"frame"]);
    //子图在大图中的位置
    if (_rotated)
    {
        _textureRect = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.height, _frame.size.width);
    }
    else
    {
        _textureRect = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
    }
    CGFloat anchorX = 0.5 - _offset.x / _frame.size.width;
    CGFloat anchorY = 0.5 - _offset.y / _frame.size.height;
    _anchorPoint = CGPointMake(anchorX, anchorY);
    //子图的位置归一化，为了使用取出子图的函数使用
    _realRect = CGRectMake(_textureRect.origin.x / fullTexture.size.width,
                           (fullTexture.size.height - _textureRect.origin.y - _textureRect.size.height) / fullTexture.size.height,
                           _textureRect.size.width / fullTexture.size.width,
                           _textureRect.size.height / fullTexture.size.height);
    return self;
}

- (SKTexture *)getFrameTexture:(XHQTextureFrame *)textureFrame
{

    if (!_rotated)
    {
        UIImage *bigImage = textureFrame.fullImage;
        UIImage *smallImage = [UIImage getSubImage:bigImage mCGRect:_textureRect];
        CFRelease(CFBridgingRetain(bigImage));
        UIImage *newImage;
        if (CGRectEqualToRect(_sourceColorRect, CGRectZero))
        {
           SKTexture *texture = [SKTexture textureWithRect:textureFrame.realRect inTexture:textureFrame.fullTexture];
            return texture;
        }
        else
        {
            
            newImage = [UIImage PutImageInLargerSize:smallImage StartPoint:CGPointMake(_sourceColorRect.origin.x, _sourceColorRect.origin.y) TargetSize:_sourceSize];
            
            //newImage = [UIImage RoateImage:smallImage Oritation:UIImageOrientationLeft];
        }
        //
        NSLog(@"new image size = %@",NSStringFromCGSize(newImage.size));
        SKTexture *newtexure = [SKTexture textureWithImage:newImage];
        return newtexure;
        
    }
    else
    {
        //得到对应的UIImage
        //CGImageRef ref = [textureFrame.fullTexture CGImage];
        UIImage *bigImage = textureFrame.fullImage;
        UIImage *smallImage = [UIImage getSubImage:bigImage mCGRect:_textureRect];
        CFRelease(CFBridgingRetain(bigImage));
        UIImage *newImage;
        if (CGRectEqualToRect(_sourceColorRect, CGRectZero))
        {
           newImage  = [UIImage RoateImage:smallImage];
        }
        else
        {
            
            newImage = [UIImage RoateImageInLargerSize:smallImage StartPoint:CGPointMake(_sourceColorRect.origin.x, _sourceColorRect.origin.y) TargetSize:_sourceSize];
        }
        //
        NSLog(@"new image size = %@",NSStringFromCGSize(newImage.size));
        SKTexture *newtexure = [SKTexture textureWithImage:newImage];
        return newtexure;
    }
    
    return nil;
}
@end
