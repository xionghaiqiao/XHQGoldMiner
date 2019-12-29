//
//  XHQTextureFrame.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import<SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHQTextureFrame : NSObject

@property(nonatomic,strong)SKTexture *fullTexture;
@property(nonatomic,strong)UIImage *fullImage;
@property(nonatomic,assign)CGSize sourceSize;   //原图长和宽，实际没有用到
@property(nonatomic,assign)CGRect sourceColorRect;//子图在原图中的位置
@property(nonatomic,assign)CGPoint offset;      //用于计算锚点
@property(nonatomic,assign)BOOL rotated;        //是否旋转
@property(nonatomic,assign)CGPoint anchorPoint; //正确的锚点
@property(nonatomic,assign)CGRect frame;        //原始大小，需要通过rotated计算出真正的textureRect
@property(nonatomic,assign)CGRect textureRect;  //rotated转换过的实际位置
@property(nonatomic,assign)CGRect realRect;     //归一化后，用于取出大图中的子图实际位置

- (XHQTextureFrame *)initTextureFrameWithDict:(NSDictionary *)dict FullTexture:(SKTexture *)fullTexture FullImage:(UIImage *)fullImage;
- (SKTexture *)getFrameTexture:(XHQTextureFrame *)textureFrame;

@end

NS_ASSUME_NONNULL_END
