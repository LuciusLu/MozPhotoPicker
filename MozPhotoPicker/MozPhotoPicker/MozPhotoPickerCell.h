//
//  MozPhotoPickerCell.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MozPhotoPickerCell : UITableViewCell

@property(nonatomic)NSMutableArray *itemViewArray;

- (void)loadData:(NSArray *)array target:(id)target action:(SEL)action;
+ (CGFloat)cellHeight;

@end
