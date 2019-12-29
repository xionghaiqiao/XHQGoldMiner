//
//  GoldNode.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "global.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoldNode : SKSpriteNode
@property(nonatomic, assign)CGFloat backSpeed;
@property(nonatomic, assign)NSInteger score;
- (instancetype)initWithType:(StoneType)stoneType;
@end

NS_ASSUME_NONNULL_END
