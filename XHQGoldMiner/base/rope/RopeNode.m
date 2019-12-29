//
//  RopeNode.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "RopeNode.h"
#import "XHQTextureAtlas.h"
#import "global.h"
@implementation RopeNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"rope.png"];
        self.rope = [SKSpriteNode spriteNodeWithTexture:texture];
        self.rope.anchorPoint = CGPointMake(0.5, 0);
        self.rope.position = CGPointMake(0, 0);
        [self addChild:self.rope];
        
        texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"hook.png"];
        self.hook = [SKSpriteNode spriteNodeWithTexture:texture];
        self.hook.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:12];
        self.hook.physicsBody.categoryBitMask = kHookCategory;
        self.hook.physicsBody.collisionBitMask = 0;
        self.hook.physicsBody.contactTestBitMask = kGoldCategory | kSceneCategory;
        self.hook.zRotation = -M_PI;
        //self.hook.anchorPoint = CGPointMake(1.0, 0.5);
        self.hook.position = CGPointMake(self.rope.position.x, self.rope.position.y + self.rope.size.height);

        [self addChild:self.hook];
        self.zRotation = M_PI;
        [self.hook setScale:1.5];
        
        self.scaleFactor = 1.0;
        
        self.rope.size = CGSizeMake(self.rope.size.width, kOrigionRopeHeight);
        self.hook.position = CGPointMake(self.rope.position.x, self.rope.position.y + self.rope.size.height);
    }
    return self;
}

- (void)startRopeAnimation
{
    CGFloat duration = 1.5;
    CGFloat angle = (65.0 / 180.0) * M_PI;
    self.zRotation = M_PI;
    SKAction *rightAction1 = [SKAction rotateByAngle:angle duration:duration];
    SKAction *leftAction1  = [SKAction rotateByAngle:-angle duration:duration];
    SKAction *leftAction2  = [SKAction rotateByAngle:-angle duration:duration];
    SKAction *rightAction2 = [SKAction rotateByAngle:angle duration:duration];
    SKAction *sequenseAction = [SKAction sequence:@[rightAction1,leftAction1,leftAction2,rightAction2]];
    [self runAction:[SKAction repeatActionForever:sequenseAction]];
}

- (void)addRopeHeight:(CGFloat)height
{
    CGFloat ropeHeight = self.rope.size.height;
    ropeHeight += height;
    self.rope.size = CGSizeMake(self.rope.size.width, ropeHeight);
    
    self.hook.position = CGPointMake(self.rope.position.x, self.rope.position.y + self.rope.size.height);
}

- (void)subRopeHeight:(CGFloat)height
{
    CGFloat ropeHeight = self.rope.size.height;
    ropeHeight -= height;
    self.rope.size = CGSizeMake(self.rope.size.width, ropeHeight);
    
    self.hook.position = CGPointMake(self.rope.position.x, self.rope.position.y + self.rope.size.height);
}



@end
