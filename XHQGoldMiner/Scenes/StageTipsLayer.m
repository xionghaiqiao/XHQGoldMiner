//
//  StageTipsLayer.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "StageTipsLayer.h"
#import "XHQTextureAtlas.h"
#import "global.h"
#import "UserDataManager.h"
@interface StageTipsLayer ()
{
    //NSInteger _stageNumber;
}
@property(nonatomic, strong)SKNode *tipsNode;
@property(nonatomic, strong)SKSpriteNode *imageNode;
@property(nonatomic, strong)SKLabelNode  *currentStageLabel;
@property(nonatomic, strong)SKLabelNode *requstScoreLabel;

@end
@implementation StageTipsLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setStageInfo];
        [self showAnimation];
    }
    return self;
}
- (void)showAnimation
{
    self.currentStageLabel.alpha = 0;
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.5];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.5];
    SKAction *moveAction1 = [SKAction moveTo: CGPointMake(-kScreenWidth * 0.1, kScreenHeight * -0.1) duration:0.5];
    SKAction *moveAction1Reverse = [SKAction moveTo: CGPointMake(-kScreenWidth * 0.6, kScreenHeight * -0.1) duration:0.5];
    SKAction *pauseAction = [SKAction waitForDuration:1.0];
    SKAction *moveAction2 = [SKAction moveTo: CGPointMake(kScreenWidth * 0.1, kScreenHeight * -0.1) duration:0.5];
    SKAction *moveAction2Reverse = [SKAction moveTo: CGPointMake(kScreenWidth * 0.6, kScreenHeight * -0.1) duration:0.5];
    SKAction *seqAction1 = [SKAction sequence:@[moveAction1,pauseAction,moveAction1Reverse]];
    SKAction *seqAction2 = [SKAction sequence:@[moveAction2,pauseAction,moveAction2Reverse]];
    SKAction *seqAction3 = [SKAction sequence:@[fadeInAction,pauseAction,fadeOutAction]];
    [self.imageNode runAction:seqAction1];
    [self.currentStageLabel runAction:seqAction3];
    [self.requstScoreLabel runAction:seqAction2 completion:^{
        if ([self.delegate respondsToSelector:@selector(tipsOver)])
        {
            [self.delegate tipsOver];
        }
        [self removeFromParent];
    }];
    
    
}
- (void)setStageInfo
{
    SKScene *scene = [SKScene nodeWithFileNamed:@"StageTipsLayer.sks"];
    self.tipsNode = [scene childNodeWithName:@"root"];
    [self.tipsNode removeFromParent];
    [self addChild:self.tipsNode];
    
    //current stage
    self.currentStageLabel = (SKLabelNode *)[self.tipsNode childNodeWithName:@"stageLabel"];
    NSInteger stageNumber = [UserDataManager sharedUserDataManager].stageNumber;
    self.currentStageLabel.text = [NSString stringWithFormat:@"Stage : %ld",stageNumber];
    
    //goal-symbol.png
    self.imageNode = (SKSpriteNode *)[self.tipsNode childNodeWithName:@"goal-symbol"];
    self.imageNode.texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"goal-symbol.png"];
    self.imageNode.position = CGPointMake(-kScreenWidth * 0.6, kScreenHeight * -0.1);
    //stage score
    self.requstScoreLabel = (SKLabelNode *)[self.tipsNode childNodeWithName:@"targetLabel"];
    NSInteger score = 650 + 275 * (stageNumber - 1) + 410 * (stageNumber - 1);
    self.requstScoreLabel.text = [NSString stringWithFormat:@"Target Score : %ld",score];
    self.requstScoreLabel.position = CGPointMake(kScreenWidth * 0.6, kScreenHeight * -0.1);
    self.tipsNode.paused = NO;
}

@end
