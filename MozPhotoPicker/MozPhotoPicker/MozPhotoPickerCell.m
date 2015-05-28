//
//  MozPhotoPickerCell.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoPickerCell.h"
#import "MozPhotoItem.h"
#import "MozPhotoPickerCellItemView.h"

@implementation MozPhotoPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

-(NSMutableArray *)itemViewArray{
    if (!_itemViewArray) {
        _itemViewArray = [[NSMutableArray alloc]init];
    }
    return _itemViewArray;
}

- (void)loadUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.itemViewArray count]==0) {
        CGFloat size = [MozPhotoPickerCell cellHeight] - 4;
        for (int i=0; i<4; i++) {
            MozPhotoPickerCellItemView *imageView = [[MozPhotoPickerCellItemView alloc]initWithFrame:CGRectMake(2 + (size + 4)*i, 2, size, size)];
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
            [self.itemViewArray addObject:imageView];
        }
    }
}

- (void)loadData:(NSArray *)array target:(id)target action:(SEL)action{
    [self.itemViewArray enumerateObjectsUsingBlock:^(MozPhotoPickerCellItemView *imageView, NSUInteger idx, BOOL *stop) {
        if ([array count]>idx) {
            imageView.hidden = NO;
            
            MozPhotoItem *photoItem = array[idx];
            imageView.selected = photoItem.isSelected;
            imageView.photoItem = photoItem;
            if (photoItem.asset) {
                imageView.image = [UIImage imageWithCGImage:[photoItem.asset thumbnail]];
            }else{
                imageView.image = nil;
                imageView.backgroundColor = [UIColor whiteColor];
            }
            for (UIGestureRecognizer *tap in imageView.gestureRecognizers) {
                if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
                    [imageView removeGestureRecognizer:tap];
                }
            }
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target action:action]];
        }else{
            imageView.selected = NO;
            imageView.hidden = YES;
        }
    }];
}

+ (CGFloat)cellHeight{
    return [UIScreen mainScreen].bounds.size.width/4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

@end
