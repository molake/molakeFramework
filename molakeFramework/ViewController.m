//
//  ViewController.m
//  molakeFramework
//
//  Created by molake on 16/1/11.
//  Copyright © 2016年 molake. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -- 在string中插入图片
- (void)insertImageToString{
//    UITextView *messageTextView = [[UITextView alloc]init];
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 6;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont fontWithName:@"HiraMaruProN-W4" size:46.5/2],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    messageTextView.attributedText = [[NSAttributedString alloc] initWithString:@"かきおわったら  ボタンでチェックしよう。\nまちがえたら  ボタンでかいたもじをけすことができるよ。" attributes:attributes];
//    NSTextAttachment *checkImageAttMLKent = [NSTextAttachment new];
//    UIImage *imageCheck = ImageNamed(@"ic_check_enable_small");
//    UIImage *newImageCheck = [imageCheck imageByScalingToSize:CGSizeMake(23.25, 23.25)];
//    checkImageAttMLKent.image = newImageCheck;
//    NSTextAttachment *erarseImageAttMLKent = [NSTextAttachment new];
//    UIImage *newImageErarse = [ImageNamed(@"ic_eraser") imageByScalingToSize:CGSizeMake(23.25, 23.25)];
//    erarseImageAttMLKent.image = newImageErarse;
//    [messageTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:checkImageAttMLKent] atIndex:8];
//    [messageTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:erarseImageAttMLKent] atIndex:30];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
