//
//  MozPhotoPickerView.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoPickerView.h"
#import "UIColor+mozColor.h"

@implementation MozPhotoPickerView

@synthesize topBarView=_topBarView;
@synthesize topTitleLabel=_topTitleLabel;
@synthesize mainTableView=_mainTableView;
@synthesize changeBtn=_changeBtn;
@synthesize closeBtn = _closeBtn;

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSetting];
        [self loadUI];
    }
    return self;
}

-(void)loadSetting{
    self.backgroundColor = [UIColor whiteColor];
    _topBarViewRect= CGRectMake(0, 0, SCNWIDTH, 40);
    _topTitleLabelRect= CGRectMake((SCNWIDTH - 200)*0.5, 0, 200, 40);
    _changeBtnRect = CGRectMake(SCNWIDTH - 60, 0, 60, 40);
    _closeBtnRect = CGRectMake(0, 0, 60, 40);
    _mainTableViewRect= CGRectMake(0, 40, SCNWIDTH, SCNHEIGHT - 40);
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.mainTableView.frame = CGRectMake(0, 40, SCNWIDTH, CGRectGetHeight(frame) - 40);
}

-(void)loadUI{
    [self addSubview:self.topBarView];
    [self.topBarView addSubview:self.topTitleLabel];
    [self.topBarView addSubview:self.closeBtn];
    [self.topBarView addSubview:self.changeBtn];
    [self addSubview:self.mainTableView];
}

#pragma mark - 属性定义

-(UIView *)topBarView{
    if (!_topBarView) {
        _topBarView=[[UIView alloc]initWithFrame:_topBarViewRect];
        _topBarView.backgroundColor = [UIColor colorWithHex:0xecf0f1];
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCNWIDTH, LINE_HEIGHT)];
        topLine.backgroundColor = [UIColor colorWithHex:0xbdc3c7];
        [_topBarView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topBarViewRect) - LINE_HEIGHT, SCNWIDTH, LINE_HEIGHT)];
        bottomLine.backgroundColor = [UIColor colorWithHex:0xbdc3c7];
        [_topBarView addSubview:bottomLine];
    }
    return _topBarView;
}

-(UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel=[[UILabel alloc]initWithFrame:_topTitleLabelRect];
        _topTitleLabel.textColor = [UIColor colorWithHex:0x2c3e50];
        _topTitleLabel.text = @"相机胶卷";
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
        _topTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _topTitleLabel;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeBtn.frame = _closeBtnRect;
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeBtn.frame = _changeBtnRect;
        [_changeBtn setTitle:@"切换" forState:UIControlStateNormal];
    }
    return _changeBtn;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc]initWithFrame:_mainTableViewRect style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    return _mainTableView;
}

#pragma mark - 其他方法

@end
