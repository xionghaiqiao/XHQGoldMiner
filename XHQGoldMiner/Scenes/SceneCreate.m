//
//  Scene1.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SceneCreate.h"
#import "StageTipsLayer.h"
#import "XHQTextureAtlas.h"
#import "RopeNode.h"
#import "global.h"
#import "GoldNode.h"
#import "ConfigMenu.h"
#import "UserDataManager.h"
#import "ShopScene.h"
#import "ShowSuccessOrFailLayer.h"
#import "SoundTool.h"

@interface SceneCreate () <SKPhysicsContactDelegate,StageTipsLayerDelegate,BaseButtonDelegate>
{
    
}
@property(nonatomic, strong)SKSpriteNode *miner;
@property(nonatomic, strong)StageTipsLayer *tipNode;
@property(nonatomic, strong)SKLabelNode *totalMoneyLabel;
@property(nonatomic, strong)SKLabelNode *requestMoneyLabel;
@property(nonatomic, strong)SKLabelNode *timeLeftLabel;
@property(nonatomic, strong)SKLabelNode *currentStageLabel;
//@property(nonatomic, strong)SKNode *tipsNode;
@property(nonatomic, strong)BaseButton *bombButton;
@property(nonatomic, strong)RopeNode *ropeNode;
@property(nonatomic, assign)BOOL isGameStart;           //游戏是否开始
@property(nonatomic, assign)BOOL isRopeRunning;         //绳子前行
@property(nonatomic, assign)BOOL isRopeBacking;         //绳子返回
@property(nonatomic, assign)BOOL isHokeSomething;       //是否钓到了东西
@property(nonatomic, assign)NSInteger currentStage;     //当前关卡
@property(nonatomic, assign)NSInteger curStageScore;
//gold精灵
@property(nonatomic, strong)GoldNode *goldNode;
//时间计数
@property(nonatomic,assign)int timeLimit;
@property(nonatomic,assign)NSTimeInterval elapseTime;
@property(nonatomic,assign)int startTime;
@property(nonatomic,assign)NSTimeInterval deltaTime;        //计算update调用的每次间隔时间
@property(nonatomic,assign)NSTimeInterval lastUpdateTime;   //计算update调用的每次间隔时间
@property(nonatomic,strong)NSMutableArray *minerArray;
@property(nonatomic,strong)SKAction *minerAction;
@property(nonatomic, strong)BaseButton *pauseButton;
//配置界面
@property(nonatomic, strong)ConfigMenu *configMenu;

@end


@implementation SceneCreate

#pragma mark - 创建场景
+(SceneCreate *)createSceneWithParam:(BuyProductIndex)param
{
    
    SceneCreate *scene  = [SceneCreate nodeWithFileNamed:@"SceneCreate"];
    scene.buyProductIndex = param;
    scene.isGameStart   = NO;
    scene.curStageScore = 0;
    scene.timeLimit     = 60;
    return scene;
}


#pragma mark - 初始化场景
- (void)didMoveToView:(SKView *)view
{
    
    //播放按键音乐
    [[SoundTool sharedSoundTool]playSoundByName:@"level.mp3"];
    
    [self setupPhysicalWorld];
    [self initSceneInfo];
    [self initBombButton];
    [self showStageTips];
    [self initMinerAnimation];
    [self initRope];
    
    [self loadStageInfo];
    
}
- (void) initMinerAnimation
{
    self.minerArray = [NSMutableArray array];
    NSString *name = [NSString stringWithFormat:@"miner0001.png"];
    SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas] getTexturebyFrameName:name];
    self.miner = [SKSpriteNode spriteNodeWithTexture:texture];
    self.miner.position = CGPointMake(25, kScreenHeight * 0.4);
    [self.miner setScale:0.8];
    [self addChild:self.miner];
    [self.minerArray addObject:texture];
    
    for (int i = 2; i <= 20; i++)
    {
        name = [NSString stringWithFormat:@"miner00%02d.png",i];
        texture = [[XHQTextureAtlas sharedXHQTextureAtlas] getTexturebyFrameName:name];
        [self.minerArray addObject:texture];
    }
    SKAction *animationAction = [SKAction animateWithTextures:self.minerArray timePerFrame:0.03];
    SKAction *repeatAction = [SKAction repeatActionForever:animationAction];
    self.minerAction = repeatAction;
    
}

- (void)loadStageInfo
{
    NSInteger stageNum = [UserDataManager sharedUserDataManager].stageNumber;
    NSInteger level = stageNum % 5 + 1;
    NSInteger randX = 0;
    NSInteger randY = 0;
    int randStone = 0;
    //StoneType stoneType;
    for (int i = 0; i < 20; i++)
    {
        randY = arc4random() % (kScreenHeight - 250) - ((kScreenHeight) * 0.5 + 50);
        randX = arc4random() % (kScreenWidth - 100)- (kScreenWidth * 0.5);
        randStone = arc4random() % kStoneTypeMax;
        
        GoldNode *stone = [[GoldNode alloc]initWithType:randStone];
        stone.position = CGPointMake(randX, randY);
        [self addChild:stone];
        if (((randStone <= kBigStone)&& (randStone >= kSmallStone)) && (self.buyProductIndex.isBuyBook))
        {
            stone.score *= 3.0;
        }
        if (self.buyProductIndex.isBuyPower)
        {
            stone.backSpeed *= 1.2;
        }
    }
}

//the stage notify information
- (void)showStageTips
{
    self.tipNode = [[StageTipsLayer alloc]init];
    self.tipNode.delegate = self;
    [self addChild:self.tipNode];
}

- (void)initSceneInfo
{
    self.totalMoneyLabel = (SKLabelNode *)[self childNodeWithName:@"totalMoney"];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%ld",[UserDataManager sharedUserDataManager].totalMoney];
    self.curStageScore = [UserDataManager sharedUserDataManager].totalMoney;
    self.requestMoneyLabel = (SKLabelNode *)[self childNodeWithName:@"requestMoney"];
    self.currentStageLabel = (SKLabelNode *)[self childNodeWithName:@"currentStage"];
    self.timeLeftLabel = (SKLabelNode *)[self childNodeWithName:@"timeLeft"];
    self.pauseButton = (BaseButton *)[self childNodeWithName:@"//pauseButton"];
    self.pauseButton.userInteractionEnabled = YES;
    self.pauseButton.delegate = self;
    //设置按键按下处理block
    __weak typeof (self)weakSelf = self;
    self.pauseButton.btnPressedControlBlock = ^{
        [weakSelf pauseGame];
    };
    
    NSInteger passScroe = 650 + 275 * ([UserDataManager sharedUserDataManager].stageNumber - 1) + 410 * ([UserDataManager sharedUserDataManager].stageNumber - 1);
    self.requestMoneyLabel.text = [NSString stringWithFormat:@"%ld",passScroe];
    self.currentStageLabel.text = [NSString stringWithFormat:@"%ld",[UserDataManager sharedUserDataManager].stageNumber];
}

//setup physical world
- (void)setupPhysicalWorld
{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-kScreenWidth * 0.5, -kScreenHeight * 0.5, kScreenWidth, kScreenHeight)];
    self.physicsBody.categoryBitMask = kSceneCategory;
    self.physicsBody.contactTestBitMask = 0;
    self.physicsBody.collisionBitMask = 0;
}
- (void)initBombButton
{
    //dynamite.png
    if (!self.buyProductIndex.isBuyBomb)
    {
        return;
    }
    SKTexture *texture = [[XHQTextureAtlas sharedXHQTextureAtlas]getTexturebyFrameName:@"tool1.png"];
    self.bombBUtton = [[BaseButton alloc]initWithNormalTexture:texture PressedTexture:nil Rotated:NO];
    self.bombBUtton.position = CGPointMake(kScreenWidth * 0.08, kScreenHeight * 0.4);
    self.bombBUtton.zPosition = 12;
    self.bombBUtton.userInteractionEnabled = YES;
    self.bombBUtton.name = @"bombButton";
    //按键处理
    __weak typeof (self) weakSelf = self;
    self.bombBUtton.btnPressedControlBlock = ^{
        //首先判断是否抓到物品
        if (weakSelf.isHokeSomething)
        {
            [[SoundTool sharedSoundTool]playSoundByName:@"bomb.mp3"];
            //炸弹图片消失
            [weakSelf.bombBUtton removeFromParent];
            //首先在绳子位置显示爆炸效果
            SKEmitterNode *emitter = [SKEmitterNode nodeWithFileNamed:@"bomb.sks"];
            //需要进行坐标转换
            emitter.position = [weakSelf.ropeNode convertPoint:weakSelf.goldNode.position toNode:weakSelf];
            //emitter.position = weakSelf.goldNode.position;
            NSLog(@"emitter.position = %@",NSStringFromCGPoint(emitter.position));
            [weakSelf addChild:emitter];
            //绳子速度恢复
            [weakSelf.goldNode removeFromParent];
            weakSelf.goldNode = nil;
            weakSelf.isHokeSomething = NO;
            
            
        }
    };
    [self addChild:self.bombBUtton];
}


#pragma mark - 伸长和收缩绳子
- (void)initRope
{
    self.ropeNode = [[RopeNode alloc]init];
    CGFloat scale = self.ropeNode.scaleFactor;
    self.ropeNode.position = CGPointMake(0, kScreenHeight * 0.38);
    [self addChild:self.ropeNode];
}
- (void)addRopdHeight:(CGFloat)dt
{
    [self.ropeNode addRopeHeight:dt];
}

- (void)subRopdHeight:(CGFloat)dt
{
    if (self.ropeNode.rope.size.height <= kOrigionRopeHeight)
    {
        self.isRopeBacking = NO;
        self.ropeNode.rope.size = CGSizeMake(self.ropeNode.rope.size.width, kOrigionRopeHeight);
        //如果抓到stone等
        if (self.isHokeSomething)
        {
            //更新分数
            NSLog(@"score = %ld",self.goldNode.score);
            self.curStageScore += self.goldNode.score;
            //动画更新分数
            SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld",self.goldNode.score]];
            scoreLabel.position = CGPointMake(self.ropeNode.position.x, self.ropeNode.position.y - kOrigionRopeHeight);
            scoreLabel.zPosition = 2;
            scoreLabel.fontSize = 32;
            scoreLabel.fontName = @"Helvetica Neue Bold 32.0";
            scoreLabel.fontColor = [UIColor colorWithRed:69/255.0 green:1 blue:15/255.0 alpha:1];
            [self addChild:scoreLabel];
            [scoreLabel runAction:[SKAction moveTo:self.totalMoneyLabel.position duration:1.0]completion:^{
                [scoreLabel removeFromParent];
                self.totalMoneyLabel.text = [NSString stringWithFormat:@"%ld",self.curStageScore];
            }];
            
            //将金块不再显示
            [self.goldNode removeFromParent];
            self.goldNode = nil;
            self.isHokeSomething = NO;
            [[SoundTool sharedSoundTool]playSoundByName:@"laend.mp3"];
        }
        //继续摇摆钩子
        [self.ropeNode startRopeAnimation];
        [self.miner removeAllActions];
    }
    else
    {
        [self.ropeNode subRopeHeight:dt];
    }
    
}

#pragma mark - touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isGameStart)
    {
        return;
    }
    if ((self.isRopeRunning) || (self.isRopeBacking))
    {
        return;
    }
    self.isRopeRunning = YES;
    //停止action,晃动钩子等动作
    [self.ropeNode removeAllActions];
    [self.miner runAction:self.minerAction];
    [[SoundTool sharedSoundTool]playSoundByName:@"lastart.mp3"];
}


#pragma mark - 碰撞检测
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (!self.isGameStart)
    {
        return;
    }
    if (!self.isRopeRunning && !self.isRopeBacking)
    {
        return;
    }
    
    SKPhysicsBody *bodyA = contact.bodyA;
    SKPhysicsBody *bodyB = contact.bodyB;
    //确保bodyA一定是hook
    if (bodyA.categoryBitMask > bodyB.categoryBitMask)
    {
        bodyA = contact.bodyB;
        bodyB = contact.bodyA;
    }
    //判断是否钓到了东西
    if (bodyB.categoryBitMask == kSceneCategory)
    {
        self.isHokeSomething = NO;
        self.isRopeRunning = NO;
        self.isRopeBacking = YES;
    }
    else
    {
        self.isHokeSomething = YES;
        bodyB.contactTestBitMask = 0;
        self.goldNode =(GoldNode *)bodyB.node;
        self.goldNode.position = bodyA.node.position;
        [bodyB.node removeFromParent];
        [bodyA.node.parent addChild:self.goldNode];
        self.isRopeRunning = NO;
        self.isRopeBacking = YES;
        if (self.buyProductIndex.isBuyBook)
        {
            
        }
    }
    
}

#pragma mark - 定时更新
- (void)update:(NSTimeInterval)currentTime
{
    //统计时间
    if (!self.lastUpdateTime)
    {
        
        self.deltaTime = 0;
    }
    else
    {
        self.deltaTime = currentTime - self.lastUpdateTime;
    }
    self.lastUpdateTime = currentTime;
    
    if (!self.isGameStart)
    {
        return;
    }
    
    //----时间计数-----
    //开始计算时间
    self.elapseTime += self.deltaTime ;
    int timeleft = self.timeLimit - (int)self.elapseTime;
    if (timeleft <= 0)
    {
#warning - game over 计算是否到下一关
        [self stopGame];
    }
    else
    {
        self.timeLeftLabel.text = [NSString stringWithFormat:@"%02d", timeleft];
    }
    //如果rope在原始位置转动，退出
    if (!self.isRopeRunning && !self.isRopeBacking)
    {
        return;
    }
    
    
    if (self.isRopeRunning)
    {
        [self addRopdHeight:kNormalRopeSpeed];
    }
    else if (self.isRopeBacking)
    {
        //抓到石头
        if (self.goldNode != nil)
        {
            [self subRopdHeight:self.goldNode.backSpeed];
        }
        //碰壁而归
        else
        {
            [self subRopdHeight:kNormalRopeSpeed];
        }
    }
}
//更新剩余时间显示
- (void)updateTimer:(int)time
{
    int seconds = time % 60;
    NSString *str = [NSString stringWithFormat:@"%02d",seconds];
    self.timeLeftLabel.text = str;
}

#pragma mark - tip的代理
- (void)tipsOver
{
    self.isGameStart = YES;
    NSLog(@"game start!");
    [self startAllAnimations];
}
#pragma mark - start and stop Animations
- (void)startAllAnimations
{
    [self.ropeNode startRopeAnimation];
}

- (void)stopAllAnimations
{
    [self removeAllActions];
}

#pragma mark - game control

- (void)stopGame
{
    self.paused = NO;
    [self removeAllActions];
    self.timeLeftLabel.text = @"0";
    self.isGameStart = NO;
    NSInteger stageNumber = [UserDataManager sharedUserDataManager].stageNumber;
    NSInteger totalMoney = [UserDataManager sharedUserDataManager].totalMoney;
    NSInteger passScroe = 650 + 275 * (stageNumber - 1) + 410 * (stageNumber - 1);
    [[SoundTool sharedSoundTool]playSoundByName:@"finish.mp3"];
    //计算剩余金钱
    totalMoney += self.curStageScore;
    
    [UserDataManager sharedUserDataManager].totalMoney = totalMoney;
    
    if ((self.curStageScore + totalMoney) >= passScroe)
    {
        //计算剩余金钱
        totalMoney -= passScroe;
        [UserDataManager sharedUserDataManager].stageNumber += 1;
         ShowSuccessOrFailLayer *layer = [[ShowSuccessOrFailLayer alloc]initWithResult:1];
        [self addChild:layer];
    }
    else
    {
        ShowSuccessOrFailLayer *layer = [[ShowSuccessOrFailLayer alloc]initWithResult:0];
        [self addChild:layer];
    }
    [[UserDataManager sharedUserDataManager]saveUserData];
    
    
}

- (void)pauseGame
{
    if (!self.isPaused)
    {
        NSLog(@"pause!");
        self.paused = YES;
        self.lastUpdateTime = 0;
        self.pauseButton.userInteractionEnabled = NO;
        self.configMenu = [[ConfigMenu alloc]init];
        self.configMenu.userInteractionEnabled = YES;
        [self.configMenu configAllMenus];
        self.configMenu.closeButton.delegate = self;
        [self addChild:self.configMenu];
    }
    
}

- (void)continueGame
{
    self.paused = NO;
}


#pragma mark - delegate
- (void)baseButtonPressedWithBtnType:(NSInteger)btnType
{
    NSLog(@"can this delegate called?");
    if (btnType == kButtonTypeOther)
    {
        
    }
    else if (btnType == kButtonTypeCloseConfigMenu)
    {
        self.paused = NO;
        [self.configMenu removeFromParent];
        self.pauseButton.userInteractionEnabled = YES;
    }
    else if (btnType == kButtonTypeShowConfigMenu)
    {
        
    }
}

@end
