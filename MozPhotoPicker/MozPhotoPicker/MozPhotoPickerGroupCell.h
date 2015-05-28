//
//  MozPhotoPickerGroupCell.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MozPhotoPickerGroupCell : UITableViewCell

@property(nonatomic,readonly)UIImageView *groupThumbnailImageView;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UILabel *imageCountLabel;
-(void)loadGroup:(ALAssetsGroup*)group;

+(CGFloat)cellHeight;

@end
