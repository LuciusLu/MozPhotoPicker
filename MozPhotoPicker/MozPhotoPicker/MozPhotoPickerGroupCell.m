//
//  MozPhotoPickerGroupCell.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoPickerGroupCell.h"
#import "UIColor+mozColor.h"
#import "MozPhotoPickerView.h"

@implementation MozPhotoPickerGroupCell
{
    CGRect _titleLabelRect;
    CGRect _groupThumbnailImageViewRect;
    CGRect _imageCountLabelRect;
}

@synthesize titleLabel=_titleLabel;
@synthesize groupThumbnailImageView=_groupThumbnailImageView;
@synthesize imageCountLabel=_imageCountLabel;

#pragma mark - 初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSetting];
        [self loadUI];
    }
    return self;
}

-(void)loadSetting{
    _groupThumbnailImageViewRect= CGRectMake(10, 10, 50, 50);
    _titleLabelRect= CGRectMake(70, 0, SCNWIDTH-20, [MozPhotoPickerGroupCell cellHeight]);
    _imageCountLabelRect= CGRectMake(0, 0, 40, [MozPhotoPickerGroupCell cellHeight]);
}

-(void)loadUI{
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    [self addSubview:self.titleLabel];
    [self addSubview:self.groupThumbnailImageView];
    [self addSubview:self.imageCountLabel];
}

#pragma mark - 属性定义

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]initWithFrame:_titleLabelRect];
        [_titleLabel setTextColor:[UIColor colorWithHex:0x2c3e50]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

-(UIImageView *)groupThumbnailImageView{
    if (!_groupThumbnailImageView) {
        _groupThumbnailImageView=[[UIImageView alloc]initWithFrame:_groupThumbnailImageViewRect];
    }
    return _groupThumbnailImageView;
}

-(UILabel *)imageCountLabel{
    if (!_imageCountLabel) {
        _imageCountLabel=[[UILabel alloc]initWithFrame:_imageCountLabelRect];
        [_imageCountLabel setTextColor:[UIColor colorWithHex:0x7f8c8d]];
        [_imageCountLabel setFont:[UIFont systemFontOfSize:12]];
        [_imageCountLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _imageCountLabel;
}

#pragma mark - 其他方法
+(CGFloat)cellHeight{
    return 70;
}

-(void)loadGroup:(ALAssetsGroup *)group{
    NSString *title=[group valueForProperty:ALAssetsGroupPropertyName];
    self.titleLabel.text=title;
    self.imageCountLabel.text=[NSString stringWithFormat:@"(%ld)",(long)[group numberOfAssets]];
    self.groupThumbnailImageView.image=[UIImage imageWithCGImage:group.posterImage];
    [self.titleLabel sizeToFit];
    
    _titleLabelRect.size.width = self.titleLabel.frame.size.width;
    self.titleLabel.frame = _titleLabelRect;
    
    _imageCountLabelRect.origin.x = CGRectGetMaxX(_titleLabelRect) + 6;
    self.imageCountLabel.frame = _imageCountLabelRect;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

@end
