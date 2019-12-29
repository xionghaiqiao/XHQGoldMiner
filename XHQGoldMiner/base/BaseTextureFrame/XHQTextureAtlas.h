//
//  XHQTextureAtlas.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "XHQTextureFrame.h"
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHQTextureAtlas : NSObject
singleton_interface(XHQTextureAtlas)
@property(nonatomic, strong) NSString *plistFile;
@property(nonatomic, strong) NSString *imageFile;
@property(nonatomic, strong) SKTexture *fullTexture;
@property(nonatomic, strong) UIImage *fullImage;
//记录多个atlas集合
@property(nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary *>*atlasDict;
//记录每个atlas中的frame
//@property(nonatomic, strong) NSMutableDictionary<NSString *, XHQTextureFrame *> *framesDict;

- (void)addSpriteFramesWithFile:(NSString *)pListFile;
- (XHQTextureFrame *)getTextureFrameWithName:(NSString *)name;
- (SKTexture *)getTexturebyFrameName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
