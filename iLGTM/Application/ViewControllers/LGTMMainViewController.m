// LGTMMainViewController.m
//
// Copyright (c) 2015 Shintaro Kaneko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LGTMMainViewController.h"

@interface LGTMMainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic, nullable) IBOutlet UIImageView *imageView;
@property (nonatomic, strong, nullable) UILabel *LGTM;
@end

@implementation LGTMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LGTM = [[UILabel alloc] init];
    self.LGTM.textColor = [UIColor whiteColor];
    self.LGTM.font = [UIFont fontWithName:@"GeezaPro-Bold" size:64.0];
    self.LGTM.text = @"LGTM";
    [self.LGTM sizeToFit];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        __typeof(self) __weak weakSelf = self;
        CGRect frame = (CGRect){
            (CGPoint){
                CGRectGetMidX(weakSelf.imageView.bounds) - 0.5 * CGRectGetWidth(weakSelf.LGTM.bounds),
                CGRectGetMidY(weakSelf.imageView.bounds) - 0.5 * CGRectGetHeight(weakSelf.LGTM.bounds)
            },
            (CGSize)weakSelf.LGTM.bounds.size
        };
        weakSelf.LGTM.frame = frame;
        [weakSelf.imageView addSubview:weakSelf.LGTM];
    }];
}

- (UIImage *)LGTMImage {
    CGRect rect = self.imageView.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (IBAction)saveImage:(id)sender {
    if (self.imageView.image == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No LGTM" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIImageWriteToSavedPhotosAlbum([self LGTMImage], nil, nil, nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Saved" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)openPickerController:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

@end
