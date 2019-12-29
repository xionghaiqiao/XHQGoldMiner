//
//  BaseButton.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "BaseButton.h"
@interface BaseButton ()
{
    SKTexture *_normalTexture;
    SKTexture *_pressedTexture;
}
@end
@implementation BaseButton
- (BaseButton *)initWithNormalTexture:(SKTexture *)normalTexture PressedTexture: (SKTexture * _Nullable)pressedTexture Rotated:(BOOL)rotated
{
    _normalTexture = normalTexture;
    _pressedTexture = pressedTexture;
    self = [self initWithTexture:normalTexture color:[UIColor clearColor] size:normalTexture.size];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_pressedTexture)
    {
        self.texture = _pressedTexture;
    }
    
    if (self.btnPressedControlBlock)
    {
        self.btnPressedControlBlock();
    }
    
    
}


@end
