//
//  ViewController.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "ViewController.h"
#import "MozPhotoPickerViewController.h"

@interface ViewController ()
@property(nonatomic) UIImageView *tempImageView;
@end

@implementation ViewController

-(UIImageView *)tempImageView{
    if (!_tempImageView) {
        _tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        _tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tempImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tempImageView];
    
    __weak ViewController* weakSelf = self;
    MozPhotoPickerViewController *pickerVC = [[MozPhotoPickerViewController alloc]init];
    pickerVC.photoPickerCallback = ^(ALAsset*asset){
        __strong ViewController* strongSelf = weakSelf;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
            dispatch_async(dispatch_get_main_queue(),^{
                [strongSelf.tempImageView setImage:image];
            });
        });
    };
    [pickerVC addWithParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
