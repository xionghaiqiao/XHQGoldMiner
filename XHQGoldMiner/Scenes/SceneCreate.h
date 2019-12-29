//
//  Scene1.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "global.h"
#import "BaseButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneCreate : SKScene

@property (nonatomic,assign)BuyProductIndex buyProductIndex;
@property (nonatomic,strong)BaseButton *bombBUtton;

+(SceneCreate *)createSceneWithParam:(BuyProductIndex)param;

@end

NS_ASSUME_NONNULL_END
