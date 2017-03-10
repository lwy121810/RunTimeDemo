//
//  RuntimeTool.h
//  RunTimeDemo
//
//  Created by yons on 17/2/4.
//  Copyright © 2017年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeTool : NSObject
/**
 获取某个类的属性名字列表
 
 @param someClass 传入的类
 @return 返回类中含有属性名字的数组
 */
+ (NSArray <NSString *> *)getPropertyNameListWithClass:(Class)someClass;
/**
 获取某个类的方法名列表
 
 @param someClass 传入的类
 @return 返回类中方法名字的数组
 */
+ (NSArray <NSString *> *)getMethodNameListWithClass:(Class)someClass;

/**
 获取某个类的成员变量名字列表
 
 @param someClass 传入的类
 @return 类中所有成员列表的名字的数组
 */
+ (NSArray <NSString *> *)getIvarNameListWithClass:(Class)someClass;
/**
 获取某个类的协议名字的列表
 
 @param someClass 传入的类
 @return 类中所有协议名的数组
 */
+ (NSArray <NSString *> *)getProtocolNameListWithClass:(Class)someClass;
@end
