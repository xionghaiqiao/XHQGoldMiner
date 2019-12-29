//
//  ShowSuccessOrFailLayer.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ShowSuccessOrFailLayer.h"
#import "global.h"
#import "UserDataManager.h"
#import "ShopScene.h"
#import "GameScene.h"

@interface ShowSuccessOrFailLayer ()
{
}
@property(nonatomic, strong)SKNode *rootNode;
@property(nonatomic, strong)SKLabelNode *currentStageLabel;
@property(nonatomic, strong)SKLabelNode *totalMondyLabel;
@property(nonatomic, strong)SKLabelNode *requstMoneyLabel;
@property(nonatomic, strong)SKLabelNode *resultLabel;

@end


@implementation ShowSuccessOrFailLayer
- (instancetype)initWithResult:(BOOL)isPass
{
    self = [super init];
    if (self) {
        [self initInfo];
        [self showAnimation:isPass];
    }
    return self;
}
- (void)initInfo
{
    SKScene *scene = [SKScene nodeWithFileNamed:@"ShowSuccessOrFailLayer.sks"];
    self.rootNode = [scene childNodeWithName:@"root"];
    [self.rootNode removeFromParent];
    [self addChild: self.rootNode];
    
    //current stage
    self.currentStageLabel = (SKLabelNode *)[self.rootNode childNodeWithName:@"stageLabel"];
    NSInteger stageNumber = [UserDataManager sharedUserDataManager].stageNumber;
    self.currentStageLabel.text = [NSString stringWithFormat:@"%ld",stageNumber];
    
    //totalMoney
    self.totalMondyLabel = (SKLabelNode *)[self.rootNode childNodeWithName:@"totalMoneyLabel"];
    self.totalMondyLabel.text =[NSString stringWithFormat:@"%ld",[UserDataManager sharedUserDataManager].totalMoney];
    self.totalMondyLabel.alpha = 0.0;
    //request score
    self.requstMoneyLabel = (SKLabelNode *)[self.rootNode childNodeWithName:@"requestMoneyLabel"];
    NSInteger score = 650 + 275 * (stageNumber - 1) + 410 * (stageNumber - 1);
    self.requstMoneyLabel.text = [NSString stringWithFormat:@"%ld",score];
    self.requstMoneyLabel.alpha = 0;
    //success or fail
    self.resultLabel = (SKLabelNode *)[self.rootNode childNodeWithName:@"resultLabel"];
    self.resultLabel.alpha = 0;
    self.rootNode.paused = NO;
}

- (void)showAnimation:(BOOL)isPass
{
    __block BOOL isNextStage = isPass;
    __weak typeof (self)weakSelf = self;
    if (isPass == NO)
    {
        self.resultLabel.text = @"Fail";
    }
    
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.3];
    SKAction *scaleUpAction = [SKAction scaleTo:2.0 duration:0.5];
    SKAction *scaleDownAction = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *groupAction = [SKAction group:@[fadeInAction, scaleUpAction]];
    SKAction *delayAction  = [SKAction waitForDuration:1.0];
    SKAction *seqenceAction1 = [SKAction sequence:@[groupAction, scaleDownAction]];
    SKAction *seqenceAction2 = [SKAction sequence:@[groupAction, scaleDownAction,delayAction]];
    
    [weakSelf.requstMoneyLabel runAction:seqenceAction1 completion:^{
        [weakSelf.totalMondyLabel runAction:seqenceAction1 completion:^{
            [weakSelf.resultLabel runAction:seqenceAction2 completion:^{
                //准备选择关卡
                [weakSelf enterNextScene:isNextStage];
                
            }];
        }];
    }];
}

- (void)enterNextScene:(BOOL)isNextStage
{
    SKView *skView;
    if (isNextStage)
    {
        ShopScene *scene    = (ShopScene *)[ShopScene nodeWithFileNamed:@"ShopScene.sks"];
        scene.scaleMode     = SKSceneScaleModeAspectFit;
        skView = (SKView *)self.scene.view;
        [skView presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
    }
    else
    {
        GameScene *newScene = [GameScene nodeWithFileNamed:@"GameScene.sks"];
        newScene.scaleMode = SKSceneScaleModeAspectFit;
        skView = (SKView *)self.scene.view;
        [skView presentScene:newScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
    }
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
}

@end
