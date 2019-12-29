//
//  XHQTextureAtlas.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "XHQTextureAtlas.h"

@implementation XHQTextureAtlas
singleton_implementation(XHQTextureAtlas)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.atlasDict = [NSMutableDictionary dictionary];
        //self.framesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addSpriteFramesWithFile:(NSString *)pListFile
{
    [self ParsePListFile:pListFile];
}

- (void)ParsePListFile:(NSString *)pListFile;
{
    //首先根据plistfile名称判断是否已经存在，如果已经存在则不需要再次添加
    NSMutableDictionary *targetDict = [self.atlasDict objectForKey:pListFile];
    if (targetDict != nil)
    {
        return;
    }
    
    NSString *textureName;
    NSString *path = [[NSBundle mainBundle] pathForResource:pListFile ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //解析文件中的meta，获取texture文件名称
    NSDictionary *metaDict = dict[@"metadata"];
    if (metaDict == nil)
    {
        //使用.plist换为.png
        NSArray *substringArray = [pListFile componentsSeparatedByString:@"."];
        textureName = [NSString stringWithFormat:@"%@%@",substringArray[0],@".png"];
        
    }
    else
    {
        textureName = metaDict[@"textureFileName"];
    }
    _fullImage = [UIImage imageNamed:textureName];
    _fullTexture = [SKTexture textureWithImage:[UIImage imageNamed:textureName]];
    if (_fullTexture == nil)
    {
        return;
    }
    //XHQTextureFrame *textureframe = [XHQTextureFrame alloc]initw
    //解析各个子图片的大小
    NSDictionary *framesDict = dict[@"frames"];
    NSMutableDictionary *texturesDict = [NSMutableDictionary dictionary];
    [framesDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop)
    {
      
        XHQTextureFrame *textureFrame = [[XHQTextureFrame alloc]initTextureFrameWithDict:obj FullTexture:_fullTexture FullImage:_fullImage];
        [texturesDict setObject:textureFrame forKey:key];
    }];

    [self.atlasDict setObject:texturesDict forKey:pListFile];
    
    return;
}

- (XHQTextureFrame *)getTextureFrameWithName:(NSString *)name
{
    //遍历atlasDict，取出其中的每一个framesDict
    NSArray *keyArray = [self.atlasDict allKeys];
    for (int i = 0; i < keyArray.count; i++)
    {
        NSString *str = [keyArray objectAtIndex:i];
        NSDictionary *framesDict = [self.atlasDict objectForKey:str];
        NSArray *keyFrameArray = [framesDict allKeys];
        if ([keyFrameArray containsObject:name])
        {
            XHQTextureFrame *textureFrame = [framesDict objectForKey:name];
            if (textureFrame == nil)
            {
                return nil;
            }
            return textureFrame;
        }
    }

    return nil;
}

- (SKTexture *)getTexturebyFrameName:(NSString *)name
{
    XHQTextureFrame *frame = [self getTextureFrameWithName:name];
    NSLog(@"picture name = %@", name);
    SKTexture *texture = [frame getFrameTexture:frame];
    
    return texture;
}

@end
