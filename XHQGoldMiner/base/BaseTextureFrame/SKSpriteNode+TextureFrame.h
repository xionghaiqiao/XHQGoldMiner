//
//  SKSpriteNode+TextureFrame.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "XHQTextureAtlas.h"
NS_ASSUME_NONNULL_BEGIN

@interface SKSpriteNode (TextureFrame)

+ (SKSpriteNode *)createWithSpriteFrameName:(NSString *)textureName;

@end

NS_ASSUME_NONNULL_END
