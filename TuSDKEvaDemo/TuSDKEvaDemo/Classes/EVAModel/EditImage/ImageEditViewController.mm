//
//  ImageEditViewController.m
//  TuSDKEvaDemo
//
//  Created by tutu on 2019/6/26.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import "ImageEditViewController.h"
#import "ImageEditView.h"

@interface ImageEditViewController ()

@property (weak, nonatomic) IBOutlet UIView *editView;

/**
 editImageView
 */
@property (nonatomic, strong) ImageEditView *editImageView;

@end

@implementation ImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = @"编辑";
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [save setTitle:@"确定" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    _editImageView = [[ImageEditView alloc] initWithFrame:CGRectMake(0, 0, lsqScreenWidth, lsqScreenHeight - ([UIDevice lsqIsDeviceiPhoneX] ? 64 : 88))];
    if (!CGSizeEqualToSize(CGSizeZero, self.cutSize)) _editImageView.regionRatio = self.cutSize.width/self.cutSize.height;
    [_editView addSubview:_editImageView];
    [_editImageView setImage:_inputImage];
}


- (void)confirm {
    if (!self.editImageView || self.editImageView.inActioning) return;
    
    TuSDKResult *result = [TuSDKResult result];
    result.cutRect = [self.editImageView countImageCutRect];
    result.cutSize = self.cutSize;
    result.cutScale = self.editImageView.zoomScale;
    result.imageOrientation = self.editImageView.imageOrientation;
    [self cutWithResult:result];
}


// 异步处理图片
- (void)cutWithResult:(TuSDKResult *)result;
{
    result.image = self.inputImage;
    // 旋转图片到正确方向
    result.image = [result.image lsqChangeOrientation:result.imageOrientation];
    
    // 裁剪图片
    if (!CGSizeEqualToSize(CGSizeZero, self.cutSize)) {
        result.image = [result.image lsqImageCorpWithPrecentRect:result.cutRect outputSize:result.cutSize];
    }
    [self saveImage:result.image];
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"reult_%ld.png", _index]];  // 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image) writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    if (self.editCompleted) {
        self.editCompleted([NSURL fileURLWithPath:filePath]);
    }
}


@end
