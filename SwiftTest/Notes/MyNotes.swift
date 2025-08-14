//
//  MyNotes.swift
//  SwiftTest
//
//  Created by lezhi on 2018/7/27.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class MyNotes: NSObject {
    
    private func objective_CNotes() {
        /* 面向对象的基本概念: 每个对象都会有一个它所属的类。这对所有数据结构有效。任何数据结构，只要在恰当的位置具有一个指针指向一个class，那么，它都可以被认为是一个对象。
        
        OOP（面向对象编程）的三大特性：
        
        封装：就是将一个类使用和实现分开，只保留部分接口和方法与外部联系 。
            
        继承：子类自动继承其父级类中的属性和方法，并可以添加新的属性和方法或者对部分属性和方法进行重写。继承增加了代码的可重用性。
        
        多态：多个子类中虽然都具有同一个方法，但是这些子类实例化的对象调用这些相同的方法后却可以获得完全不同的结果，多态性增强了软件的灵活性。
         
         ~ UIViewController生命周期：
         StoryBoard: initWithCoder -> awakeFromNib
         xib/code: init(nibName: bundle:)
            -> loadView -> ViewDidLoad -> ViewWillAppear -> updateViewContraints -> viewWillLayoutSubViews -> viewDidLayoutSubViews -> viewDidAppear -> viewWillDisappear -> viewDidDisappear -> dealloc
         
         UIView/CALayer：https://juejin.im/post/5ad9992d6fb9a07abb232745
         和UIView最大的不同是CALayer不处理用户的交互
         UIView是CALayer的CALayerDelegate，提供了处理事件交互的具体功能
         可以说CALayer是UIView的内部实现细节
         */
        
    /*
         NSObject, NSProxy
         1. 继承自NSObject的代理类是不会自动转发respondsToSelector:和isKindOfClass:这两个方法（就是调用这两个方法不会经过消息转发）, 而继承自NSProxy的代理类却是可以的。因为NSObject有定义respondsToSelector与isKindOfClass。而 NSProxy没有。
         2. NSObject的所有Category中定义的方法无法在NSProxy子类中完成转发, 因为valueForKey:是NSObject的Category中定义的方法, 让NSObject具备了这样的接口, 而消息转发是只有当接收者无法处理时才会通过forwardInvocation:来寻求能够处理的对象
         */
        
        /*
         ~ NSAutoreleasePool：一般地，在新建一个iPhone项目的时候，Xcode会自动的为你创建一个Autorelease Pool，就写在main函数里面，NSAutoreleasePool中包含了一个可变数组，用来存储被声明的autorelease的对象。当NSAutoreleasePool自身被销毁的时候，会遍历这个数组release数组中的每一个成员 (注意，这里只是release，并没有直接销毁对象)。若retain count大于1，对象没有被销毁，造成内存泄露。默认的NSAutoreleasePool只有一个，可以在程序中创建NSAutoreleasePool，被标记为autorelease的对象会跟最近的NSAutoreleasePool匹配，可以嵌套使用NSAutoreleasePool。
         
           autoreleasepool以一个队列数组的形式实现,主要通过三个函数完成: objc_autoreleasepoolPush/objc_autoreleasepoolPop/objc_aurorelease
           https://www.jianshu.com/p/7b8f6d443057
         
         ~ Property：用@property声明的属性，相当于自动生成了setter、getter方法，如果重写了set和get方法，@property声明的属性就不是一个成员属性，是另外一个成员变量，而这个成员变量需要手动声明，所以会报错。解决办法用@synthesize 声明的属性 = 变量，意思是将属性的setter、getter作用于这个变量。
         
            weak和assign都能修饰object对象，区别：assign修饰的对象释放后，引用计数为0，变为野指针，向对象发消息，容易崩溃。
            weak修饰的对象释放后，引用计数为0，对象置为nil，向nil发消息没问题，不会崩溃
            weak实现：将weak赋值的对象内存地址作为key，weak修饰的属性变量的内存地址作为value，注册到weak表中
                     weak置为nil，会把变量的内存地址从weak表中移除
         
            __weak底层维系一张散列表SideTable，SideTable中维系一张弱引用表weak_table，weak_table中有很多弱引用对象实体weak_entry_t *entry
            __weak
         
         ~ 没有用__block修饰的外部变量，在定义block时会作为参数传递给block，block内部获取的值都是定义的时候传进来的值，所有变量不可修改。
            __block修饰的变量被包装成对象，然后把变量封装到结构体里面（包含__forwarding指针和变量），存入block结构体中，block通过变量结构体拿到__forwarding指针，通过__forwarding指针拿到结构体中的变量并修改其值
            __forwarding指针指向的是结构体自己。当使用变量的时候，通过结构体找到__forwarding指针，再通过__forwarding指针找到相应的变量
         
         ~ 在 ARC 中，捕获外部了变量的 block 的类会是 __NSMallocBlock__ 或者 __NSStackBlock__，如果 block 被赋值给了某个变量在这个过程中会执行 _Block_copy 将原有的 __NSStackBlock__ 变成 __NSMallocBlock__；但是如果 block 没有被赋值给某个变量，那它的类型就是 __NSStackBlock__；没有捕获外部变量的 block 的类会是 __NSGlobalBlock__ 即不在堆上，也不在栈上，它类似 C 语言函数一样会在代码段中。
            在非 ARC 中，捕获了外部变量的 block 的类会是 __NSStackBlock__，放置在栈上，没有捕获外部变量的 block 时与 ARC 环境下情况相同。
         
         ~ 另外需要注意的是，由于这种继承方式的注入是在运行时而不是编译时实现的，如果给定的实例没有观察者，那么 KVO 不会有任何开销，因为此时根本就没有 KVO 代码存在。但是即使没有观察者，委托和 NSNotification 还是得工作，这也是KVO此处零开销观察的优势。
         
         ~ Runtime：Objective-C类是由Class类型来表示的，它实际上是一个指向objc_class结构体的指针，objc_class结构体包含指向其类的isa指针，通过isa指针找到对象所属的类，类中存放着实例方法列表，方法列表中SEL作为key，IMP作为value。IMP其实就是函数指针，指向了最终的函数实现。Runtime的核心就是objc_msgSend函数，通过给类发送SEL以传递消息，找到匹配的IMP获取最终实现
         
         每个类在内存中有且只有一个class/meta-class对象
         instance isa -> class, class isa -> meta-class
         每个Class都有一个isa指针指向一个唯一的Meta Class元类 (Meta Class存储了类的类方法)
         每一个Meta Class的isa指针都指向最上层的Meta Class，即NSObject的Meta Class，而最上层的Meta Class的isa指针又指向自己
       
         向对象发送消息，对象会根据指针，从类对象的方法列表去查找这个消息方法，class也是对象，所以类方法就是从class对象的类中获取方法列表，而metaClass就是class对象的类
         
           找不到匹配的IMP就进行消息转发，resolveInstanceMethod:或者resolveClassMethod:方法返回NO，会重新启动一次消息发送过程。(1)动态解析： 向接收者所属的类请求能否动态添加方法，如果能就动态添加执行，如不能，(2)备援接受者：Runtime会询问当前接收者是否有其他对象可以处理这个selector(执行forwardingTargetForSelector:方法)，(3)methodSignatureForSelector:方法返回nil，调用doesNotRecognizeSelector:方法抛出异常，返回methodSignature消息重定向：没有备援接受者，Runtime会将未知消息封装为NSInvocation对象，然后调用forwardInvocation:(NSInvocation*)invocation方法，如果不能处理就调用父类的相关方法，一直到NSObject的这个方法，如果NSObject无法处理就调用doesNotRecognizeSelector:方法抛出异常
               https://www.jianshu.com/p/04ba5f3bfc2b
         
         
           KVO：其实子类监听父类属性，并不依赖继承，而是通过isa指针在消息转发的时候能获取到父类的方法就足够。所以，当我们重写父的setter方法，相当于在子类定义了该setter函数，在我们用SEL去找方法签名的时候，直接在子类就拿到了
         
         ~ 在 Objective-C 中向 nil 发送消息是完全有效的——只是在运行时不会有任何作用:
           o 如果一个方法返回值是一个对象，那么发送给nil的消息将返回0(nil)。
           o 如果方法返回值为指针类型，其指针大小为小于或者等于sizeof(void*)，float，double，long double 或者 long long 的整型标量，发送给 nil 的消息将返回0。
           o 如果方法返回值为结构体,发送给 nil 的消息将返回0。结构体中各个字段的值将都是0。
           o 如果方法的返回值不是上述提到的几种情况，那么发送给 nil 的消息的返回值将是未定义的
         
         ~ Runtime应用场景：
           o 关联对象给分类增加属性
           o 方法添加和替换(Method Swizzling)，KVO实现
           o 消息转发(热更新)
           o 实现的自动归档和自动解档
           o 实现字典和模型的自动转换(遍历模型中所有的属性，根据属性名去字典中查找key，取出对应的值，给模型的属性赋值)
         
           Swizzling应该只在+load/+initialize中完成，应只在dispatch_once中完成，在不同线程中也能确保代码只执行一次
           load(只调一次): 只要类所在文件被引用就会调用(类或者category加载到runtime时调用，main之前)
           initialize(可能会调多次): 类或者子类第一个方法被调用前调用
         https://juejin.cn/post/6844903956087308302
         https://juejin.cn/post/6844903527790313479
         
         ~ AFNetWorking：HTTP协议是基于TCP协议的，所以才每次HTTP请求之前，客户端与服务端，都先需要经过TCP连接的三次握手。共享的NSURLSession会复用TCP连接，所以用单例模式让manager持有NSURLSession，一个session创建多个task来实现网络的请求
           NSURLConnection发起请求后，需要一直等待回调，所以开辟一条子线程设置runloop使子线程常驻，所有的请求在这个线程上发起，同时在这个线程上回调。如果来一个请求就开启一条线程，开销太大，所以保活一条固定线程发起请求，接收回调。
           NSURLSession可以指定回调的delegateQueue，不需要在当前线程处理代理方法的回调。maxConcurrentOperationCount设置为1是串行回调，因为mutableTaskDelegatesKeyedByTaskIdentifier访问进行了加锁，并发回调没有意义
           https://www.jianshu.com/p/b5c27669e2c1
           https://www.jianshu.com/p/f32bd79233da
         
         ~ GCD：dispatch_group_enter(group)、dispatch_group_leave(group), 和内存管理的引用计数类似，当调用enter时未执行完毕任务数加1，调用leave时未执行完毕任务数减1，当计数为0时会调用dispatch_group_notify并且dispatch_group_wait会停止等待，解除阻塞，执行添加到dispatch_group_notify中的任务。当所有任务完成之后，才执行dispatch_group_wait之后的操作
         
             信号量：信号量为0则阻塞线程，大于0则不会阻塞。则我们通过改变信号量的值，来控制是否阻塞线程，从而达到线程同步。
                        dispatch_semaphore_create 创建一个semaphore
                        dispatch_semaphore_signal 发送一个信号
                        dispatch_semaphore_wait 等待信号，若信号量大于0，则会使信号量减1并返回，程序继续住下执行
         
         ~ imageNamed: / imageWithContentsOfFile ：如果加载一张很大的图片，并且只使用一次，那么就不需要缓存这个图片。这种情况imageWithContentsOfFile比较合适——系统不会浪费内存来缓存图片。
            然而，如果在程序中经常需要重用的图片，比如用于UITableView的图片，那么最好是选择imageNamed方法。这种方法可以节省出每次都从磁盘加载图片的时间
         
         ~ Category和Extension：Extension在编译期间就加入到类里，是类的一部分，可以添加实例变，Category在运行期决定的，所以无法添加实例变量，所以必须要objc_associate
           Category VS Extension：http://www.cocoachina.com/ios/20170502/19163.html
         
         ~ dispatch_barrier_async 函数会等待Concurrent Dispatch Queue并行队列中的操作全部执行完之后再执行，注意：该函数只能搭配自定义并行队列 dispatch_queue_t 使用。不能使用dispatch_get_global_queue，否则作用会和 dispatch_async 一样
         
         ~ 为什么必须在主线程操作UI：UIKit并不是一个线程安全的类，UI操作涉及到渲染访问各种View对象的属性，如果异步操作下会存在读写问题，而为其加锁则会耗费大量资源并拖慢运行速度。另一方面因为整个程序的起点UIApplication是在主线程进行初始化，所有的用户事件都是在主线程上进行传递（如点击、拖动），所以view只能在主线程上才能对事件进行响应。而在渲染方面由于图像的渲染需要以60帧的刷新率在屏幕上同时更新，在非主线程异步化的情况下无法确定这个处理过程能够实现同步更新。
         
         ~ 面试：http://www.cocoachina.com/ios/20171117/21214.html
                    https://www.jianshu.com/p/553d707e4a0a
                    http://www.cocoachina.com/ios/20180425/23171.html
                    http://www.cocoachina.com/programmer/20180905/24795.html
            Property：https://www.jianshu.com/p/035977d1ba89
            Block：https://www.zhihu.com/question/30779258
                       https://www.jianshu.com/p/8865ff43f30e?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io
                       https://www.zybuluo.com/MicroCai/note/51116
         ~ iOS底层原理总结: https://www.jianshu.com/notebooks/24110540
                          https://www.jianshu.com/u/a6c7fca05933
         ~ fastlane: https://juejin.im/post/5e19a1c2f265da3e097e8da4
         */
    }
    
    private func swift_Notes() {
        /*
         ~ 当你不需要 weak 的时候，还是建议使用 unowned。一个 weak 变量总是需要被定义为 var，而 unowned 变量可以使用 let 来定义。不过，只有在你确定你的引用将一直有效时，才应该使用unowned。
           Use an unowned reference only when you are sure that the reference always refers to an instance that has not been deallocated. If you try to access the value of an unowned reference after that instance has been deallocated, you’ll get a runtime error.
           An unowned reference is expected to always have a value. As a result, ARC never sets an unowned reference’s value to nil, which means that unowned references are defined using nonoptional types
           and will always be deallocated at the same time
         
         
         ~ 1. [unowned self] is almost always a bad idea
           2. Non-escaping closures do not require [weak self] unless you care about delayed deallocation
           3. Escaping closures require [weak self] if they get stored somewhere or get passed to another closure and an object inside them keeps a reference to the closure
           4. guard let self = self can lead to delayed deallocation in some cases, which can be good or bad depending on your intentions
           5. GCD and animation calls generally do not require [weak self] unless you store them in a property for later use
         
         
         ~ 懒加载只会在第一次调用时执行创建对象，后面如果对象被释放了，则不会再次创建。而oc中会再次创建
         
         ~ 当我们在子类定义了指定初始化器(包括自定义和重写父类指定初始化器)，那么必须显示实现required init?(coder aDecoder: NSCoder)，而其他情况下则会隐式继承，我们可以不用理会。而 init(coder aDecoder: NSCoder) 方法是来自父类的指定构造器, 因为这个构造器是 required, 必须要实现. 但是因为我们已经重载了 init(), 定义了一个指定构造器, 所以这个方法不会被继承, 要手动覆写
         
         ~ 1，private
           private只能在本类的作用域，且在当前文件内能访问
         
           2，fileprivate
           fileprivate访问级别所修饰的属性或者方法在当前的Swift源文件里可以访问，不管是否在本类的作用域
           https://www.jianshu.com/p/2a9a94d4fe34
         
           3，internal（默认访问级别，internal修饰符可写可不写）
           internal访问级别所修饰的属性或方法在源代码所在的整个模块都可以访问。
           如果是框架或者库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可以访问。
           如果是App代码，也是在整个App代码，也是在整个App内部可以访问。
         
           4，public
           可以被任何人访问。但其他module中不可以被override和继承，而在module内可以被override和继承。
         
           5，open
           可以被任何人使用，包括override和继承。
         
         ~ 泛型：根据自定义的需求，编写出适用于任意类型，灵活可重用的函数或类型
         
         ~ Swift 通过为泛型代码引入一层间接的中间层来解决这些问题。当编译器遇到一个泛型类型的值时，它会将其包装到一个容器中。这个容器有固定的大小，并存储这个泛型值。如果这个值 超过容器的尺寸，Swift 将在堆上申请内存，并将指向堆上该值的引用存储到容器中去。
           对于每个泛型类型的参数，编译器还维护了一系列一个或者多个所谓的目击表 (witness table): 其中包含一个值目击表，以及类型上每个协议约束一个的协议目击表。这些目击表 (也被叫做 vtable) 将被用来将运行时的函数调用动态派发到正确的实现去
         
         ~ 协议目击表提供了一组映射关系，通过这组映射，我们可以知道泛型类型满足的协议 (编译器通过泛型约束可以静态地知道这个信息) 和某个具体类型对于协议功能的具体实现 (这只在运行时 才能知道) 的对应关系。实际上，只有通过目击表我们才能查询或者操作某个值。我们无法在不加约束地定义一个 <T> 参数的同时，还期望它能对任意实现了 < 的类型工作。如果没有满足 Comparable 的保证，编译器就不会让我们使用 < 操作，这是因为没有目击表可以让我们找到 正确的 < 的实现。这就是我们说泛型和协议是紧密着联系的原因，除了像是 Array<Element> 或者 Optional<Wrapped> 这样的容器类型，脱离了使用协议来约束泛型，泛型所能做的事情也就非常有限了
         
         ~ 通过协议扩展进行代码共享与继承相比，有以下几个优势：
           o 不需要强制使用某个父类
           o 可以让已经存在的类型遵循协议
           o 协议既可以用于类，也可以用于结构体和枚举
           o 通过协议，不需要处理super方法的调用问题
         
         ~ 动态派发的作用就是，在执行时，会先去寻找具体类型中对这个方法的实现，如果有会调用这个类型的实现，如果没有，再调用协议扩展中的实现。而静态派发，就是调用者声明的类型是什么，就去类型中找这个方法的实现，如果类型声明为协议，即使这个类型中有这个方法的现实，也只会调用协议扩展中的实现
         
           o 值类型总是会使用直接派发, 简单易懂
           o 而协议和类的 extension 都会使用直接派发
           o NSObject 的 extension(@objc) 会使用消息机制进行派发
           o NSObject 声明作用域里的函数都会使用函数表进行派发.
           o 协议里声明的, 并且带有默认实现的函数会使用函数表进行派发
         
         ~ 在 swift3 中除了手动添加@objc声明函数支持OC调用还有另外一种方式：继承NSObject。class继承了NSObject后，编译器就会默认给这个类中的所有函数都标记为 @objc
         
         ~ 苹果修改了自动添加@objc的逻辑：一个继承NSObject的swift类不再默认给所有函数添加@objc。只在实现OC接口和重写OC方法时才自动给函数添加@objc标识
         
         ~ 0418
           forEach和for循环的区别：在forEach中的return并不能返回到外部函数的作用域之外，forEach
           它仅仅只是返回到闭包本身之外
         
         ~ 0423
           1.对于序列和集合来说，它们之间的一个重要区别就是序列可以是无限的，而集合则不行
           2.序列并不保证可以被多次遍历(像是网络包的流这样的序列将会随着遍历被消耗)
           3.集合能确定元素的位置，在序列的基础上实现了Indexable协议
         
         ~ 0503
           1. 如果我们定义了一个可变变量screen，我们可以为它添加didSet，这样每当screen改变时这个代码块都将被调用。这个didSet对所有结构体定义都会有效
           2. sort和sorted的名字选择是有所考究的，确切说，它们的名字遵循了Swift API设计准则。对于translate和translated，我们也使用了同样的规则。对于拥有可变和不可变版本的方法，甚至还有专⻔的文档解释:因为translate拥有副作用，所以它应该读起来是一个祈使动词短语。而不可变的版本应该以 -ed 或者 -ing 结尾
         
         ~ 0507
           当你不需要weak的时候，还是建议使用unowned。一个weak变量总是需要被定义为var，
           而unowned变量可以使用let来定义。不过，只有在你确定你的引用将一直有效时，才应该使用unowned
         
         ~ 0508
           在代理和协议的模式中，并不适合使用结构体
         
         ~ 0517
           这个log函数使用了像是#le，#function 和 #line 这样的调试标识符。当被用作一个函数的默认参数时，它们代表的值分别是调用者所在的文件名、函数名以及行号，这会非常有用
         
         ~ 0920
           模式匹配：
           o 通配符模式：_表示忽略匹配的值
           o 标示模式：匹配一个具体的值
             switch 5 {
             case 5: print("5")
             }
           o 值绑定模式：只能用在switch中
             switch (4, 5) {
             case let (x, y): print("\(x) \(y)")
             }
           o 元组模式：
           o 枚举case模式：
           o 类型转换模式：is,as
           o 表达模式：范围匹配
         
         ~ 1017
           Class类型的方法派发是通过V-Table来实现动态派发的，Swift会为每一个Class类型生成一个Type信息并放在静态内存区域中，而每个Class类型实例的Type指针就指向静态内存区域中本类型的Type信息，当某个类实例调用方法的时候，首先会根据该实例的Type指针找到该类型的Type信息，然后通过信息中的V-Table得到方法的地址，并跳转到相应方法的实现地址去执行方法
         
         ~ Sequence/Collection
           https://academy.realm.io/cn/posts/try-swift-soroush-khanlou-sequence-collection/
           Sequence：可以说无限的或有限的，只能迭代一次
           Collection：有限的，可以多次迭代
         
         存储属性：类似于成员变量的概念，存储在实例对象的内存中
         计算属性：本质就是方法(函数)，不占用实例对象的内存
         运算符重载：类、结构体、枚举，为现有的运算符提供自定义的实现
         
         
         常见crash:
         http://shevakuilin.com/ios-crashprotection/
            数组添加空值、越界
            unrecognizedSelector (没有实现代理，可变属性使用copy修饰，低版本系统使用高版本API)
            向已销毁的对象发消息 Bad Access
            KVC取值赋值异常 (重写setValue:forUndefinedKey，NSStringFromSelector反射)
            assign修饰对象
            block为nil
            self提前释放
            多线程操作
         
         优化：
         属性声明为optional，使用确用了!强制解析
         有无用的文件/Xib
         不开放的属性和方法前加private
         图片另加button及点击
         for循环，满足条件return
         toggle(),  Array.shuffled(), isEmpty
         popLast(), dropFirst()
         tableView: heightForRow
         The image set name "XXX" is used by multiple image sets
         约束冲突，编译警告
         synchronize()
         removeObserver()
         array: sum -> .reduce(0, +)
         init(nibName: “XXViewController”)，注意组件化
         
         */
    }
    
    private func swiftUI_notes() {
        /*
         https://www.cnblogs.com/xiaoniuzai/p/11417123.html
         @State: 属性存储到一个特殊的内存区域, 当 @State 装饰过的属性发生了变化，SwiftUI 会根据新的属性值重新创建视图
         @Binding: 修饰后，属性变成了一个引用类型，传递变成了引用传递，这样父子视图的状态就能关联起来了
         @ObservedObject：不管存储，会随着view的创建被多次创建(必须要实现 ObservableObject 协议，然后用 @Published 修饰对象里属性，表示这个属性是需要被 SwiftUI 监听的)
         @StateObject：保证对象只会被创建一次
         
         @EnvironmentObject: 针对全局环境
         
         */
    }
    
    private func dateStructure() {
        /*
         数据结构的存储方式：
         1. 顺序存储 (索引存储)
         2. 链接存储 (散列存储)
         
         */
    }
    
    private func other() {
        /*
         request API
         https://sportsnba.qq.com/team/list
         https://reqres.in/api/users
         http://barhoppersf.com/json/neighborhoods.json
         
         http://a.itying.com/api/productlist
         https://jsonplaceholder.typicode.com/posts (vpn)
         
         https://gist.githubusercontent.com/V8tr/b8d3e63f7d987d3298cc83c9362f1c6e/raw/ad3f8f697835ec2dbd9a36779f84ffed9911c8aa/currencies.json
         https://rss.applemarketingtools.com/api/v2/tw/music/most-played/10/songs.json
         https://randomuser.me/api/?results=10
         https://api.github.com/users/twostraws/followers
         http://barhoppersf.com/json/neighborhoods.json
         https://simplejsoncms.com/api/zya2ekn3i9p
         
         https://flutter.cn/docs/cookbook/networking/fetch-data
         https://v.juhe.cn/toutiao/index?type=shishang&key=483294d5e9b2202317817d0696b47a58
         https://api.kivaws.org/v1/loans/newest.json
         https://www.wanandroid.com/banner/json
         
         https://emoji-api.com
         https://dog.ceo/api/breed/hound/images
         https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/10/apps.json
         
         https://iosfeeds.com/api/articles/
         https://iosfeeds.com/api/videos/
         
         https://pokeapi.co/api/v2/pokemon/ditto
         https://pokeapi.co/api/v2/pokemon
         
         //nameOptions=ALL/Boy Names/Cities/Continents/Countries/Films/Funny Words/Games/Girl Names/Job Titles/Objects/Planets/Presidents/Star Wars Characters/Star Wars First Names/Star Wars Last Names/Star Wars Titles/States
         https://names.drycodes.com/20
         https://names.drycodes.com/10?nameOptions=countries
         https://names.drycodes.com/10?nameOptions=films
         https://names.drycodes.com/10?nameOptions=planets
         https://raw.githubusercontent.com/PeterPanSwift/ParseWWDC/main/video_list.json
         
         https://data.ntpc.gov.tw/openapi/swagger-ui/index.html?configUrl=/api/v1/openapi/swagger/config
         https://data.ntpc.gov.tw/api/datasets/308dcd75-6434-45bc-a95f-584da4fed251/json?size=100&page=0
         
         https://rss.applemarketingtools.com/api/v2/tw/music/most-played/10/albums.json
         https://hws.dev/messages.json
         https://api.viewbits.com/v1/fortunecookie?mode=random
         https://itunes.apple.com/search?term=swift&media=music&country=tw
         https://api.github.com/users/twostraws/followers
         
         萌典 API: https://github.com/g0v/moedict-webkit/?source=post_page-----a0069a4345bd--------------------------------
         目前 API 已有 7 個端點，分別是 /a/, /t/, /h/, /c/, /raw/, /uni/, /pua/
         https://www.moedict.tw/uni/萌
         */
        
        /*
         net image
         
         https://httpbin.org/image/png
         https://img.house730.com/202304/d1b6e6beeb294e748de31d06bdf54066.jpg?x-oss-process=style/1080xauto_f.webp
         
         https://img.house730.com/202304/994f6e3aef294a02ba5ddfb8e9b87cbc.jpg?x-oss-process=style/1080xauto_f.webp
         
         https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/pic.webp
         
         http://mvimg2.meitudata.com/55fe3d94efbc12843.jpg
         https://raw.githubusercontent.com/SAWARATSUKI/ServiceLogos/main/Swift/Swift.png
         
         https://picsum.photos/250?image=9
         https://docs.flutter.dev/assets/images/dash/dash-fainting.gif
         https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg
         https://docs.flutter.dev/cookbook/img-files/effects/instagram-buttons/millenial-texture.jpg
         https://avatars2.githubusercontent.com/u/20411648?s=460&v=4
         
         http://img1.mukewang.com/5c18cf540001ac8206000338.jpg
         http://ww1.sinaimg.cn/large/610dc034ly1fjaxhky81vj20u00u0ta1.jpg
         http://ww1.sinaimg.cn/large/610dc034ly1ffmwnrkv1hj20ku0q1wfu.jpg
         
         https://cdn.eso.org/images/thumb300y/eso1907a.jpg
         https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg
         https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80
         
         
         https://www.itying.com/images/flutter/1.png
         https://www.itying.com/images/flutter/2.png
         https://www.itying.com/images/flutter/3.png
         https://www.itying.com/images/flutter/4.png
         https://www.itying.com/images/flutter/5.png
         https://www.itying.com/images/flutter/6.png
         https://www.itying.com/images/flutter/7.png
         
         https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.png
         https://www.bilibili.com//s1.hdslb.com/bfs/static/jinkela/video/asserts/oldfanIcon.svg
         
         net video
         https://www.runoob.com/try/demo_source/mov_bbb.mp4
         
         https://flutter.github.io/assets-for-api-docs/assets/audio/rooster.mp3
         https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4
         https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4
         
         https://cdn.pixabay.com/video/2020/05/15/39116-420985147_tiny.mp4
         https://cdn.pixabay.com/video/2023/06/09/166390-834930260_tiny.mp4
         https://cdn.pixabay.com/video/2021/09/30/90293-619556506_tiny.mp4
         https://cdn.pixabay.com/video/2020/05/15/39120-421020144_tiny.mp4
         https://cdn.pixabay.com/video/2020/04/25/37144-413256576_tiny.mp4
         https://cdn.pixabay.com/video/2022/08/13/127738-739309173_tiny.mp4
         
         https://cdn.pixabay.com/video/2024/07/06/219728_tiny.mp4
         https://cdn.pixabay.com/video/2023/07/20/172451-847505208_tiny.mp4
         
         https://pixabay.com/users/flickrvideos-1283682/
         */
    }
    
    /*
     
     */
}
