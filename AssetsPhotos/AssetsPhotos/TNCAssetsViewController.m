//
//  TNCAssetsViewController.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define CELL_W  (SCREEN_W-10)/4

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "TNCAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TNCAssetCollectionViewCell.h"
#import "TNCImagePickerViewController.h"
//#import "MBProgressHUD.h"
//#import "TNAChatMessageUtils.h"
//#import "TNASetBarButtonItem.h"
@interface TNCAssetsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedAssetURLs;
@property (nonatomic, strong) UINavigationItem * rightItem;
//@property (nonatomic, strong) UIColor * rightItemColor;


@end

@implementation TNCAssetsViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.selectedAssetURLs = [NSMutableSet set];
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";

    [self.view addSubview:self.collectionView];
    
    [self setUpToolbarItems];
    if (!_assetsGroup) {
        __weak typeof(self) weakSelf = self;
        [self.imagePickerController.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                                                usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                                                    NSUInteger numberOfAssets = MIN(3, [assetsGroup numberOfAssets]);
                                                                    NSLog(@"--%lu",(unsigned long)numberOfAssets);
                                                                    if (assetsGroup) {
                                                                        
                                                                        [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                                                                        
                                                                        NSMutableArray *assets = [NSMutableArray array];
                                                                        
                                                                        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                            
                                                                            if (result) {
                                                                                
                                                                                [assets addObject:result];
                                                                            }
                                                                        }];
                                                                        
                                                                        weakSelf.assets = assets;
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            [weakSelf.collectionView reloadData];

                                                                            if (weakSelf.assets.count > 0) {
                                                                                
                                                                                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:weakSelf.assets.count-1 inSection:0];
                                                                                
                                                                                [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                                                                                
                                                                            }else{
                                                                                
                                                                                [weakSelf authorizationStatusALAssetsLibrary];
                                                                            }
                                                                            
                                                                        });
                                                                    }

                                                                } failureBlock:^(NSError *error) {
                                                                    NSLog(@"Error: %@", [error localizedDescription]);
                                                                }];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.assets.count-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }

 }
- (void)authorizationStatusALAssetsLibrary
{
    //    若要启用手机通讯录，请先进入手机的“设置--隐私--通讯录”开启授权。
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-40, 60)];
    label.text = @"无照片,拍照与朋友分享吧!";
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
}
- (void)setUpToolbarItems
{
//
    UIBarButtonItem *cannelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cannel:)];
    [self.navigationItem setRightBarButtonItem:cannelButton animated:NO];

    _rightItem = [self navigationItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    _rightItem.rightBarButtonItem = rightItem;
    
    NSDictionary *attributesDis = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [self.rightItem.rightBarButtonItem setEnabled:NO];
    [self.rightItem.rightBarButtonItem setTitleTextAttributes:attributesDis forState:UIControlStateNormal];

}

- (void)cannel:(id)sender
{
    if (self.assets.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)done:(id)sender
{
    
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectAssets:)]) {
        [self fetchAssetsFromSelectedAssetURLsWithCompletion:^(NSArray *assets) {
            [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController didSelectAssets:assets];
        }];
    }
}

- (void)fetchAssetsFromSelectedAssetURLsWithCompletion:(void (^)(NSArray *assets))completion
{
    ALAssetsLibrary *assetsLibrary = self.imagePickerController.assetsLibrary;
    NSMutableOrderedSet *selectedAssetURLs = self.selectedAssetURLs;
    
    __block NSMutableArray *assets = [NSMutableArray array];
    
    void (^checkNumberOfAssets)(void) = ^{
        if (assets.count == selectedAssetURLs.count) {
            if (completion) {
                completion([assets copy]);
            }
        }
    };
    
    for (ALAsset *asset in selectedAssetURLs) {
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [assetsLibrary assetForURL:assetURL
                       resultBlock:^(ALAsset *asset) {
           
                           if (asset) {
                               
                               [assets addObject:asset];
                               
                               checkNumberOfAssets();
                           }else{
                               [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                   [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                       if ([result.defaultRepresentation.url isEqual:assetURL]) {
                                           [assets addObject:result];
                                           
                                           checkNumberOfAssets();
                                           
                                           *stop = YES;
                                       }
                                   }];
                               } failureBlock:^(NSError *error) {
                                   NSLog(@"Error: %@", [error localizedDescription]);
                               }];
                           }
                           
                           
                       } failureBlock:^(NSError *error) {
                           NSLog(@"Error: %@", [error localizedDescription]);
                       }];
    }
}


- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    NSMutableArray *assets = [NSMutableArray array];
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
             [assets addObject:result];
        }
    }];
    self.assets = assets;
    [self.collectionView reloadData];

}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(CELL_W, CELL_W);//cell的大小
        layout.minimumLineSpacing = 2;//每行的间距
        layout.minimumInteritemSpacing = 2;//每行cell内部的间距
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.view.bounds.size.height-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[TNCAssetCollectionViewCell class] forCellWithReuseIdentifier:@"TNCAssetCollectionViewCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TNCAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TNCAssetCollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    ALAsset *asset = self.assets[indexPath.item];
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    cell.imageView.image = image;
    
    if ([self.selectedAssetURLs containsObject:asset]){
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self validateMaximumNumberOfSelections:(self.selectedAssetURLs.count + 1)]) {
        return YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你最多只能选择%lu张图片",(unsigned long)self.imagePickerController.maximumNumberOfSelection] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    [alert show];
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
    [self.selectedAssetURLs addObject:asset];
    
    self.rightItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.selectedAssetURLs.count)];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
    [self.selectedAssetURLs removeObject:asset];
    
    self.rightItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.selectedAssetURLs.count)];
    
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, 1);
    
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        return (numberOfSelections <= self.imagePickerController.maximumNumberOfSelection);
    }
    
    return YES;
}

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, 1);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.imagePickerController.maximumNumberOfSelection);
    }
    //设置导航原有的颜色
    if (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection) {
        NSDictionary *attributesDis = @{NSForegroundColorAttributeName:UIColorFromRGB(0x007aff)};
        [self.rightItem.rightBarButtonItem setTitleTextAttributes:attributesDis forState:UIControlStateNormal];

    }else{
        NSDictionary *attributesDis = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [self.rightItem.rightBarButtonItem setTitleTextAttributes:attributesDis forState:UIControlStateNormal];
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }


@end
