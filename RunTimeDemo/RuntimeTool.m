//
//  RuntimeTool.m
//  RunTimeDemo
//
//  Created by yons on 17/2/4.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "RuntimeTool.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation RuntimeTool

/**
 获取某个类的属性名字列表
 
 @param someClass 传入的类
 @return 返回类中含有属性名字的数组
 */
+ (NSArray <NSString *> *)getPropertyNameListWithClass:(Class)someClass {
    /**
     2.属性操作函数，主要包含以下函数：
     // 获取指定的属性
     objc_property_t class_getProperty ( Class cls, const char *name );
     // 获取属性列表
     objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
     // 为类添加属性
     BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
     // 替换类的属性
     void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
     
     
     
     */
    
    unsigned int count;
    //获取属性列表
    //返回的是属性列表，列表中每个元素都是一个 objc_property_t 指针
    objc_property_t *propertyList = class_copyPropertyList([someClass class], &count);
    NSLog(@"属性列表长度 %d", count);
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i=0; i<count; i++) {
        
        /**
         property_getName 用来查找属性的名称，返回 c 字符串。property_getAttributes 函数挖掘属性的真实名称和encode 类型，返回 c 字符串
         
         */
        NSString *name = [self getPropertyName:propertyList[i]];
        [array addObject:name];
//        const char *propertyName = property_getName(propertyList[i]);
//        NSString *attribute = @(property_getAttributes(propertyList[i]));
//        objc_property_t pro = class_getProperty([self class], propertyName);
//        NSLog(@"属性property---->%@ attribute----> %@", [NSString stringWithUTF8String:propertyName], attribute);
//
//        NSLog(@"pro Name ---> %@",@(property_getName(pro)));
    }
    free(propertyList);
    return [array copy];
}

/**
 获取某个类的方法名列表

 @param someClass 传入的类
 @return 返回类中方法名字的数组
 */
+ (NSArray <NSString *> *)getMethodNameListWithClass:(Class)someClass {
    /**
     struct objc_method {
     SEL method_name                                          OBJC2_UNAVAILABLE;
     char *method_types                                       OBJC2_UNAVAILABLE;
     IMP method_imp                                           OBJC2_UNAVAILABLE
     }
     
     struct objc_method_list {
     struct objc_method_list *obsolete                        OBJC2_UNAVAILABLE;
     
     int method_count                                         OBJC2_UNAVAILABLE;
     #ifdef __LP64__
     int space                                                OBJC2_UNAVAILABLE;
     #endif
     
     struct objc_method method_list[1]                        OBJC2_UNAVAILABLE;
     }                                                            OBJC2_UNAVAILABLE;
     */
    
    /**
     方法操作主要有以下函数：
     // 添加方法
     BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
     // 获取实例方法
     Method class_getInstanceMethod ( Class cls, SEL name );
     // 获取类方法
     Method class_getClassMethod ( Class cls, SEL name );
     // 获取所有方法的数组
     Method * class_copyMethodList ( Class cls, unsigned int *outCount );
     // 替代方法的实现
     IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
     // 返回方法的具体实现
     IMP class_getMethodImplementation ( Class cls, SEL name );
     IMP class_getMethodImplementation_stret ( Class cls, SEL name );
     // 类实例是否响应指定的selector
     BOOL class_respondsToSelector ( Class cls, SEL sel );
     
     
     
     class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO。如果要修改已存在实现，可以使用method_setImplementation。一个Objective-C方法是一个简单的C函数，它至少包含两个参数–self和_cmd。所以，我们的实现函数(IMP参数指向的函数)至少需要两个参数，如下所示
     void testMethod(id self, SEL _cmd) 
     {
       //函数实现
     }
     与成员变量不同的是，我们可以为类动态添加方法，不管这个类是否已存在。
     另外，参数types是一个描述传递给方法的参数类型的字符数组，这就涉及到类型编码，我们将在后面介绍。
     
     class_getInstanceMethod、class_getClassMethod函数，与class_copyMethodList不同的是，这两个函数都会去搜索父类的实现。
     
     
     class_copyMethodList函数，返回包含所有实例方法的数组，如果需要获取类方法，则可以使用class_copyMethodList(object_getClass(cls), &count)(一个类的实例方法是定义在元类里面)。该列表不包含父类实现的方法。outCount参数返回方法的个数。在获取到列表后，我们需要使用free()方法来释放它
     
     class_replaceMethod函数，该函数的行为可以分为两种：如果类中不存在name指定的方法，则类似于class_addMethod函数一样会添加方法；如果类中已存在name指定的方法，则类似于method_setImplementation一样替代原方法的实现。
     
     class_getMethodImplementation函数，该函数在向类实例发送消息时会被调用，并返回一个指向方法实现函数的指针。这个函数会比method_getImplementation(class_getInstanceMethod(cls, name))更快。返回的函数指针可能是一个指向runtime内部的函数，而不一定是方法的实际实现。例如，如果类实例无法响应selector，则返回的函数指针将是运行时消息转发机制的一部分。
     
     class_respondsToSelector函数，我们通常使用NSObject类的respondsToSelector:或instancesRespondToSelector:方法来达到相同目的。
     

     */
    
    unsigned int count;
    //获取方法列表
    NSMutableArray *array = [NSMutableArray array];
    Method *methodList = class_copyMethodList([someClass class], &count);
    for (NSInteger i = 0; i< count; i++) {
        Method method = methodList[i];
        SEL metName = method_getName(method);
        NSString *name = NSStringFromSelector(metName);
        [array addObject:name];
//        const char *metType = method_getTypeEncoding(method);
//        NSString *type = [NSString stringWithUTF8String:metType];
//        NSLog(@"方法类型是 －－－ %@", type);
    }
    free(methodList);//释放
    return [array copy];
}

/**
 获取某个类的成员变量名字列表

 @param someClass 传入的类
 @return 类中所有成员列表的名字的数组
 */
+ (NSArray <NSString *>*)getIvarNameListWithClass:(Class)someClass {
    /**
     在objc_class中，所有的成员变量、属性的信息是放在链表ivars中的。ivars是一个数组，数组中每个元素是指向Ivar(变量信息)的指针。runtime提供了丰富的函数来操作这一字段。大体上可以分为以下几类：
     
     
     在objc_class中，所有的成员变量、属性的信息是放在链表ivars中的。ivars是一个数组，数组中每个元素是指向Ivar(变量信息)的指针。runtime提供了丰富的函数来操作这一字段。大体上可以分为以下几类：
     // 获取类中指定名称实例成员变量的信息
     Ivar class_getInstanceVariable ( Class cls, const char *name );
     // 获取类成员变量的信息
     Ivar class_getClassVariable ( Class cls, const char *name );
     // 添加成员变量
     BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
     // 获取整个成员变量列表
     Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );
     
     
     class_getInstanceVariable函数，它返回一个指向包含name指定的成员变量信息的objc_ivar结构体的指针(Ivar)。
     class_getClassVariable函数，目前没有找到关于Objective-C中类变量的信息，一般认为Objective-C不支持类变量。注意，返回的列表不包含父类的成员变量和属性。
     
     Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用class_addIvar函数了。不过需要注意的是，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。
     
     
     class_copyIvarList函数，它返回一个指向成员变量信息的数组，数组中每个元素是指向该成员变量信息的objc_ivar结构体的指针。这个数组不包含在父类中声明的变量。outCount指针返回数组的大小。需要注意的是，我们必须使用free()来释放这个数组。
     */
    
    
    
    /**
     struct objc_ivar {
     char *ivar_name                                          OBJC2_UNAVAILABLE;
     char *ivar_type                                          OBJC2_UNAVAILABLE;
     int ivar_offset
     }
     */
    /**
     class_copyIvarList函数，它返回一个指向成员变量信息的数组，数组中每个元素是指向该成员变量信息的objc_ivar结构体的指针。这个数组不包含在父类中声明的变量。outCount指针返回数组的大小。需要注意的是，我们必须使用free()来释放这个数组。
     */
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([someClass class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        [array addObject:name];
        
//        const char *ivarType = ivar_getTypeEncoding(ivar);
//        NSString *type = [NSString stringWithUTF8String:ivarType];
//        NSLog(@"成员变量的类型 －－－－ %@", type);
    }
    free(ivarList);//释放数组
    return [array copy];
}
#pragma mark - Protocol
/**
 获取某个类的协议名字的列表

 @param someClass 传入的类
 @return 类中所有协议名的数组
 */
+ (NSArray <NSString *> *)getProtocolNameListWithClass:(Class)someClass {
    
    /**
     // 返回指定的协议
     Protocol * objc_getProtocol ( const char *name );
     // 获取运行时所知道的所有协议的数组
     Protocol ** objc_copyProtocolList ( unsigned int *outCount );
     // 创建新的协议实例
     Protocol * objc_allocateProtocol ( const char *name );
     // 在运行时中注册新创建的协议
     void objc_registerProtocol ( Protocol *proto );
     // 为协议添加方法
     void protocol_addMethodDescription ( Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod );
     // 添加一个已注册的协议到协议中
     void protocol_addProtocol ( Protocol *proto, Protocol *addition );
     // 为协议添加属性
     void protocol_addProperty ( Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty );
     // 返回协议名
     const char * protocol_getName ( Protocol *p );
     // 测试两个协议是否相等
     BOOL protocol_isEqual ( Protocol *proto, Protocol *other );
     // 获取协议中指定条件的方法的方法描述数组
     struct objc_method_description * protocol_copyMethodDescriptionList ( Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount );
     // 获取协议中指定方法的方法描述
     struct objc_method_description protocol_getMethodDescription ( Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod );
     // 获取协议中的属性列表
     objc_property_t * protocol_copyPropertyList ( Protocol *proto, unsigned int *outCount );
     // 获取协议的指定属性
     objc_property_t protocol_getProperty ( Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty );
     // 获取协议采用的协议
     Protocol ** protocol_copyProtocolList ( Protocol *proto, unsigned int *outCount );
     // 查看协议是否采用了另一个协议
     BOOL protocol_conformsToProtocol ( Protocol *proto, Protocol *other );
     
     
     objc_getProtocol函数，需要注意的是如果仅仅是声明了一个协议，而未在任何类中实现这个协议，则该函数返回的是nil。
     objc_copyProtocolList函数，获取到的数组需要使用free来释放
     objc_allocateProtocol函数，如果同名的协议已经存在，则返回nil
     objc_registerProtocol函数，创建一个新的协议后，必须调用该函数以在运行时中注册新的协议。协议注册后便可以使用，但不能再做修改，即注册完后不能再向协议添加方法或协议
     
     需要强调的是，协议一旦注册后就不可再修改，即无法再通过调用protocol_addMethodDescription、protocol_addProtocol和protocol_addProperty往协议中添加方法等。
     */
    
    
    /**
     协议相关的操作包含以下函数：
     // 添加协议
     BOOL class_addProtocol ( Class cls, Protocol *protocol );
     // 返回类是否实现指定的协议
     BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
     // 返回类实现的协议列表
     Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
     
     class_conformsToProtocol函数可以使用NSObject类的conformsToProtocol:方法来替代。
     class_copyProtocolList函数返回的是一个数组，在使用后我们需要使用free()手动释放。
     */
    
    NSMutableArray *array = [NSMutableArray array];
    unsigned int outCount;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([someClass class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocl = protocolList[i];
        const char *proName = protocol_getName(protocl);
        NSString *name = [NSString stringWithUTF8String:proName];
        [array addObject:name];
    }
    free(protocolList);//释放
    return [array copy];
}

/**
 获取属性名字

 @param property objc_property_t
 @return 属性名字
 */
+ (NSString *)getPropertyName:(objc_property_t)property {
    const char *propertyName = property_getName(property);
    NSString *name = [NSString stringWithUTF8String:propertyName];
    return name;
}
@end
