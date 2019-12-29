//
//  GameScene.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GameScene.h"
#import "SKSpriteNode+TextureFrame.h"
#import "XHQTextureAtlas.h"
#import "XHQTextureFrame.h"
#import "UserDataManager.h"
#import "global.h"
#import "SceneCreate.h"
#import "ShopScene.h"
#import "SoundTool.h"

@interface GameScene () <BaseButtonDelegate>
{
    
}

@end

@implementation GameScene {
}

- (void)didMoveToView:(SKView *)view {
    [self playBackgroundMusic];
    [self loadUserData];
    [self initAllTextureFrames];
    [self initCloudAndDoAnimation];
    [self initMinerAndAnimation];
    [self initCaveAndAnimation];
    [self initStartButton];

}

- (void)playBackgroundMusic
{
    [[SoundTool sharedSoundTool]playBgMusic];
}

- (void)loadUserData
{
    [[UserDataManager sharedUserDataManager]getUserData];
    NSLog(@"totalmoney = %ld, stageNumber = %ld", [UserDataManager sharedUserDataManager].totalMoney, [UserDataManager sharedUserDataManager].stageNumber);
}

- (void)initAllTextureFrames
{
    [[XHQTextureAtlas sharedXHQTextureAtlas]addSpriteFramesWithFile:@"general-sheet.plist"];
    [[XHQTextureAtlas sharedXHQTextureAtlas]addSpriteFramesWithFile:@"level-sheet.plist"];
    [[XHQTextureAtlas sharedXHQTextureAtlas]addSpriteFramesWithFile:@"huancun.plist"];
    [[XHQTextureAtlas sharedXHQTextureAtlas]addSpriteFramesWithFile:@"shoper.plist"];
    [[XHQTextureAtlas sharedXHQTextureAtlas]addSpriteFramesWithFile:@"minerAction.plist"];
    //huancun.plist
}

#pragma mark - start按钮
- (void)initStartButton
{
    SKTexture * normalTexture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"start-0.png"];
    SKTexture * pressTexture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"start-1.png"];
    NSLog(@"normalTexture.size = %@", NSStringFromCGSize(normalTexture.size));
    BaseButton *button = (BaseButton *)[[BaseButton alloc]initWithNormalTexture:normalTexture PressedTexture:pressTexture Rotated:YES];
    button.position = CGPointMake(kScreenWidth * 0.315, -kScreenHeight * 0.28);
    button.zPosition = 12;
    button.userInteractionEnabled = YES;
    button.name = @"startButton";
    //test
    button.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:button.size];
    button.physicsBody.affectedByGravity = NO;
    button.delegate = self;
    button.btnPressedControlBlock = ^{
        NSInteger stageNumber = [UserDataManager sharedUserDataManager].stageNumber;
        SKView *skView;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        
        if (stageNumber <= 1)
        {
            //当前为第1关
            [UserDataManager sharedUserDataManager].stageNumber = 1;
            BuyProductIndex param= {false,false,false,false};
            
            SceneCreate *scene = [SceneCreate createSceneWithParam:param];
            scene.scaleMode = SKSceneScaleModeAspectFit;
            skView = (SKView *)self.scene.view;
            [skView presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
            
        }
        else
        {
            ShopScene *scene    = (ShopScene *)[ShopScene nodeWithFileNamed:@"ShopScene.sks"];
            scene.scaleMode     = SKSceneScaleModeAspectFit;
            skView = (SKView *)self.scene.view;
            [skView presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        }
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
    };
    [self addChild:button];
}

#pragma mark - 矿洞动画
- (void)initCaveAndAnimation
{
    //create----miner:face
    SKSpriteNode *cave = [SKSpriteNode createWithSpriteFrameName:@"cave-0.png"];
    cave.position = CGPointMake(kScreenWidth * 0.2083, -kScreenHeight * 0.055);
    [self addChild:cave];
    NSMutableArray *caveArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"cave-%d.png",i];
        SKTexture * texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:textureName];
        [caveArray addObject:texture];
    }
    //face animation
    SKAction *faceAction = [SKAction animateWithTextures:caveArray timePerFrame:0.35];
    [cave runAction:[SKAction repeatActionForever:faceAction]];
}

#pragma mark - 矿工动画
- (void)initMinerAndAnimation
{
    //create----miner:face
    SKSpriteNode *face = [SKSpriteNode createWithSpriteFrameName:@"miner-face-whistle-0.png"];
    face.position = CGPointMake(-kScreenWidth * 0.2926, kScreenHeight * 0.0965);
    [self addChild:face];
    NSMutableArray *faceArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"miner-face-whistle-%d.png",i];
        SKTexture * texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:textureName];
        [faceArray addObject:texture];
    }
    //face animation
    SKAction *faceAction = [SKAction animateWithTextures:faceArray timePerFrame:0.25];
    [face runAction:[SKAction repeatActionForever:faceAction]];
    
    //create----miner:leg
    SKSpriteNode *leg = [SKSpriteNode createWithSpriteFrameName:@"miner-leg-0.png"];
    leg.position = CGPointMake(-kScreenWidth * 0.3531, -kScreenHeight * 0.3354);
    [self addChild:leg];
    NSMutableArray *legArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"miner-leg-%d.png",i];
        SKTexture * texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:textureName];
        [legArray addObject:texture];
    }
    
    //leg animation
    SKAction *legAction = [SKAction animateWithTextures:legArray timePerFrame:0.15];
    [leg runAction:[SKAction repeatActionForever:legAction]];
    
}


#pragma mark - 云彩和运动
- (void)initCloudAndDoAnimation
{
    SKSpriteNode *cloud1 = [SKSpriteNode createWithSpriteFrameName:@"clouds-0.png"];
    cloud1.position = CGPointMake(-600, kScreenHeight * 0.5 - 50);
    cloud1.alpha = 0.9;
    cloud1.zPosition = 1;
    [self addChild:cloud1];
    SKAction *movetoAction1 = [SKAction moveTo:CGPointMake(kScreenWidth * 0.5 + 130, cloud1.position.y) duration:60];
    SKAction *movetoAction2 = [SKAction moveTo:CGPointMake(-600, cloud1.position.y) duration:0];
    SKAction *sequenceAction1 = [SKAction sequence:@[movetoAction1,movetoAction2]];
    [cloud1 runAction:[SKAction repeatActionForever:sequenceAction1]];
    
    
    
    SKSpriteNode *cloud2 = [SKSpriteNode createWithSpriteFrameName:@"clouds-1.png"];
    cloud2.position = CGPointMake(-1000, kScreenHeight * 0.5 - 100);
    cloud2.alpha = 0.9;
    cloud2.zPosition = 1;
    [self addChild:cloud2];
    SKAction *movetoAction3 = [SKAction moveTo:CGPointMake(kScreenWidth * 0.5 + 130, cloud2.position.y) duration:90];
    SKAction *movetoAction4 = [SKAction moveTo:CGPointMake(-600, cloud2.position.y) duration:0];
    SKAction *sequenceAction2 = [SKAction sequence:@[movetoAction3,movetoAction4]];
    [cloud2 runAction:[SKAction repeatActionForever:sequenceAction2]];
}

@end
