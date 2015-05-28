//
//  MozPhotoPickerView.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCNWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCNHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define LINE_HEIGHT ((float)1/[UIScreen mainScreen].scale)

@interface MozPhotoPickerView : UIView{
    CGRect _topBarViewRect;
    CGRect _topTitleLabelRect;
    CGRect _mainTableViewRect;
    CGRect _changeBtnRect;
    CGRect _closeBtnRect;
}

@property(nonatomic,readonly)UIView *topBarView;
@property(nonatomic,readonly)UILabel *topTitleLabel;
@property(nonatomic,readonly)UIButton *changeBtn;
@property(nonatomic,readonly)UIButton *closeBtn;
@property(nonatomic,readonly)UITableView *mainTableView;

- (void)loadUI;

@end
