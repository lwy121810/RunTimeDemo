//
//  ViewController.m
//  RunTimeDemo
//
//  Created by yons on 17/2/3.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
//#import "UIViewController+WYKit.h"
#import "RuntimeTool.h"

@protocol WYDelete  <NSObject>
@optional
- (void)testProtocol;

@end
@interface ViewController ()<WYDelete>
{
    NSObject *obj1;
    NSObject *obj2;
    
    NSObject *obj3;

}
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIButton *targetButton;

@property (nonatomic , copy) NSString *propertyName;
@property (nonatomic , assign) id<WYDelete>delete;
@end


@implementation ViewController

@dynamic propertyName;

static  NSString const *key1 = @"name";
static  NSString * const key = @"name";
- (void)targetAction {
    
}
- (void)firstAction {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     *
     
     `objc_object`是表示一个类的实例的结构体，它的定义如下(`objc/objc.h`)：
     struct objc_object {
     Class isa  OBJC_ISA_AVAILABILITY;
     };可以看到，这个结构体只有一个字体，即指向其类的isa指针
     当我们向一个oc对象发送消息时 runtime会根据这个实例对象的isa指针找到对象对应的类 然后runtime会在该类和其父类的方法列表中查找与消息对应的selector指向的方法 找到后即执行
     
     
     
     
     SEL:它是selector在 Objc 中的表示(Swift 中是 Selector 类)。selector 是方法选择器，其实作用就和名字一样，日常生活中，我们通过人名辨别谁是谁，注意 Objc 在相同的类中不会有命名相同的两个方法。selector 对方法名进行包装，以便找到对应的方法实现。
     id 是一个参数类型，它是指向某个类的实例的指针
     Class 其实是指向 objc_class 结构体的指针 从 objc_class 可以看到，一个运行时类中关联了它的父类指针、类名、成员变量、方法、缓存以及附属的协议。
     
     其中 objc_ivar_list 和 objc_method_list 分别是成员变量列表和方法列表
     objc_ivar_list 结构体用来存储成员变量的列表，而 objc_ivar 则是存储了单个成员变量的信息；同理，objc_method_list 结构体存储着方法数组的列表，而单个方法的信息则由 objc_method 结构体存储。
     
     值得注意的时，objc_class 中也有一个 isa 指针，这说明 Objc 类本身也是一个对象。为了处理类和对象的关系，Runtime 库创建了一种叫做 Meta Class(元类) 的东西，类对象所属的类就叫做元类。Meta Class 表述了类对象本身所具备的元数据。
     
     我们所熟悉的类方法，就源自于 Meta Class。我们可以理解为类方法就是类对象的实例方法。每个类仅有一个类对象，而每个类对象仅有一个与之相关的元类
     Method 代表类中某个方法的类型 objc_method 存储了方法名，方法类型和方法实现：
     
     方法名类型为 SEL
     方法类型 method_types 是个 char 指针，存储方法的参数类型和返回值类型
     method_imp 指向了方法的实现，本质是一个函数指针
     Ivar 是表示成员变量的类型
     IMP typedef id (*IMP)(id, SEL, ...); 它就是一个函数指针，这是由编译器生成的。当你发起一个 ObjC 消息之后，最终它会执行的那段代码，就是由这个函数指针指定的。而 IMP 这个函数指针就指向了这个方法的实现。
     
     在消息的传递中，编译器会根据情况在 objc_msgSend ， objc_msgSend_stret ， objc_msgSendSuper ， objc_msgSendSuper_stret 这四个方法中选择一个调用。如果消息是传递给父类，那么会调用名字带有 Super 的函数，如果消息返回值是数据结构而不是简单值时，会调用名字带有 stret 的函数。
     
     
     
     获取方法地址 
     NSObject 类中有一个实例方法：methodForSelector，你可以用它来获取某个方法选择器对应的 IMP
     methodForSelector:方法是由 Runtime 系统提供的，而不是 Objc 自身的特性
     
     动态方法解析
     你可以动态提供一个方法实现。如果我们使用关键字 @dynamic 在类的实现文件中修饰一个属性，表明我们会为这个属性动态提供存取方法，编译器不会再默认为我们生成这个属性的 setter 和 getter 方法了，需要我们自己提供。
     这时，我们可以通过分别重载 resolveInstanceMethod: 和 resolveClassMethod: 方法添加实例方法实现和类方法实现。
     
     
   当 Runtime 系统在 Cache 和类的方法列表(包括父类)中找不到要执行的方法时，Runtime 会调用 resolveInstanceMethod: 或 resolveClassMethod: 来给我们一次动态添加方法实现的机会。我们需要用 class_addMethod 函数完成向特定类添加特定方法实现的操作：
     
     */
    //    //首先定义一个全局变量，用它的地址作为关联对象的key
//    static char associatedObjectKey;
//    
//    //设置关联对象
//    objc_setAssociatedObject(self, &associatedObjectKey, @"添加的字符串属性", OBJC_ASSOCIATION_RETAIN_NONATOMIC); //获取关联对象
//    
//    
//    NSString *string = objc_getAssociatedObject(self, &associatedObjectKey);
//    NSLog(@"关联对象 AssociatedObject = %@", string);
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    button.frame = CGRectMake(50, 100, 100, 100);
//
//    [button addTarget:self action:@selector(resolveThisMethodDynamically) forControlEvents:UIControlEventTouchUpInside];
//    
//    button.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:button];
    
    
//    NSArray *names = [RuntimeTool getPropertyNameListWithClass:[self class]];
//    for (NSString *name in names) {
//        NSLog(@"属性名字是 －－－  %@", name);
//    }
//    NSArray *methods = [RuntimeTool getMethodNameListWithClass:[self class]];
//    for (NSString *name in methods) {
//        
//        NSLog(@"方法名字是 －－－  %@", name);
//    }
//    NSArray *ivars = [RuntimeTool getIvarNameListWithClass:[self class]];
//    for (NSString *name in ivars) {
//        
//        NSLog(@"成员变量的名字是 －－－  %@", name);
//    }
//    
//    
//    NSArray *protocols = [RuntimeTool getProtocolNameListWithClass:[self class]];
//    for (NSString *name in protocols) {
//        
//        NSLog(@"protocol的名字是 －－－  %@", name);
//    }
    
//    [self respondsToSelector:@selector(tapAction)];
    
    /**
     Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用class_addIvar函数了。不过需要注意的是，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。
     
     */
    
//    const char *className = class_getName([self class]);
//    NSString *name = [NSString stringWithUTF8String:className];
//    NSLog(@"类名 －－－－－－－－  %@", name);
    
    
    /**
     meta-class之所以重要，是因为它存储着一个类的所有类方法。每个类都会有一个单独的meta-class，因为每个类的类方法基本不可能完全相同。
     
     */
    
    //实例变量大小
//    size_t size = class_getInstanceSize([self class]);
//    NSLog(@"size---------%zu", size);
    
    [self createClass];
    
}
/**动态的创建类*/
- (void)createClass {
    /**
     // 创建一个新类和元类
     Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
     // 销毁一个类及其相关联的类
     void objc_disposeClassPair ( Class cls );
     // 在应用中注册由objc_allocateClassPair创建的类
     void objc_registerClassPair ( Class cls );
     
     runtime的强大之处在于它能在运行时创建类和对象。
     
     
     objc_allocateClassPair函数：如果我们要创建一个根类，则superclass指定为Nil。extraBytes通常指定为0，该参数是分配给类和元类对象尾部的索引ivars的字节数。
     
     为了创建一个新类，我们需要调用objc_allocateClassPair。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中
     
     实例方法和实例变量应该添加到类自身上，而类方法应该添加到类的元类上。
     
     objc_disposeClassPair函数用于销毁一个类，不过需要注意的是，如果程序运行中还存在类或其子类的实例，则不能调用针对类调用该方法。
     
       Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用class_addIvar函数了。不过需要注意的是，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。
     */
    
    Class MyViewClass = objc_allocateClassPair([UIView class], "myClass", 0);
    class_addIvar(MyViewClass, "button1", sizeof(UIButton *), log(sizeof(UIButton *)), "i");
    
    class_addMethod(MyViewClass, @selector(subMethod1), (IMP)imp_subMethod1, "v@:");
    class_replaceMethod(MyViewClass, @selector(method1), (IMP)imp_subMethod1, "v@:");
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backingivar = {"V","_ivar1"};
    
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(MyViewClass, "property2", attrs, 3);
    
    
    
    objc_registerClassPair(MyViewClass);
    
    //创建实例
    id myView = [[MyViewClass alloc] init];
    [myView performSelector:@selector(subMethod1)];
    
//    [myView performSelector:@selector(method1)];
    [self associatedObject];
}

void imp_subMethod1(id self, SEL _cmd) {
    NSLog(@"动态创建的类%@ 的方法1 imp_subMethod1 ", [self class]);
    NSArray *names = [RuntimeTool getPropertyNameListWithClass:[self class]];
    for (NSString *name in names) {
        NSLog(@"属性名字是 －－－  %@", name);
    }
    NSArray *methods = [RuntimeTool getMethodNameListWithClass:[self class]];
    for (NSString *name in methods) {
        
        NSLog(@"方法名字是 －－－  %@", name);
    }
    NSArray *ivars = [RuntimeTool getIvarNameListWithClass:[self class]];
    for (NSString *name in ivars) {
        
        NSLog(@"成员变量的名字是 －－－  %@", name);
    }
}
//成员变量、属性的操作方法
- (void)ivarAndPropertyOperation {
    //成员变量操作包含以下函数：
    /**
     // 获取成员变量名
     const char * ivar_getName ( Ivar v );
     // 获取成员变量类型编码
     const char * ivar_getTypeEncoding ( Ivar v );
     // 获取成员变量的偏移量
     ptrdiff_t ivar_getOffset ( Ivar v );
     
     
     ivar_getOffset函数，对于类型id或其它对象类型的实例变量，可以调用object_getIvar和object_setIvar来直接访问成员变量，而不使用偏移量。
     */
    
    //关联对象操作函数包括以下：
    /**
     // 设置关联对象
     void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
     // 获取关联对象
     id objc_getAssociatedObject ( id object, const void *key );
     // 移除关联对象
     void objc_removeAssociatedObjects ( id object );
     */
    
    //属性操作相关函数包括以下：
    /**
     // 获取属性名
     const char * property_getName ( objc_property_t property );
     // 获取属性特性描述字符串
     const char * property_getAttributes ( objc_property_t property );
     // 获取属性中指定的特性
     char * property_copyAttributeValue ( objc_property_t property, const char *attributeName );
     // 获取属性的特性列表
     objc_property_attribute_t * property_copyAttributeList ( objc_property_t property, unsigned int *outCount );
     
     property_copyAttributeValue函数，返回的char *在使用完后需要调用free()释放。
     property_copyAttributeList函数，返回值在使用完后需要调用free()释放
     */
    
    //IMP实际上是一个函数指针，指向方法实现的首地址
    /**
     每个方法对应唯一的SEL，因此我们可以通过SEL方便快速准确地获得它所对应的IMP，查找过程将在下面讨论。取得IMP后，我们就获得了执行这个方法代码的入口点，此时，我们就可以像调用普通的C语言函数一样来使用这个函数指针了。
     
     通过取得IMP，我们可以跳过Runtime的消息传递机制，直接执行IMP指向的函数实现，这样省去了Runtime消息传递过程中所做的一系列查找操作，会比直接向对象发送消息高效一些。
     */
    
    //Method
    /**
     typedef struct objc_method *Method;
     struct objc_method {
     SEL method_name                	OBJC2_UNAVAILABLE;	// 方法名
     char *method_types                	OBJC2_UNAVAILABLE;
     IMP method_imp             			OBJC2_UNAVAILABLE;	// 方法实现
     }
     我们可以看到该结构体中包含一个SEL和IMP，实际上相当于在SEL和IMP之间作了一个映射。有了SEL，我们便可以找到对应的IMP，从而调用方法的实现代码。
     
     方法操作相关函数包括下以：
  
     // 调用指定方法的实现
     id method_invoke ( id receiver, Method m, ... );
     // 调用返回一个数据结构的方法的实现
     void method_invoke_stret ( id receiver, Method m, ... );
     // 获取方法名
     SEL method_getName ( Method m );
     // 返回方法的实现
     IMP method_getImplementation ( Method m );
     // 获取描述方法参数和返回值类型的字符串
     const char * method_getTypeEncoding ( Method m );
     // 获取方法的返回值类型的字符串
     char * method_copyReturnType ( Method m );
     // 获取方法的指定位置参数的类型字符串
     char * method_copyArgumentType ( Method m, unsigned int index );
     // 通过引用返回方法的返回值类型字符串
     void method_getReturnType ( Method m, char *dst, size_t dst_len );
     // 返回方法的参数的个数
     unsigned int method_getNumberOfArguments ( Method m );
     // 通过引用返回方法指定位置参数的类型字符串
     void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
     // 返回指定方法的方法描述结构体
     struct objc_method_description * method_getDescription ( Method m );
     // 设置方法的实现
     IMP method_setImplementation ( Method m, IMP imp );
     // 交换两个方法的实现
     void method_exchangeImplementations ( Method m1, Method m2 );
     
     
     method_invoke函数，返回的是实际实现的返回值。参数receiver不能为空。这个方法的效率会比method_getImplementation和method_getName更快。
     method_getName函数，返回的是一个SEL。如果想获取方法名的C字符串，可以使用sel_getName(method_getName(method))。
     method_getReturnType函数，类型字符串会被拷贝到dst中。
     method_setImplementation函数，注意该函数返回值是方法之前的实现。
     
     */
    
    //方法选择器
    /**
     选择器相关的操作函数包括：
     
     // 返回给定选择器指定的方法的名称
     const char * sel_getName ( SEL sel );
     // 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
     SEL sel_registerName ( const char *str );
     // 在Objective-C Runtime系统中注册一个方法
     SEL sel_getUid ( const char *str );
     // 比较两个选择器
     BOOL sel_isEqual ( SEL lhs, SEL rhs );
     
     sel_registerName函数：在我们将一个方法添加到类定义时，我们必须在Objective-C Runtime系统中注册一个方法名以获取方法的选择器
     */
    
    //方法调用流程
    /**
     在Objective-C中，消息直到运行时才绑定到方法实现上。编译器会将消息表达式[receiver message]转化为一个消息函数的调用，即objc_msgSend
     这个函数完成了动态绑定的所有事情：
     
     首先它找到selector对应的方法实现。因为同一个方法可能在不同的类中有不同的实现，所以我们需要依赖于接收者的类来找到的确切的实现。
     它调用方法实现，并将接收者对象及方法的所有参数传给它。
     最后，它将实现返回的值作为它自己的返回值。
     
     objc_msgSend有两个隐藏参数：
     
     消息接收对象
     方法的selector
     这两个参数为方法的实现提供了调用者的信息。之所以说是隐藏的，是因为它们在定义方法的源代码中没有声明。它们是在编译期被插入实现代码的。
     
     虽然这些参数没有显示声明，但在代码中仍然可以引用它们。我们可以使用self来引用接收者对象，使用_cmd来引用选择器。
     
     
     
     
     */
    
}
#pragma mark - 消息转发
- (void)forwardMessage {
    /**
     当一个对象无法接收某一消息时，就会启动所谓”消息转发(message forwarding)“机制，通过这一机制，我们可以告诉对象如何处理未知的消息。默认情况下，对象接收到未知的消息，会导致程序崩溃，
     
     
     消息转发机制基本上分为三个步骤：
     
     1.动态方法解析
     2.备用接收者
     3.完整转发
     
     */
}
void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"dynamicMethodIMP--------");
    // implementation ....
}
#pragma mark - 动态方法解析
/**
 当runtime系统在cache和类的方法列表（包括父类）找不到该方法时 runtime会调用resloveClassMethod:/ resolveInstanceMethod:方法给我们一次动态添加类方法／实例方法实现的机会 我们需要用class_addMethod方法动态的为特定类添加特定的方法
 注意：
 动态方法解析会在消息转发机制之前执行 动态方法解析器会首先给予提供该方法选择器的IMP机会 如果想让该方法选择器传递给消息转发机制 应该让resolveInstanceMethod：返回NO
 
 */

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    /**
     对象在接收到未知的消息时，首先会调用所属类的类方法+resolveInstanceMethod:(实例方法)或者+resolveClassMethod:(类方法)。在这个方法中，我们有机会为该未知消息新增一个”处理方法””。不过使用该方法的前提是我们已经实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。
     */
    
    //    if (aSEL == @selector(resolveThisMethodDynamically)) {
    //        class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
    //
    //        NSLog(@"动态方法解析 resolveInstanceMethod --- YES");
    //
    //        return NO;
    //    }else if (aSEL == @selector(tapAction)) {
    //        class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
    //        return NO;
    //    }
    //    NSLog(@"动态方法解析 resolveInstanceMethod --- super");
    return YES;
    //    return [super resolveInstanceMethod:aSEL];
}



+ (BOOL)resolveClassMethod:(SEL)sel {
    //    NSLog(@"动态方法解析 resolveClassMethod --- super");
    return NO;
}

/**重定向
 在消息转发机制执行前 我们可以通过该方法替换消息的接收对象为其他对象 返回nil／self 会进入消息转发机制(forwardInvocation:) 否则将会向返回的对象重新发送消息
 
 @param aSelector 方法选择器
 @return 返回消息接收对象
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    //    if(aSelector == @selector(resolveThisMethodDynamically:)){
    //        return nil;
    //    }
    return nil;
    //    return [super forwardingTargetForSelector:aSelector];
}
//如果想替换类方法的接受者，需要覆写该方法 并返回类对象
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if(aSelector == @selector(xxx)) {
        //        return NSClassFromString(@"Class name");
    }
    return [super forwardingTargetForSelector:aSelector];
}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if (aSelector == @selector(tapAction)) {
//        NSLog(@"methodSignatureForSelector tapAction ------- ");
//        NSMethodSignature *method = [NSMethodSignature  instanceMethodSignatureForSelector:aSelector];
//        return method;
//    }
//    return [super methodSignatureForSelector:aSelector];
//}
/**
 消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
 */
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
//    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
//    if (!signature) {
//        signature = [NSMethodSignature methodSignatureForSelector:selector];
//    }
    
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        if ([ViewController instancesRespondToSelector:selector]) {
            signature = [ViewController instanceMethodSignatureForSelector:selector];
        }
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    /**
     运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation方法中选择将消息转发给其它对象。
     
     forwardInvocation:方法的实现有两个任务：
     
     定位可以响应封装在anInvocation中的消息的对象。这个对象不需要能处理所有未知消息。
     使用anInvocation作为参数，将消息发送到选中的对象。anInvocation将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。
     
     */
    NSLog(@"消息转发机制 forwardInvocation");
    if ([self respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:anInvocation];
    }
    
}


- (void)selOperation {
    //SEL又叫选择器，是表示一个方法的selector的指针，
    /**
     两个类之间，不管它们是父类与子类的关系，还是之间没有这种关系，只要方法名相同，那么方法的SEL就是一样的。每一个方法都对应着一个SEL。所以在Objective-C同一个类(及类的继承体系)中，不能存在2个同名的方法，即使参数类型不同也不行。相同的方法只能对应一个SEL。这也就导致Objective-C在处理相同方法名且参数个数相同但类型不同的方法方面的能力很差。
     
     */
}

#pragma mark - 关联对象
- (void)associatedObject {
    /**
     我们可以把关联对象想象成一个Objective-C对象(如字典)，这个对象通过给定的key连接到类的一个实例上。不过由于使用的是C接口，所以key是一个void指针(const void *)。我们还需要指定一个内存管理策略，以告诉Runtime如何管理这个对象的内存。这个内存管理的策略可以由以下值指定：
     OBJC_ASSOCIATION_ASSIGN
     OBJC_ASSOCIATION_RETAIN_NONATOMIC
     OBJC_ASSOCIATION_COPY_NONATOMIC
     OBJC_ASSOCIATION_RETAIN
     OBJC_ASSOCIATION_COPY
     当宿主对象被释放时，会根据指定的内存管理策略来处理关联对象。如果指定的策略是assign，则宿主释放时，关联对象不会被释放；而如果指定的是retain或者是copy，则宿主释放时，关联对象会被释放。我们甚至可以选择是否是自动retain/copy。当我们需要在多个线程中处理访问关联对象的多线程代码时，这就非常有用了。
     
     我们将一个对象连接到其它对象所需要做的就是下面两行代码
     static char myKey;
     objc_setAssociatedObject(self, &myKey, anObject, OBJC_ASSOCIATION_RETAIN);

     在这种情况下，self对象将获取一个新的关联的对象anObject，且内存管理策略是自动retain关联对象，当self对象释放时，会自动release关联对象。另外，如果我们使用同一个key来关联另外一个对象时，也会自动释放之前关联的对象，这种情况下，先前的关联对象会被妥善地处理掉，并且新的对象会使用它的内存。
     
     我们可以使用objc_removeAssociatedObjects函数来移除一个关联对象，或者使用objc_setAssociatedObject函数将key指定的关联对象设置为nil。
     
     */
    
//    [self setTapActionWithBlock:^{
//        NSLog(@"手势事件－－－－－");
//    }];
    
    [self addGestureBlock:^(NSString *title) {
        NSLog(@"-----------    %@", title);
    }];
}
#define kTapKey "kTapKey"
#define kBlockKey "kBlock"
- (void)addGestureBlock:(void (^) (NSString *title))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kTapKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.view addGestureRecognizer:gesture];
        //retain 策略 在self 对象释放时 会自动release关联对象
        objc_setAssociatedObject(self, &kTapKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void (^action)(NSString *) = objc_getAssociatedObject(self, &kBlockKey);
        if (action) {
            action(@"123456798");
        }
        
    }
}

#pragma mark - 获取类定义
- (void)getClassInfo {
    /**
     获取类定义
     
     Objective-C动态运行库会自动注册我们代码中定义的所有的类。我们也可以在运行时创建类定义并使用objc_addClass函数来注册它们。runtime提供了一系列函数来获取类定义相关的信息，这些函数主要包括
     // 获取已注册的类定义的列表
     int objc_getClassList ( Class *buffer, int bufferCount );
     // 创建并返回一个指向所有已注册类的指针列表
     Class * objc_copyClassList ( unsigned int *outCount );
     // 返回指定类的类定义
     Class objc_lookUpClass ( const char *name );
     Class objc_getClass ( const char *name );
     Class objc_getRequiredClass ( const char *name );
     // 返回指定类的元类
     Class objc_getMetaClass ( const char *name );
     
     objc_getClassList函数：获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。
     */
    
    int numClasses;
    Class * classes = NULL;
    
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
//        classes = malloc(sizeof(Class) * numClasses);

        numClasses = objc_getClassList(classes, numClasses);
        NSLog(@"number of classes: %d", numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class cls = classes[i];
            NSLog(@"class name: %s", class_getName(cls));
        }
        free(classes);
    }
}

#pragma mark - 实例操作函数
- (void)instanceOperation {
    /**
     实例操作函数主要是针对我们创建的实例对象的一系列操作函数，我们可以使用这组函数来从实例对象中获取我们想要的一些信息，如实例对象中变量的值。这组函数可以分为三小类：
     1.针对整个对象进行操作的函数，这类函数包含 ARC不能使用这些函数
     // 返回指定对象的一份拷贝
     id object_copy ( id obj, size_t size );
     // 释放指定对象占用的内存
     id object_dispose ( id obj );
     
     有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。现在我们创建了一个A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们没有办法直接转换，因为B类的实例会比A类的实例更大，
     
     2.针对对象实例变量进行操作的函数，这类函数包含：
     
     // 修改类实例的实例变量的值
     Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
     // 获取对象实例变量的值
     Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
     // 返回指向给定对象分配的任何额外字节的指针
     void * object_getIndexedIvars ( id obj );
     // 返回对象中实例变量的值
     id object_getIvar ( id obj, Ivar ivar );
     // 设置对象中实例变量的值
     void object_setIvar ( id obj, Ivar ivar, id value );
     
     3.针对对象的类进行操作的函数，这类函数包含：
     // 返回给定对象的类名
     const char * object_getClassName ( id obj );
     // 返回对象的类
     Class object_getClass ( id obj );
     // 设置对象的类
     Class object_setClass ( id obj, Class cls );

     */
    
  
}

/**创建对象*/
- (void)createInstance {
    /**
     // 创建类实例
     id class_createInstance ( Class cls, size_t extraBytes );
     // 在指定位置创建类实例
     id objc_constructInstance ( Class cls, void *bytes );
     // 销毁类实例
     void * objc_destructInstance ( id obj );
     
     class_createInstance函数：创建实例时，会在默认的内存区域为类分配内存。extraBytes参数表示分配的额外字节数。这些额外的字节可用于存储在类定义中所定义的实例变量之外的实例变量。该函数在ARC环境下无法使用。
     
     */
    
}
- (void)setupView {
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    NSLog(@"viewWillAppear");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
