//
//  ViewController.m
//  AssetsPhotosDemo
//
//  Created by chengs on 15/12/5.
//  Copyright © 2015年 chengs. All rights reserved.
//

#import "ViewController.h"
#import <AssetsPhotos/AssetsPhotos.h>
@interface ViewController ()<TNCImagePickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)Click:(id)sender {
    
    TNCImagePickerViewController * imagePickerController = [[TNCImagePickerViewController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.maximumNumberOfSelection = 9;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)qb_imagePickerController:(TNCImagePickerViewController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    @autoreleasepool {
        for (ALAsset* asset in assets) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                 scale:asset.defaultRepresentation.scale
                                           orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];

            
            self.imageView.image = image;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
