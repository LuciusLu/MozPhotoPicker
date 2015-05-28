//
//  MozPhotoPickerViewController.m
//  MozPhotoPicker
//
//  Created by 陆浩志 on 15/5/28.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

#import "MozPhotoPickerViewController.h"
#import "MozPhotoPickerView.h"
#import "MozPhotoPickerCell.h"
#import "MozPhotoPickerCellItemView.h"
#import "MozPhotoPickerGroupCell.h"
#import "MozPhotoItem.h"

#define MozPickerDefaultHeight (200)
#define MozPickerHighHeight (SCNHEIGHT*0.63)

@interface MozPhotoPickerViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
    BOOL hasLoadUI;
    CGRect curRect;
    MozPhotoItem *lastSelectedAsset;
    CGFloat startY;
    BOOL isSpecialScroll;
    CGFloat specialScrollStartY;
    CGFloat specialScrollOffsetY;
    
    CGFloat defaultHeight;
    CGFloat highHeight;
}

@property(nonatomic) MozPhotoPickerView *mainView;
@property(nonatomic)ALAssetsLibrary *assetsLibrary;
@property(nonatomic)NSMutableArray *assetsGroups;
@property(nonatomic)NSMutableArray *photoItemsInGroup;
@end

@implementation MozPhotoPickerViewController

#pragma lifecirlce

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadSetting];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self loadAssetsGroups];
}

- (void)dealloc
{
    
}

#pragma init

-(void)loadSetting{
    defaultHeight = MozPickerDefaultHeight;
    highHeight = MozPickerHighHeight;
    curRect = CGRectMake(0, SCNHEIGHT - defaultHeight, SCNWIDTH, defaultHeight);
}

- (void)resetFrame{
    curRect = CGRectMake(0, SCNHEIGHT - defaultHeight, SCNWIDTH, defaultHeight);
}

-(void)loadUI{
    self.view = self.mainView;
    if (!hasLoadUI && !CGRectEqualToRect(curRect, CGRectZero)) {
        self.mainView.frame = curRect;
    }
    hasLoadUI = YES;
    
    [self.mainView.topBarView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction)]];
    [self.mainView.topBarView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGest:)]];
    [self.mainView.changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma other action

-(void)addWithParentViewController:(UIViewController *)parentVC{
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
}

-(void)addWithParentViewController:(UIViewController *)parentVC defaultHeight:(CGFloat)_defaultHeight highHeight:(CGFloat)_highHeight{
    defaultHeight = _defaultHeight;
    highHeight = _highHeight;
    
    [self resetFrame];
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
}

- (void)tapViewAction{
    if (self.isHightHeight) {
        [self setDefaultHeightWithAnimation:YES];
    }else{
        [self setHighHeightWithAnimation:YES];
    }
}

- (void)closeAction{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = curRect;
        frame.origin.y = SCNHEIGHT;
        self.mainView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

- (void)changeAction{
    self.showGroup = !self.showGroup;
    if (!self.isHightHeight) {
        [self setHighHeightWithAnimation:YES];
    }
    [self tableAnimationReload];
}

- (void)panGest:(UIPanGestureRecognizer*)pan{
    CGPoint point = [pan translationInView:pan.view];
    CGRect frame = self.mainView.frame;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startY = frame.origin.y;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        frame.origin.y = startY + point.y;
        if (frame.origin.y < SCNHEIGHT - highHeight) {
            frame.origin.y = SCNHEIGHT - highHeight;
        }else if (frame.origin.y > SCNHEIGHT - defaultHeight) {
            frame.origin.y = SCNHEIGHT - defaultHeight;
        }
        frame.size.height = SCNHEIGHT - frame.origin.y;
        self.mainView.frame = frame;
    }else{
        if (frame.origin.y > SCNHEIGHT - defaultHeight) {
            [self setDefaultHeightWithAnimation:YES];
        }else if (frame.origin.y < SCNHEIGHT - highHeight) {
            [self setHighHeightWithAnimation:YES];
        }else{
            CGFloat centerHeight = (highHeight + defaultHeight)*0.5;
            if (frame.origin.y > SCNHEIGHT - centerHeight) {
                [self setDefaultHeightWithAnimation:YES];
            }else{
                [self setHighHeightWithAnimation:YES];
            }
        }
    }
}

-(void)setShowGroup:(BOOL)showGroup{
    _showGroup = showGroup;
    self.mainView.mainTableView.separatorStyle = showGroup?UITableViewCellSeparatorStyleSingleLine:UITableViewCellSeparatorStyleNone;
}

- (void)loadAssetsGroups{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
                if (!group){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.assetsGroups count]>0) {
                            [self loadAssetsWithGroup:[self.assetsGroups objectAtIndex:0]];
                        }
                    });
                    return;
                }
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                    [self.assetsGroups insertObject:group atIndex:0];
                } else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] > ALAssetsGroupSavedPhotos) {
                    [self.assetsGroups insertObject:group atIndex:1];
                } else {
                    [self.assetsGroups addObject:group];
                }
            };
            
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
            };
            
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                                                 usingBlock:assetGroupEnumerator
                                                               failureBlock:assetGroupEnumberatorFailure];
        }
        
    });
}

- (void)loadAssetsWithGroup:(ALAssetsGroup *)group{
    NSString *title=[group valueForProperty:ALAssetsGroupPropertyName];
    self.mainView.topTitleLabel.text = [NSString stringWithFormat:@"%@ (%ld)", title, [group numberOfAssets]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.photoItemsInGroup removeAllObjects];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                MozPhotoItem *photoItem=[[MozPhotoItem alloc]initWithAsset:result];
                [self.photoItemsInGroup insertObject:photoItem atIndex:0];
            }
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self tableAnimationReload];
        });
    });
}

- (void)tableAnimationReload{
    CGRect frame = self.mainView.mainTableView.frame;
    [UIView animateWithDuration:0.15 animations:^{
        self.mainView.mainTableView.frame = CGRectMake(0, CGRectGetMaxY(frame), SCNWIDTH, CGRectGetHeight(frame));
    } completion:^(BOOL finished) {
        [self.mainView.mainTableView reloadData];
        [UIView animateWithDuration:0.15 animations:^{
            self.mainView.mainTableView.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }];
}

-(void)setDefaultHeightWithAnimation:(BOOL)animation{
    self.isHightHeight = NO;
    curRect = CGRectMake(0, SCNHEIGHT - defaultHeight, SCNWIDTH, defaultHeight);
    if (hasLoadUI) {
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                self.mainView.frame = curRect;
            } completion:^(BOOL finished) {
            }];
        }else{
            self.mainView.frame = curRect;
        }
    }
}

-(void)setHighHeightWithAnimation:(BOOL)animation{
    self.isHightHeight = YES;
    curRect = CGRectMake(0, SCNHEIGHT - highHeight, SCNWIDTH, highHeight);
    if (hasLoadUI) {
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                self.mainView.frame = curRect;
            } completion:^(BOOL finished) {
            }];
        }else{
            self.mainView.frame = curRect;
        }
    }
}

#pragma mark  - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showGroup) {
        return [self.assetsGroups count];
    }else{
        NSInteger num = ceil((float)[self.photoItemsInGroup count]/4);
        return num;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.showGroup) {
        return MIN([self.assetsGroups count], 1);
    }else{
        return MIN([self.photoItemsInGroup count], 1);
    }
}

- (NSArray *)itemsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (int i=0; i<4; i++) {
        NSInteger num = indexPath.row * 4 + i;
        if ([self.photoItemsInGroup count]>num) {
            [items addObject:[self.photoItemsInGroup objectAtIndex:num]];
        }
    }
    
    return items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showGroup) {
        static NSString *cellId=@"MozPhotoPickerGroupCell";
        ALAssetsGroup *group=nil;
        if ([self.assetsGroups count]>indexPath.row) {
            group = [self.assetsGroups objectAtIndex:indexPath.row];
        }
        MozPhotoPickerGroupCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell=[[MozPhotoPickerGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell loadGroup:group];
        return cell;
    }
    static NSString *CellIdentifier = @"AssetCell";
    MozPhotoPickerCell *cell = (MozPhotoPickerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MozPhotoPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell loadData:[self itemsForRowAtIndexPath:indexPath] target:self action:@selector(tapGest:)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showGroup) {
        return [MozPhotoPickerGroupCell cellHeight];
    }else{
        return [MozPhotoPickerCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showGroup) {
        self.showGroup = NO;
        ALAssetsGroup *group=[self.assetsGroups objectAtIndex:indexPath.row];
        [self loadAssetsWithGroup:group];
    }else{
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint location = [scrollView.panGestureRecognizer locationInView:scrollView];
    CGRect frame = self.mainView.frame;
    specialScrollStartY = frame.origin.y;
    specialScrollOffsetY = location.y - scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint location = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (specialScrollStartY != 0 && specialScrollOffsetY != 0 && specialScrollOffsetY + location.y < 0) {
        isSpecialScroll = YES;
    }
    
    if (isSpecialScroll) {
        CGRect frame = self.mainView.frame;
        if (!self.isHightHeight && frame.origin.y > SCNHEIGHT - (defaultHeight + 20)) {
            isSpecialScroll = NO;
            scrollView.scrollEnabled = NO;
            scrollView.scrollEnabled = YES;
            [self setHighHeightWithAnimation:YES];
        }else{
            CGRect frame = self.mainView.frame;
            frame.origin.y = specialScrollStartY + specialScrollOffsetY + location.y;
            if (frame.origin.y < SCNHEIGHT - highHeight) {
                frame.origin.y = SCNHEIGHT - highHeight;
            }else if (frame.origin.y > SCNHEIGHT - defaultHeight) {
                frame.origin.y = SCNHEIGHT - defaultHeight;
            }
            frame.size.height = SCNHEIGHT - frame.origin.y;
            self.mainView.frame = frame;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (isSpecialScroll) {
        CGRect frame = self.mainView.frame;
        if (frame.origin.y > SCNHEIGHT - defaultHeight) {
            [self setDefaultHeightWithAnimation:YES];
        }else if (frame.origin.y < SCNHEIGHT - highHeight) {
            [self setHighHeightWithAnimation:YES];
        }else{
            CGFloat centerHeight = (highHeight + defaultHeight)*0.5;
            if (frame.origin.y > SCNHEIGHT - centerHeight) {
                [self setDefaultHeightWithAnimation:YES];
            }else{
                [self setHighHeightWithAnimation:YES];
            }
        }
    }
    isSpecialScroll = NO;
    specialScrollStartY = 0;
    specialScrollOffsetY = 0;
}

-(void)tapGest:(UITapGestureRecognizer*)gest{
    if ([gest.view isKindOfClass:[MozPhotoPickerCellItemView class]]) {
        MozPhotoPickerCellItemView *item = (MozPhotoPickerCellItemView *)gest.view;
        if (lastSelectedAsset) {
            lastSelectedAsset.isSelected = NO;
        }
        item.photoItem.isSelected = YES;
        [self.mainView.mainTableView reloadData];
        
        if (lastSelectedAsset != item.photoItem) {
            if (self.photoPickerCallback) {
                self.photoPickerCallback(item.photoItem.asset);
            }
        }
        
        lastSelectedAsset = item.photoItem;
    }
}

#pragma property
- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [_assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    }
    return _assetsLibrary;
}

-(MozPhotoPickerView *)mainView{
    if (!_mainView) {
        _mainView=[[MozPhotoPickerView alloc]initWithFrame:self.view.bounds];
        _mainView.mainTableView.delegate = self;
        _mainView.mainTableView.dataSource = self;
    }
    return _mainView;
}

-(NSMutableArray *)photoItemsInGroup{
    if (!_photoItemsInGroup) {
        _photoItemsInGroup=[[NSMutableArray alloc]init];
    }
    return _photoItemsInGroup;
}

-(NSMutableArray *)assetsGroups{
    if (!_assetsGroups) {
        _assetsGroups=[[NSMutableArray alloc]init];
    }
    return _assetsGroups;
}


@end
