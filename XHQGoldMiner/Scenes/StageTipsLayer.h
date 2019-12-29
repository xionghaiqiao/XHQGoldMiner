//
//  StageTipsLayer.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol StageTipsLayerDelegate <NSObject>

- (void)tipsOver;
@end

@interface StageTipsLayer : SKNode

@property(nonatomic,weak) id<StageTipsLayerDelegate>  delegate;
@end

NS_ASSUME_NONNULL_END
