//
//  MozPhotoPickerViewController.h
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PhotoPickerCallback)(ALAsset*asset);

@interface MozPhotoPickerViewController : UIViewController

@property(nonatomic, assign)BOOL showGroup;
@property(nonatomic, assign)BOOL isHightHeight;
@property(nonatomic, copy)PhotoPickerCallback photoPickerCallback;

-(void)setDefaultHeightWithAnimation:(BOOL)animation;
-(void)setHighHeightWithAnimation:(BOOL)animation;

- (void)addWithParentViewController:(UIViewController*)parentVC;
- (void)addWithParentViewController:(UIViewController *)parentVC defaultHeight:(CGFloat)_defaultHeight highHeight:(CGFloat)_highHeight;

@end
