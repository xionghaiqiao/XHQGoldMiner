//
//  ConfigMenu.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ConfigMenu.h"
#import "XHQTextureAtlas.h"
#import "BaseButton.h"
#import "global.h"
#import "GameScene.h"
#import "SoundTool.h"
#import "UserDataManager.h"
#import "ShopScene.h"

@interface ConfigMenu ()
{
    
    
}
@property (nonatomic, strong)SKSpriteNode *rootNode;
@property (nonatomic, strong)BaseButton *musicOnNode;
@property (nonatomic, strong)BaseButton *soundOnNode;
@property (nonatomic, strong)BaseButton *nextStageButton;
@property (nonatomic, strong)BaseButton *backButton;

@end

@implementation ConfigMenu

- (void)configAllMenus
{
    __weak typeof(self)weakSelf = self;
    SKScene *scene = [SKScene nodeWithFileNamed:@"ConfigMenu.sks"];
    self.rootNode = (SKSpriteNode *)[scene childNodeWithName:@"root"];
    [self.rootNode removeFromParent];
    [self addChild:self.rootNode];
    
    //open or close background music
    self.musicOnNode = (BaseButton *)[self childNodeWithName:@"//musicButton"];
    SKTexture *musicOnBackground;
    if ([SoundTool sharedSoundTool].isSoundMute)
    {
        //静音图片
        musicOnBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"music-off-btn-0.png"];
    }
    else
    {
        musicOnBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"music-on-btn-0.png"];
    }
    self.musicOnNode.texture = musicOnBackground;
    self.musicOnNode.userInteractionEnabled = YES;
    self.musicOnNode.btnType = kButtonTypeOther;
    self.musicOnNode.btnPressedControlBlock = ^{
        if ([SoundTool sharedSoundTool].isBgMusicMute)
        {
            [[SoundTool sharedSoundTool] setBgMusicMuted:NO];
        }
        else
        {
            [[SoundTool sharedSoundTool] setBgMusicMuted:YES];
        }
    };
   
    self.soundOnNode = (BaseButton *)[self childNodeWithName:@"//soundButton"];
    SKTexture *soundOnBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"sound-on-btn-0.png"];
    if ([SoundTool sharedSoundTool].isSoundMute)
    {
        soundOnBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"sound-off-btn-0.png"];
    }
    else
    {
        soundOnBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"sound-on-btn-0.png"];
    }
    
    self.soundOnNode.texture = soundOnBackground;
    self.soundOnNode.userInteractionEnabled = YES;
    self.soundOnNode.btnType = kButtonTypeOther;
    self.soundOnNode.btnPressedControlBlock = ^{
        if ([SoundTool sharedSoundTool].isSoundMute)
        {
            [[SoundTool sharedSoundTool] setSoundMuted:NO];
        }
        else
        {
            [[SoundTool sharedSoundTool] setSoundMuted:YES];
        }
    };
    
    //need to check whether this button enabled
    self.nextStageButton = (BaseButton *)[self childNodeWithName:@"//nextStageBackground"];
    NSInteger totalMoney = [UserDataManager sharedUserDataManager].totalMoney;
    __block NSInteger requestMoney = 650 + 275 * ([UserDataManager sharedUserDataManager].stageNumber - 1) + 410 * ([UserDataManager sharedUserDataManager].stageNumber - 1);
    SKTexture *nextStageBackground;
    if (totalMoney >= requestMoney)
    {
        nextStageBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"btn-0.png"];
        self.nextStageButton.userInteractionEnabled = YES;
    }
    else
    {
        nextStageBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"btn-2.png"];
        self.nextStageButton.userInteractionEnabled = NO;
    }
    self.nextStageButton.texture = nextStageBackground;
    self.nextStageButton.btnType = kButtonTypeOther;
    self.nextStageButton.btnPressedControlBlock = ^{
        [UserDataManager sharedUserDataManager].totalMoney -= requestMoney;
        [UserDataManager sharedUserDataManager].stageNumber += 1;
        [[UserDataManager sharedUserDataManager] saveUserData];
        ShopScene *scene    = (ShopScene *)[ShopScene nodeWithFileNamed:@"ShopScene.sks"];
        scene.scaleMode     = SKSceneScaleModeAspectFit;
        SKView *skView = (SKView *)weakSelf.scene.view;
        [skView presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
    };
    
    
    self.backButton = (BaseButton *)[self childNodeWithName:@"//backBackground"];
    SKTexture *backBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"btn-0.png"];
    self.backButton.texture = backBackground;
    self.backButton.userInteractionEnabled = YES;
    self.backButton.btnType = kButtonTypeOther;
    self.backButton.btnPressedControlBlock = ^{
        NSLog(@"backButton button pressed");
        GameScene *newScene = [GameScene nodeWithFileNamed:@"GameScene.sks"];
        newScene.scaleMode = SKSceneScaleModeAspectFit;
        [weakSelf.scene.view presentScene:newScene transition:[SKTransition flipVerticalWithDuration:1.0]];
    };
    
    
    //close-btn-0.png
    self.closeButton = (BaseButton *)[self childNodeWithName:@"//closeButton"];
    SKTexture *closeButtonBackground = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"close-btn-0.png"];
    self.closeButton.texture = closeButtonBackground;
    self.closeButton.userInteractionEnabled = YES;
    self.closeButton.btnType = kButtonTypeCloseConfigMenu;
    self.closeButton.btnPressedControlBlock = ^{
        NSLog(@"call delegate");
     //   if ([weakSelf.closeButton respondsToSelector:@selector(baseButtonPressedWithBtnType:)])
        {
            NSLog(@"delegate");
            [weakSelf.closeButton.delegate baseButtonPressedWithBtnType:kButtonTypeCloseConfigMenu];
        }
    };
}




@end
