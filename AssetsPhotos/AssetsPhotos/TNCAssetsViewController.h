//
//  TNCAssetsViewController.h
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@class TNCImagePickerViewController;
@interface TNCAssetsViewController : UIViewController
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) TNCImagePickerViewController *imagePickerController;

@end
