//
//  MozPhotoPickerCellItemView.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoPickerCellItemView.h"
#import "UIColor+mozColor.h"

@implementation MozPhotoPickerCellItemView

@synthesize photoItem = _photoItem;

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor colorWithHex:0x2c3e50].CGColor;
    }else{
        self.layer.borderWidth = 0;
    }
}

@end
