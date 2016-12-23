//
//  SharedItem.h
//  RNImageWatermark
//
//  Created by 晁荣 on 16/12/22.
//  Copyright © 2016年 maichong. All rights reserved.
//
//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SharedItem : NSObject<UIActivityItemSource>

-(instancetype)initWithData:(UIImage*)img andFile:(NSURL*)file;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *path;

@end
