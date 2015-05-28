//
//  MozPhotoItem.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MozPhotoItem : NSObject

@property(nonatomic)ALAsset *asset;
@property(nonatomic)BOOL isSelected;
-(id)initWithAsset:(ALAsset*)asset;

@end
