//
//  GoldNode.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GoldNode.h"
#import "XHQTextureAtlas.h"


@implementation GoldNode

- (instancetype)initWithType:(StoneType)stoneType
{
    self = [super init];
    if (self) {
        SKTexture *texture;
        switch (stoneType) {
            case kSmallGold:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kSmallGoldTexture];
                self.score = kSmallGoldScore;
                self.backSpeed = kSmallGoldBackSpeed;
                break;
            case kMiddleGold:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kMiddleGoldTexture];
                self.score = kMiddleGoldScore;
                self.backSpeed = kMiddleGolBackSpeed;
                break;
            case kBigGold:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kBigGoldTexture];
                self.score = kBigGoldScore;
                self.backSpeed = kBigGoldBackSpeed;
                break;
            case kSmallStone:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kSmallStoneTexture];
                self.score = kSmallStoneScore;
                self.backSpeed = kSmallStoneBackSpeed;
                break;
            case kMiddleStone:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kMiddleStoneTexture];
                self.score = kMiddleGoldScore;
                self.backSpeed = kMiddleStoneBackSpeed;
                break;
            case kBigStone:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kBigStoneTexture];
                self.score = kBigGoldScore;
                self.backSpeed = kBigStoneBackSpeed;
                break;
            case kDiamond:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kDiamondTexture];
                self.score = kDiamondScore;
                self.backSpeed = kDiamondSpeed;
                break;
            case kSkeleton:
                texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:kSkeltonTexture];
                self.score = kSkeletonScore;
                self.backSpeed = kSkeltonSpeed;
                break;
            default:
                break;
        }
        self = [self initWithTexture:texture];
        switch (stoneType) {
            case kSmallGold:
                [self setScale:0.4];
                break;
            case kMiddleGold:
                [self setScale:0.6];
                break;
            case kBigGold:
                [self setScale:0.9];
                break;
            case kSmallStone:
                [self setScale:0.5];
                break;
            case kMiddleStone:
                [self setScale:0.7];
                break;
            case kBigStone:
                [self setScale:0.9];
                break;
            case kDiamond:
                [self setScale:1.5];
                break;
            case kSkeleton:
                [self setScale:1.5];
                break;
            default:
                break;
        }
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.categoryBitMask = kGoldCategory;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = 0;
    }
    return self;
}

@end
