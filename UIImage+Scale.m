//
//  UIImage+Scale.m
//  JKImitateQQ
//
//  Created by dg11185_zal on 14/12/3.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

//缩放图片、图标
-(UIImage*) scaleToSize:(CGSize)size
{
    //创建一个bitmap的context,并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    //绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return newImg;
    
}

@end
