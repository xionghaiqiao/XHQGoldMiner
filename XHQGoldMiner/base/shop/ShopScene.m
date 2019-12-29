//
//  ShopScene.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ShopScene.h"
#import "global.h"
#import "BaseButton.h"
#import "XHQTextureAtlas.h"
#import "SceneCreate.h"
#import "UserDataManager.h"
#import "SoundTool.h"
#import "DSMultilineLabelNode.h"
typedef enum
{
    kBombIndex = 0,
    kPowerIndex,
    kGoodStoneIndex,
    kBookIndex
}ProductIndex;

@interface ShopScene ()
{
    
}
@property (nonatomic, strong)SKSpriteNode *shoper;
@property (nonatomic, strong)NSMutableArray *shoperArray;
@property (nonatomic, strong)SKAction *shoperAction;

@property (nonatomic, strong)BaseButton *nextStageButton;
@property (nonatomic, strong)BaseButton *buyButton;
@property (nonatomic, strong)DSMultilineLabelNode *productInfoLabel;
@property (nonatomic, strong)SKLabelNode *totalMoneyLabel;
@property (nonatomic, assign)NSInteger selectIndex;//当前选中的物品
@property (nonatomic, strong)SKShapeNode *selectNode;

//按钮
@property (nonatomic, strong)BaseButton *bombButton;
@property (nonatomic, strong)BaseButton *powerButton;
@property (nonatomic, strong)BaseButton *goodStoneButton;
@property (nonatomic, strong)BaseButton *bookButton;

//购买物品
@property (nonatomic,assign)BOOL isBuyBomb;
@property (nonatomic,assign)BOOL isBuyPower;
@property (nonatomic,assign)BOOL isBuyGoodStone;
@property (nonatomic,assign)BOOL isBuyBook;
@property (nonatomic,assign,readwrite)BuyProductIndex buyProductIndex;
@end


@implementation ShopScene

- (void)didMoveToView:(SKView *)view
{
    [self initShopItems];
    self.selectIndex = 0;
    [self showProductInfo:self.selectIndex];
    //[self initShoperAnimation];
    //[self.shoper runAction:self.shoperAction];
}

- (void)initShopItems
{
    __weak typeof(self) weakSelf = self;
    self.shoper = (SKSpriteNode *)[self childNodeWithName:@"shoper"];
    SKTexture *shoperTexture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"shoper0025.png"];
    self.shoper.texture = shoperTexture;
    
    self.totalMoneyLabel = (SKLabelNode *)[self childNodeWithName:@"totalMoney"];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%ld", [UserDataManager sharedUserDataManager].totalMoney];
    
    self.nextStageButton = (BaseButton *)[self childNodeWithName:@"nextStage"];
    SKTexture *nextStage = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"next-btn-0.png"];
    self.nextStageButton.texture = nextStage;
    self.nextStageButton.userInteractionEnabled = YES;
    self.nextStageButton.btnType = kButtonTypeOther;
    //下一关按键
    self.nextStageButton.btnPressedControlBlock = ^{
        NSLog(@"nextStage button pressed");
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        SceneCreate *scene = [SceneCreate createSceneWithParam:weakSelf.buyProductIndex];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        SKView *skView = (SKView *)weakSelf.scene.view;
        [skView presentScene:scene];
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
        [[UserDataManager sharedUserDataManager] saveUserData];
    };
    
    //购买物品按键
    self.buyButton = (BaseButton *)[self childNodeWithName:@"buy"];
    SKTexture *buyTexture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"nextStage"];
    self.buyButton.texture = buyTexture;
    self.buyButton.userInteractionEnabled = YES;
    self.buyButton.btnType = kButtonTypeOther;
#warning should delete this param
    __block NSInteger totalMoney = [UserDataManager sharedUserDataManager].totalMoney;
    self.buyButton.btnPressedControlBlock = ^{
        NSLog(@"buyButton button pressed");
        BuyProductIndex tempIndex;
        tempIndex = self.buyProductIndex;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        SKSpriteNode *node;
        
        switch (weakSelf.selectIndex) {
            case kBombIndex:
                if ((totalMoney >= kBombPrice) && (!weakSelf.isBuyBomb))
                {
                    node = (SKSpriteNode *)[self childNodeWithName:@"one"];
                    node.hidden = NO;
                    tempIndex.isBuyBomb = YES;
                    totalMoney -= kBombPrice;
                }
                break;
            case kPowerIndex:
                if ((totalMoney >= kPowerPrice) && (!weakSelf.isBuyPower))
                {
                    node = (SKSpriteNode *)[self childNodeWithName:@"two"];
                    node.hidden = NO;
                    tempIndex.isBuyPower = YES;
                    totalMoney -= kPowerPrice;
                }
                break;
            case kGoodStoneIndex:
                if ((totalMoney >= kGoodStonePrice) && (!weakSelf.isBuyGoodStone))
                {
                    node = (SKSpriteNode *)[self childNodeWithName:@"three"];
                    node.hidden = NO;
                    tempIndex.isBuyGoodStone = YES;
                    totalMoney -= kGoodStonePrice;
                }
                break;
            case kBookIndex:
                if ((totalMoney >= kBombPrice) && (!weakSelf.isBuyBook))
                {
                    node = (SKSpriteNode *)[self childNodeWithName:@"four"];
                    node.hidden = NO;
                    tempIndex.isBuyBook = YES;
                    totalMoney -= kBookPrice;
                }
                break;
            default:
                break;
        }
        weakSelf.buyProductIndex = tempIndex;
        weakSelf.totalMoneyLabel.text = [NSString stringWithFormat:@"%ld", totalMoney];
    };
    
    //----product----
    //bomb
    
    self.bombButton = (BaseButton *)[self childNodeWithName:@"bomb"];
    SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"tool1.png"];
    self.bombButton.texture = texture;
    self.bombButton.userInteractionEnabled = YES;
    self.bombButton.btnType = kButtonTypeOther;
    self.bombButton.btnPressedControlBlock = ^{
        weakSelf.selectIndex = kBombIndex;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        [weakSelf showProductInfo:weakSelf.selectIndex];
    };
    //power
    self.powerButton = (BaseButton *)[self childNodeWithName:@"power"];
    texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"tool2.png"];
    self.powerButton.texture = texture;
    self.powerButton.userInteractionEnabled = YES;
    self.powerButton.btnPressedControlBlock = ^{
        weakSelf.selectIndex = kPowerIndex;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        [weakSelf showProductInfo:weakSelf.selectIndex];
    };
    //good stone
    self.goodStoneButton = (BaseButton *)[self childNodeWithName:@"goodStone"];
    texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"tool4.png"];
    self.goodStoneButton.texture = texture;
    self.goodStoneButton.userInteractionEnabled = YES;
    self.goodStoneButton.btnPressedControlBlock = ^{
        weakSelf.selectIndex = kGoodStoneIndex;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        [weakSelf showProductInfo:weakSelf.selectIndex];
    };
    //book
    self.bookButton = (BaseButton *)[self childNodeWithName:@"book"];
    texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"tool5.png"];
    self.bookButton.texture = texture;
    self.bookButton.userInteractionEnabled = YES;
    self.bookButton.btnPressedControlBlock = ^{
        weakSelf.selectIndex = kBookIndex;
        //播放按键音乐
        [[SoundTool sharedSoundTool]playSoundByName:@"Select.mp3"];
        [weakSelf showProductInfo:weakSelf.selectIndex];
    };
    
    //product info
    //{{-120, -200},{600, 200}}
    self.productInfoLabel = [DSMultilineLabelNode labelNodeWithFontNamed:@"Futura"];
    self.productInfoLabel.position = CGPointMake(-120, -200);
    self.productInfoLabel.fontSize = 28;
    self.productInfoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.productInfoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    self.productInfoLabel.text = kBombInfo;
    self.productInfoLabel.paragraphWidth = 600;
    self.productInfoLabel.zPosition = 2;
    [self addChild:self.productInfoLabel];
    
    
    self.isBuyBomb      = NO;
    self.isBuyBook      = NO;
    self.isBuyPower     = NO;
    self.isBuyGoodStone = NO;
    
    //invisible the "one" tag
    SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:@"one"];
    node.hidden = YES;
    node = (SKSpriteNode *)[self childNodeWithName:@"two"];
    node.hidden = YES;
    node = (SKSpriteNode *)[self childNodeWithName:@"three"];
    node.hidden = YES;
    node = (SKSpriteNode *)[self childNodeWithName:@"four"];
    node.hidden = YES;
    
}
- (void) initShoperAnimation
{
    self.shoperArray = [NSMutableArray array];
    NSString *name = [NSString stringWithFormat:@"shoper0001.png"];
    SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas] getTexturebyFrameName:name];
//    self.shoper = [SKSpriteNode spriteNodeWithTexture:texture];
//    self.shoper.position = CGPointMake(25, kScreenHeight * 0.4);
//    [self.shoper setScale:0.8];
//    [self addChild:self.shoper];
//    [self.shoperArray addObject:texture];
    //????这里可能不对，需要动画的自己添加吧
    for (int i = 1; i <= 35; i++)
    {
        name = [NSString stringWithFormat:@"shoper00%02d.png",i];
        texture = [[XHQTextureAtlas sharedXHQTextureAtlas] getTexturebyFrameName:name];
        [self.shoperArray addObject:texture];
    }
    SKAction *animationAction = [SKAction animateWithTextures:self.shoperArray timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animationAction];
    self.shoperAction = repeatAction;
    
}
- (void)showProductInfo:(NSInteger)productIndex
{
    if (self.selectNode != nil)
    {
        [self.selectNode removeFromParent];
    }
    
    if (productIndex == kBombIndex)
    {
        CGRect rect = self.bombButton.frame;
        rect = CGRectMake(rect.origin.x-6, rect.origin.y -6 , rect.size.width + 12, rect.size.height + 12);
        self.selectNode = [SKShapeNode shapeNodeWithRect:rect];
        self.productInfoLabel.text = kBombInfo;
        
    }
    else if (productIndex == kPowerIndex)
    {
        CGRect rect = self.powerButton.frame;
        rect = CGRectMake(rect.origin.x-6, rect.origin.y -6 , rect.size.width + 12, rect.size.height + 12);
        self.selectNode = [SKShapeNode shapeNodeWithRect:rect];
        self.productInfoLabel.text = kPowerInfo;
    }
    else if (productIndex == kGoodStoneIndex)
    {
        CGRect rect = self.goodStoneButton.frame;
               rect = CGRectMake(rect.origin.x-6, rect.origin.y -6 , rect.size.width + 12, rect.size.height + 12);
        self.selectNode = [SKShapeNode shapeNodeWithRect:rect];
        self.productInfoLabel.text = kGoodStoneInfo;
    }
    else
    {
        CGRect rect = self.bookButton.frame;
               rect = CGRectMake(rect.origin.x-6, rect.origin.y -6 , rect.size.width + 12, rect.size.height + 12);
        self.selectNode = [SKShapeNode shapeNodeWithRect:rect];
        self.productInfoLabel.text = kBookInfo;
    }
    
    self.selectNode.strokeColor = [UIColor redColor];
    self.selectNode.lineWidth = 5;
    [self addChild:self.selectNode];
}

@end
