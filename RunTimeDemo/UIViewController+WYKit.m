
//
//  UIViewController+WYKit.m
//  RunTimeDemo
//
//  Created by yons on 17/2/3.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "UIViewController+WYKit.h"
#import <objc/runtime.h>

@implementation UIViewController (WYKit)
//Swizzling应该总是在+load中执行
//load方法会在类第一次加载的时候被调用
//调用的时间比较靠前，适合在这个方法里做方法交换
+ (void)load{
    /**
     在Objective-C中，运行时会自动调用每个类的两个方法。+load会在类初始加载时调用，+initialize会在第一次调用类的类方法或实例方法之前被调用。这两个方法是可选的，且只有在实现了它们时才会被调用。由于method swizzling会影响到类的全局状态，因此要尽量避免在并发处理中出现竞争的情况。+load能保证在类的初始化过程中被加载，并保证这种改变应用级别的行为的一致性。相比之下，+initialize在其执行时不提供这种保证–事实上，如果在应用中没为给这个类发送消息，则它可能永远不会被调用。
     
     */
    /**
     
     注意事项
     
     Swizzling通常被称作是一种黑魔法，容易产生不可预知的行为和无法预见的后果。虽然它不是最安全的，但如果遵从以下几点预防措施的话，还是比较安全的：
     
     总是调用方法的原始实现(除非有更好的理由不这么做)：API提供了一个输入与输出约定，但其内部实现是一个黑盒。Swizzle一个方法而不调用原始实现可能会打破私有状态底层操作，从而影响到程序的其它部分。
     避免冲突：给自定义的分类方法加前缀，从而使其与所依赖的代码库不会存在命名冲突。
     明白是怎么回事：简单地拷贝粘贴swizzle代码而不理解它是如何工作的，不仅危险，而且会浪费学习Objective-C运行时的机会。阅读Objective-C Runtime Reference和查看<objc/runtime.h>头文件以了解事件是如何发生的。
     小心操作：无论我们对Foundation, UIKit或其它内建框架执行Swizzle操作抱有多大信心，需要知道在下一版本中许多事可能会不一样。
     */
    
    // 返回方法的实现 IMP method_getImplementation ( Method m );
     //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得系统的方法选择器
        SEL systemSel = @selector(viewWillAppear:);
        //自己方法（将要交换的方法）的选择器
        SEL swizzSel = @selector(lwy_viewWillAppear:);
        //通过选择器获得方法
        Method systemMethod = class_getInstanceMethod(self, systemSel);
        Method swizzedMethod = class_getInstanceMethod(self, swizzSel);
        
        
        //class_getMethodImplementation函数，该函数在向类实例发送消息时会被调用，并返回一个指向方法实现函数的指针。这个函数会比method_getImplementation(class_getInstanceMethod(cls, name))更快。返回的函数指针可能是一个指向runtime内部的函数，而不一定是方法的实际实现。例如，如果类实例无法响应selector，则返回的函数指针将是运行时消息转发机制的一部分。
        IMP systemIMP = class_getMethodImplementation(self, systemSel);
        IMP swizzedIMP = class_getMethodImplementation(self, swizzSel);
        
        const char *swizzedType = method_getTypeEncoding(swizzedMethod);
        const char *systemType = method_getTypeEncoding(systemMethod);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL success = class_addMethod(self, systemSel, swizzedIMP, swizzedType);
        
        if (success) {//添加成功
            //  class_replaceMethod函数，该函数的行为可以分为两种：如果类中不存在name指定的方法，则类似于class_addMethod函数一样会添加方法；如果类中已存在name指定的方法，则类似于method_setImplementation一样替代原方法的实现。
            class_replaceMethod(self, swizzSel, systemIMP, systemType);
        }
        else {//添加失败
            method_exchangeImplementations(systemMethod, swizzedMethod);
        }
    });
}
- (void)lwy_viewWillAppear:(BOOL)animated {
    //这时候调用自己，看起来像是死循环 但是其实自己的实现已经被替换了
    [self lwy_viewWillAppear:animated];
    
    NSLog(@"自己的方法 swizzle");
}
@end
