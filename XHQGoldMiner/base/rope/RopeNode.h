//
//  RopeNode.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RopeNode : SKNode

@property (nonatomic,strong)SKSpriteNode *rope;
@property (nonatomic,strong)SKSpriteNode *hook;
@property (nonatomic,assign)CGFloat scaleFactor;
- (void)startRopeAnimation;
- (void)addRopeHeight:(CGFloat)height;
- (void)subRopeHeight:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
