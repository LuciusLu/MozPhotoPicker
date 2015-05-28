//
//  MozPhotoItem.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoItem.h"

@implementation MozPhotoItem

-(id)initWithAsset:(ALAsset*)asset{
    if (self) {
        self.asset=asset;
    }
    return self;
}

@end
