# MozPhotoPicker
A nice photo picker

## demo
![Alt text](/MozPhotoPicker.gif)

---------------------------------------
## import 
#import "MozPhotoPickerViewController.h"

---------------------------------------
## code

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

---------------------------------------