//
//  TNCImagePickerViewController.h
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class TNCImagePickerViewController;
@protocol TNCImagePickerViewControllerDelegate <NSObject>

@optional
- (void)qb_imagePickerController:(TNCImagePickerViewController *)imagePickerController didSelectAssets:(NSArray *)assets;
@end


#ifdef MEMORY_TEST_FLAG
#import "ImprovedViewController.h"
@interface TNCImagePickerViewController : ImprovedViewController
#else
@interface TNCImagePickerViewController : UIViewController
#endif

@property (nonatomic, weak) id<TNCImagePickerViewControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy) NSArray *groupTypes;
@property (nonatomic, assign) BOOL  isFrist;

+ (BOOL)isAccessible;

@end
