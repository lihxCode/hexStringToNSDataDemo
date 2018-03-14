//
//  ViewController.m
//  NSStringToNSData
//
//  Created by FD on 2018/3/14.
//  Copyright © 2018年 FD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@"hello world"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@",data);
    NSString *str = [NSString stringWithFormat:@"%@",data];
    NSData *originalData = [self hexStringToData:str];
    NSArray *tmpArr = [NSJSONSerialization JSONObjectWithData:originalData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"log");
}

- (NSData *)hexStringToData:(NSString *)str{
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉空格
    NSString *replaceStr = [newStr substringWithRange:NSMakeRange(1, newStr.length-2)];//去掉<>
    const char * chars = [replaceStr UTF8String];//先将字符串转成UTF8格式的字符串
    NSUInteger i =0, len = replaceStr.length;//获取字符串的长度，这里的字符串串长度为处理后的字符串长度，非原始字符串长度
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];//建立存放byte的data，除以2是因为字符串需要2个转成16进制byte，所需的内存空间为字符串长度的一半
    unsigned long byte;//每次高低位获取到的byte
    char byteChars[2] = {'\0','\0'};
    while (i < len) {//没两个字符为一位转成16进制的byte数据，加到data中，最后返回
        //5b0a20202268656c6c6f20776f726c64220a5d
        byteChars[0] = chars[i++];//获取字符的第一个:5
        byteChars[1] = chars[i++];//获取字符的第二个:b
        byte = strtoul(byteChars, NULL, 16);//stroul 将参数nptr字符串根据参数base来转换成无符号的长整型数。参数1:字符串起始地址 参数2:返回字符串有效数字的结束地址，参数3:转换基数
        [data appendBytes:&byte length:1];//加到data中 lenth表示追加的字节数长度
    }
    return data;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
