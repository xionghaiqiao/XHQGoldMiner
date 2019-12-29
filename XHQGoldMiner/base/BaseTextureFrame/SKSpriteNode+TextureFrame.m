//
//  SKSpriteNode+TextureFrame.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SKSpriteNode+TextureFrame.h"
#import "XHQTextureAtlas.h"

@implementation SKSpriteNode (TextureFrame)
+ (SKSpriteNode *)createWithSpriteFrameName:(NSString *)textureName
{
    SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:textureName];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    
    XHQTextureFrame *textureFrame =  [[XHQTextureAtlas sharedXHQTextureAtlas]getTextureFrameWithName:textureName];
    sprite.anchorPoint = textureFrame.anchorPoint;
    
    return sprite;
}



@end
