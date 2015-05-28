//
//  MozPhotoPickerCellItemView.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MozPhotoItem.h"

@interface MozPhotoPickerCellItemView : UIImageView

@property(nonatomic, assign)BOOL selected;
@property(nonatomic, retain)MozPhotoItem *photoItem;

@end
