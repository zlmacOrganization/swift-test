//
//  ZLDiary.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2018/10/21.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

class ZLDiary: NSObject {
    /*
     -- 0901
     Xcode -> Edit Scheme -> Run -> Options -> Application Language -> 可以选择不同语言进行国际化测试
     storyboard -> 选择右边中间的双圆圈按钮 -> Manual -> preview -> storyboard -> 可预览运行效果
     同时选中两个控件，点击布局左边下载按钮，自动将两个控件放到UIStackView中，只需要修改UIStackView的约束即可
     
     -- 0902
     UIImage: downsampling
     Usee UIGraphicsImageRender to create and draw to an image buffer
     Network Link Conditioner (wireshark, tcptrace tools)
     HTTP cookies
     
     -- 0906
     Swift 4.2:  Int.random(in: 0..<10)
     Float.random(in: 0..<1)
     ["hey", "hi"].randomElement()
     ["hey", "hi"].shuffled()
     
     
     #if canImport(UIKit)        #if hasTargetEnvironment(simulator)
     import UIKit
     
     #else                           #else
     import AppKit               #endif
     
     -- 0909
     Apple school manager
     
     -- 0924
     copy on write: 两个对象可以指向共享后备存储，直到发生变更。当发生变更时，突变方复制后备存储，从而允许进行写入。简而言之，复制操作不会占用过多资源
     
     -- 1017
     Int,Double,Struct,String等是在赋值的时候复制的，而集合类型(Array, Dictionary, Set)是在值改变的时候才去复制(写时复制)
     
     -- 1018
     here are four aspects that guide how dispatch is selected:
     
     Declaration Location
     Reference Type
     Specified Behavior
     Visibility Optimizations
     
     -- 1019
     Class类型的方法派发是通过V-Table来实现动态派发的，Swift会为每一个Class类型生成一个Type信息并放在静态内存区域中，而每个Class类型实例的Type指针就指向静态内存区域中本类型的Type信息，当某个类实例调用方法的时候，首先会根据该实例的Type指针找到该类型的Type信息，然后通过信息中的V-Table得到方法的地址，并跳转到相应方法的实现地址去执行方法
     
     -- 1021
     Self：可以用于协议中限制相关类型，或用于类中充当方法的返回值类型
     
     -- 1022
     双等号（== & !=）可以用来比较变量存储的内容是否一致，如果要让 struct 类型支持该符号，则必须遵守 Equatable 协议
     三等号（=== & !==）可以用来比较引用类型的引用（即指向的内存地址）是否一致
     
     -- 1101
     @autoclosure作用:
     1. 简化闭包的调用形式
     2. 延迟闭包的执行(调用的时候才去执行)
     https://www.avanderlee.com/swift/autoclosure/
     
     @escaping：表示此闭包还可以被其他闭包调用(异步操作，被持有)
            该闭包在函数执行完成之后才被调用
     If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is escaping
     
     @noescape: 默认的关键字
     编译器知道闭包的生命周期，便于内存管理，可以使用self，不用考虑weak
     
     Trailing Closures(尾随闭包)：将闭包表达式作为函数的最后参数传递给函数
     
     -- 1104
     Class类型：内存分配在堆区，栈区存储了对象的指针
     Struct类型：内存分派在栈区
     
     Value Witness Table (VWT)：用于管理任意值的初始化、拷贝、销毁
     Protocol Witness Table (PWT)：管理Protocol Type的方法分派
     
     -- 1105
     iOS项目编译速度：https://zhuanlan.zhihu.com/p/27584726
     
     -- 1108
     https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007072-CH1-SW1
     
     https://juejin.im/post/5cf5d8ae6fb9a07ef06f7fc9
     map：
     flatMap(instead: compactMap in Swift 4.1)：会将数组中的nil值过滤掉
                   遍历二维数组，会对结果进行“降维”，变成一维数组（将一个集合中的所有元素，添加到另一个集合）
     
     -- 1112
     iOS性能优化总结：https://juejin.im/post/5ace078cf265da23994ee493
     
     VSync信号到来 -> CPU：视图创建、布局、图片解码、文本绘制 -> 提交到GPU进行变换、合成、渲染 -> 把渲染结果提交到缓冲区，等到下一次VSync信号来时显示到屏幕上 / 如果在一个VSync时间内CPU和GPU没有完成内容提交，则那一帧会被丢弃，等待下一次机会在展示，而这时屏幕会保持之前的内容不变。这就是界面卡顿的原因
     CPU和GPU任何一个压力过大，都会导致掉帧现象
     https://www.jianshu.com/p/671dba277345
     
     离屏渲染：在显示屏上显示内容，至少需要与屏幕像素一样大的frame buffer，作为像素数据存储区域，而这也是GPU存储渲染结果的地方。如果无法把渲染结果直接写入frame buffer，而是先暂存在另外的内存区域，之后再写入，这个过程称为离屏渲染
     https://zhuanlan.zhihu.com/p/72653360 (会重新创建缓冲区，上下文切换)
     https://cloud.tencent.com/developer/article/1638099
     离屏渲染产生的原因: 1. 有些图层在没有预合成之前不能直接在屏幕中绘制，2. 有些视图渲染后的纹理需要被多次复用，但屏幕内的渲染缓冲区是实时更新的
     
     shadow 可以通过指定路径来避免离屏渲染 / 真正的离屏渲染发生在GPU
     使用混合图层优化 / 尽量使用不包含透明（alpha）通道的图片资源
     shouldRasterize = YES 将隐式的创建一个位图，各种遮罩阴影的效果会保存到位图中并缓存起来，从而减少渲染的频度
     会将光栅化的内容缓存起来，如果对应的layer及其sublayers没有发生改变，在下一帧的时候可以复用
     
     离屏渲染缓存内容有时间限制，100ms内如果没有被使用，就会被丢弃
     离屏渲染缓存空间有限，超过2.5倍屏幕像素大小的话也会失效，无法复用
     
     渲染优化：
     重写了drawRect会导致CPU渲染；在CPU进行渲染时，GPU大多数情况是处于等待状态
     离屏渲染会导致上下文切换，GPU产生idle，越少越好
     避免格式转换和调整图片大小；一个图片如果不被GPU支持，那么需要CPU来转换
     去掉视图树上不必要的元素，remove
     
     iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的
     
     -- 1127
     A very informal glance at the Swift standard library suggests that every protocol that includes the mutating keyword is intended to be conformed to by a value type
     
     -- 1128
     KVO-enabled properties must be @objc dynamic
     
     -- 1205
     defer 所声明的 block 会在当前代码执行退出后被调用(其实是当前 scope 退出的时候调用，作用域不是整个函数), if，guard，for，try使用 defer 时应该要特别注意
        defer语句在代码块作用域退出之前执行，也就是代码块中其它应该执行的代码都执行完了，才执行defer中的代码
        一个代码块允许多个defer，多个defer执行的顺序是从后到前
     
     struct -> instance method use mutating keyword -> can modify the structure's property
     
     -- 1206
     GCD: https://juejin.im/post/5acaea17f265da239a601a01
          https://juejin.im/post/5e732f63e51d4527196d7616
     DispatchQueue(label: "com.roki.thread") -> 默认创建的是串行队列
     
     -- 1207
     类型属性：
     值类型用static关键字来定义类型属性，类用class关键字来定义
     https://www.jianshu.com/p/9e2aff936b8f
     
     -- 1210
     enum: indirect keyword，这意味着它们的关联值是间接保存的，这允许我们定义递归的数据结构(A recursive enumeration is an enumeration that has another instance of the enumeration as the associated value for one or more of the enumeration cases)
     
     -- 1213
     masonry布局，在UIViewController重写了updateViewConstraints方法，没有调用super，直接崩溃，报错：invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific...，调用[super updateViewConstraints]就没问题
     
     -- 1214
     OOP(Object Oriented Programming)和POP(Protocol Oriented Programming)主要的一点不同在于：
     类只能继承自其它一个类，但协议可以继承自多个协议
     
     -- 1220
     ()表示不含任何元素的多元组
     
     -- 1221
     iOS签名机制：https://juejin.im/post/5c1b71566fb9a04a0821a474
                http://blog.cnbang.net/tech/3386/
     
     -- 1223
     swift类型擦除(具体类型/抽象类型)：https://academy.realm.io/cn/posts/altconf-hector-matos-type-erasure-magic/
     https://ming1016.github.io/2018/01/24/why-swift/
     
     -- 1224
     button.addTaget: -> if you specify target to nil，UIKit search the responder chain for an object that respond to the specified action message and deliver the message to that object
     https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget
     
     swift tips: https://savvyapps.com/blog/swift-tips-for-developers
     Kingfisher: https://zlanchun.github.io/2017/02/07/Kingfisher1.html
     Articles:   https://www.hackingwithswift.com/articles
     
     
     /////////////////////////  --------------------  ////////////////////////
     -- 2019 0103
     Swift编译：Swift Source -> Swift AST -> Swift IL -> LLVM IR -> Assemble
     Swift源码进行词法分析和语法分析，生成抽象语法树 - 从AST生成Swift中间语言(Swift Intermediate Language，SIL) - 被翻译成通用的LLVM中间表述 (LLVM Intermediate Representation, LLVM IR) - 最后通过编译器后段的优化，得到汇编语言
     
     String/Substring: https://imtx.me/blog/swift-4-substring/
     Swift Blogs: https://juejin.im/post/5a941ef96fb9a06346201d9e
     
     -- 0108
     Swift doc/CHN: https://www.cnswift.org/initialization
                    https://swift.bootcss.com
                    https://swiftgg.gitbook.io/swift/
                    https://numbbbbb.gitbooks.io/-the-swift-programming-language-/content/chapter2/13_Inheritance.html
     
                    https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309
     
     -- 0113
     iterm/zsh: https://xiaozhou.net/learn-the-command-line-iterm-and-zsh-2017-06-23.html
                https://wuzhuti.cn/mac-use-iterm2-and-oh-my-zsh
     Xcode修改工程名：https://www.jianshu.com/p/abf10c9609ef
     
     -- 0115
     h5与原生交互：https://segmentfault.com/a/1190000016759517
     
     -- 0117
     并发编程/Lock：https://juejin.im/post/5b1cf4fa6fb9a01e4b062771
     原理篇：https://www.jianshu.com/p/d87efbf427c5
     
     -- 0118
     Swift性能优化：http://www.cocoachina.com/ios/20181102/25362.html
     Protocol详解：https://juejin.im/post/59dd7c50f265da431522e1c1
     
     -- 0212
     为什么必须在主线程操作UI：http://www.cocoachina.com/ios/20190118/26167.html
     Websites: https://www.hackingwithswift.com/articles
               https://www.appcoda.com/
     
     -- 0218
     Guide: https://www.ctolib.com/topics-107030.html
     
     -- 0220
     如果你在协议中标记实例方法需求为 mutating ，在为类实现该方法的时候不需要写 mutating 关键字。 mutating 关键字只在结构体和枚举类型中需要书写
     
     -- 0221
     WebSocket：需要握手建立连接(双向通信协议)，基于TCP的应用层协议(第七层)，WebSocket依赖于Socket
     Socket：是应用层与TCP/IP协议族通信的中间软件抽象层(传输层第四层)，它是一组接口(通过IP找到目标主机，通过端口与指定的应用程序通信)，是对TCP/IP协议的封装
     
     若双方是Socket连接，可以由服务器直接向客户端发送数据
     若双方是HTTP连接，则服务器需要等客户端发送请求后，才能将数据回传给客户端
     HTTP为短连接
     
     hash冲突：https://juejin.im/post/5c6abfc86fb9a049c04396a7
          http://www.nowamagic.net/academy/detail/3008060
     开放地址法：当地址已经被占用时，就再重新计算，直到生成一个不被占用的地址
     链地址法：采用一个链表将所有冲突的值一一记录下来
     
     -- 0307
     font: https://zenozeng.github.io/Free-Chinese-Fonts/
     线程、队列：https://juejin.im/post/5a90de68f265da4e9b592b40
     多线程：https://seinf.mobi/2019/04/03/ios-gcd-understanding/
           https://juejin.im/post/5acaea17f265da239a601a01#heading-3
     
     -- 0309
     类、对象、元类：https://juejin.im/post/5a9f7707f265da23a1416f77
     对象的本质：https://www.jianshu.com/p/ffd742041946
     Category为什么不能添加成员变量：https://quotation.github.io/objc/2015/05/21/objc-runtime-ivar-access.html
     WKWebView: https://www.jianshu.com/p/7557456ffc57
     Runtime: https://zhuanlan.zhihu.com/p/35995194
              https://juejin.im/post/5e5766cee51d4526f16e4c30
     
     -- 0317
     利用%求出来的余数是正数还是负数，由%左边的被除数决定，被除数是正数，余数就是正数，反之则反, -5 % -2 = -1
     位运算中“与”、“或”会造成信息丢失，他们是单向运算，不可逆运算，“异或”不会造成信息丢失，而且具有很好的性质
     
     -- 0414
     swift isEmpty/count == 0: https://juejin.im/post/5c9307f95188252d955918c3
     
     -- 0506
     swift编译优化
     https://juejin.cn/post/6901166626180169735
     https://www.jianshu.com/p/5b2cce762106?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
     
     -- 0521
     构造器：https://draveness.me/swift-zhong-init-de-shi-yong.html
     
     -- 0522
     Swift 中的子类不会默认继承父类的构造器，但是如果特定条件可以满足，父类构造器是可以被自动继承的：
     1. 如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器
     2. 如果子类提供了所有父类指定构造器的实现–不管是通过规则1继承过来的，还是通过自定义实现的–它将自动继承所有父类的便利构造器
     
     Style:
     https://www.jianshu.com/p/a89a58848bff
     https://www.yuque.com/kiwi/ios/swift-api-design
     
     -- 0524
     命名空间：https://juejin.im/post/5a312401f265da43052e9fb8
     泛型类 -> 泛型协议 -> 协议拓展 / 类型协议 -> 命名空间协议 -> 协议拓展
     
     -- 0604
     https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
     
     -- 0715
     get Controller in UIView
     https://www.jianshu.com/p/fb6bdb43ba66
     
     -- 0728
     Accessibility：
     https://www.jianshu.com/p/0991a4f0bc0c
    https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/iPhoneAccessibility/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008785-CH1-SW1
     
     开源库收集：https://www.jianshu.com/p/0794dacb6685
     
     -- 0809
     网站： https://juejin.im/post/5d4b88155188250571068334
     
     -- 0820
     事件机制：https://juejin.im/post/5d396ef7518825453b605afa#heading-24
     锁：https://juejin.im/post/5d554410f265da03b21532cd#heading-15
     
     -- 0823
     Swift 元类型(.Type 与 .self)：https://juejin.im/post/5bfc0c096fb9a04a027a085b
      ~ .Type returns an instance of a metatype
      ~ Call .self on a concrete type like Int.self which will create a static metatype instance Int.Type (to access a type as a value).
     
      ~ Get the dynamic metatype instance from any instance through type(of: someInstance).
     
     -- 0905
     Swift派发机制：https://kemchenj.github.io/2017-01-09
                  https://seinf.mobi/2019/04/06/swift-method-dispathch-mechanism/
                  https://gpake.github.io/2019/02/11/swiftMethodDispatchBrief/
     内存：https://juejin.im/post/5a7b04c86fb9a0634b4d632a
          https://juejin.im/entry/59156846a22b9d0058007283
     
     -- 0916
     Tagged Pointer: 专门用来存储小的对象，例如NSNumber和NSDate, 提高内存读取的效率
                     https://www.jianshu.com/p/c9089494fb6c
     
     -- 0921
     Swift String: https://www.jianshu.com/p/566d726e935d
     
     {
     Sign In With Apple: https://xiaozhuanlan.com/topic/8675913204
         Sample Code: https://developer.apple.com/documentation/authenticationservices/adding_the_sign_in_with_apple_flow_to_your_app
     
     }
     
     -- 1012
     codable: http://swiftcafe.io/post/codable
              https://zhuanlan.zhihu.com/p/50043306
              https://juejin.cn/post/6944369506441494541
              https://benscheirman.com/2017/06/swift-json/
     https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d
     
     -- 1016
     @propertyWrapper: https://juejin.im/post/5d2b420b6fb9a07ea803f994
     notification: https://www.avanderlee.com/swift/rich-notifications/
     
     -- 1020
    面试： https://juejin.im/post/5d7f35976fb9a06b20059680?utm_source=gold_browser_extension
     
     https://awhisper.github.io/2017/09/02/universallink/
     https://juejin.im/post/5db143def265da4d307f0694
     
     -- 1103
     并发编程： https://yangjie2.github.io/2018/07/06/iOS%E5%B9%B6%E5%8F%91%E7%BC%96%E7%A8%8B%E5%8F%8A%E9%99%B7%E9%98%B1/
     
     static/class：https://juejin.im/post/5c81e255f265da2dc9732b71
     class不能修饰类的存储属性，static可以修饰类的存储属性
     
     as：
     https://medium.com/@abhimuralidharan/typecastinginswift-1bafacd39c99
     
     -- 1117
     sign in with apple:
     https://sarunw.com/posts/sign-in-with-apple-1/
     https://easeapi.com/blog/blog/88-sign-with-apple.html
     https://firebase.google.com/docs/auth/ios/apple
     https://juejin.im/post/5deefc5e518825126416611d
     https://www.wangquanwei.com/553.html
     
     -- 1120
     hash/面试doc： https://hit-alibaba.github.io/interview/basic/algo/Hash-Table.html
     Swift笔记：https://www.kancloud.cn/curder/swift/406013
     
     -- 1123
     Swift Array remove duplicate
     https://www.logcg.com/archives/3177.html
     
     -- 1124
     面试：http://www.cocoachina.com/articles/475857
          https://dayon.gitbooks.io/-ios/content/chapter8.html
     MachO文件：http://www.cocoachina.com/articles/29497
     工具：http://www.cocoachina.com/articles/475868
     
     -- 1126
     bloglist：https://iosdevdirectory.com/
     
     Swift 5.0: @unknown default/frozen enum - https://juejin.im/post/5cbae4216fb9a0689677a30a
     apple home screen quick action demo：https://developer.apple.com/documentation/uikit/menus_and_shortcuts/add_home_screen_quick_actions#//apple_ref/doc/uid/TP40016545
     内存管理：https://juejin.im/post/5ddbf5a551882572fa6a909b
     Developer Tips：https://medium.com/developerinsider/best-ios-development-tips-and-tricks-6c42c1d208c1
     
     -- 1127
     SDWebImage：https://juejin.im/post/5adeede8518825672f19839a
                https://www.jianshu.com/p/52845e44163a
     Swift third party：https://juejin.im/post/5a3124315188253ee45b71ab
     
     -- 1129
     blog：http://muhlenxi.com/
     
     -- 1202
     NSClassFromString in Swift
     https://stackoverflow.com/questions/28706602/nsclassfromstring-using-a-swift-file
     
     -- 1205
     Xcode编译过程：https://www.jianshu.com/p/14612abdeb26
     
     -- 1210
     Swift: @_dynamicReplacement
     
     functional programing https://peteruncle.com/2018/02/26/swift%E4%B8%ADmap%E4%B8%8EflatMap%E7%9A%84%E7%94%A8%E6%B3%95%E4%B8%8E%E7%A0%94%E7%A9%B6/#map%E5%92%8CflatMap%E7%94%A8%E6%B3%95
     
     闭包作为对象，方法捕获的是闭包的拷贝
     闭包作为参数，方法捕获的是闭包的引用
     https://juejin.im/post/5ad9df21518825673e352f82
     https://juejin.cn/post/6935797942435446791
     
     //
     进程vs线程：https://blog.51cto.com/9736972/1620723
     进程需要分配独立的内存空间，线程不需要额外消耗
     线程之间是共享同一数据结构的，进程之间都有相互独立的地址空间
     一个进程可以由多个线程组成
     
     队列：先进先出的线性表，任务都是在队列中派发的
     窜行队列：队列中的任务是一个一个执行的，必须等上一个任务执行完才能执行下一个
     并发队列：队列中的任务可以同时执行(在一条线程上快速切换，让人感觉在同步进行)
     
     并发: 一个处理器同时处理多个任务 (逻辑上的同时发生)
     并行: 多个处理器或多核的处理器同时处理多个不同的任务 (物理上的同时发生)
     
     同步和异步是针对任务的执行来说的，只影响是否阻塞当前线程
     同步：调用函数时，必须等函数执行完成才会执行下面的代码，在当前线程中执行任务，不会开启新的线程
     异步：不管函数有没有执行完，都会执行下面的代码，具备开启新线程的能力 (也有可能不会)
     
     窜行队列添加任务，在主线程执行(主线程中追加的同步任务，和主线程本身的任务相互等待)，会死锁 (在主队列开启同步任务)
     
     //
     UserDefaults store struct/enum using Codable -> Data
     
     -- 1211
     Closures Are Reference Types
     https://juejin.im/entry/57a4b3d37db2a2005a992f67
     
     -- 1216
     Dictionary: key和value分别存储在两个不同的数组里
     首先key根据hash函数算出hash值，然后对数组的长度取模，得到数组下标的位置，同样将这个地址对应到values数组的下标，匹配到相应的value，如果下标已有数据， 后移插入 (keys和values两个数组的长度要一致，扩容也一样)
     
     App launch：https://www.jianshu.com/p/c0c4f19d317f
     
     performSelector:afterDelay 方法在当前线程的runloop设置定时器来执行Selector
     在子线程调用该方法延时不起作用，因为子线程里的runloop默认是没有开启的
     
     PerformSelector原理/blog：https://blog.chenyalun.com/2018/09/30/PerformSelector%E5%8E%9F%E7%90%86/
     
     常用设计模式：工厂方法模式、单例模式、观察者模式、代理模式
     
     //
     GCD注意：
     死锁 / dispatch_barrier只能搭配自定义并行队列
     并发队列只在异步下才有效
     
     //atomic所说的线程安全只是保证了setter和getter存取方法的线程安全，并不能保证整个对象是线程安全的
     sync和async区别就是会不会阻塞当前线程
     
     -- 1219
     线程间的通信
     NSThread：将自己当前线程中的对象注册到某个全局对象中，这样相互之间就可以获取到对方的线程对象
     GCD：dispatch_async(main_queue)，group_notify
     NSOperation：[NSOperationQueue mainQueue]
     
     函数式编程优势 / 高并发的场景 / 推送机制
     
     TCP用什么机制保证可靠性：https://www.cnblogs.com/myseries/p/11774179.html
     连接管理、校验和、序列号、确认应答、超时重传、流量控制、拥塞控制
     
     UDP：无连接，缺乏可靠性，支持多播和广播
     
     三次握手：
     1.客户端发送 syn 包到服务器，等待确认
     2.服务器收到包后，确认客户端 syn 包，同时发送 SYN+ACK 包
     3.客户端收到包，向服务器发送 ACK 报文，表示已收到服务器的报文
     完成三次握手，连接建立后，可以进行数据传输
     https://draveness.me/whys-the-design-tcp-three-way-handshake/
     
     四次挥手：
     1.客户端发送 FIN 报文，等待确认
     2.服务端收到 FIN 之后，会发送 ACK 报文
     3.如果服务器也想断开连接，也发给 FIN 报文，等待客户端的确认
     4.客户端收到 FIN 之后，也发送 ACK 报文作为应答，此时客户端处于 TIME_WAIT 状态，服务端收到 ACK 报文之后，就处于关闭连接了
     
     SYN+ACK：ACK报文是用来应答的，SYN报文是用来同步的，但是关闭连接时，当服务端收到FIN报文时，很可能并不会立即关闭SOCKET，所以只能先回复一个ACK报文，告诉客户端，"你发的FIN报文我收到了"。只有等到我服务端所有的报文都发送完了，我才能发送FIN报文，因此不能一起发送
     https://juejin.im/post/5d9c284b518825095879e7a5
     https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485310&idx=1&sn=615cd1a1243e3b6ab3d1c0b654d29f8b&scene=21#wechat_redirect
     
     http缺点：1. 通信使用明文(不加密)，内容可能被窃听
              2. 不校验通信方的身份，有可能遭遇伪装
              3. 无法验证报文的完整性，有可能已遭篡改
     
     -- 1220
     NSArray/NSMutableArray/NSDictionary添加元素的时候，会被强引用持有，
     弱引用方法：使用NSValue、NSPointerArray、NSHashTable（Dictionary使用NSMapTable）
     
     Stored type properties are lazily initialized on their first access. They are guaranteed to be initialized only once
     
     -- 1223
     IAP掉单：https://juejin.im/post/5df64beff265da33e97fcd2f
     https://tangbl93.github.io/2018/12/02/iap-issues/index.html
     
     NSProcessInfo: 判断系统版本号(iOS8以上)
     面试题: https://juejin.im/post/5df9ded3e51d45580a4ad92b
     
     深拷贝/浅拷贝: https://juejin.im/post/5d9de2d3f265da5bb414bf4e
        1. 可变对象：  copy与mutableCopy都是深拷贝
        2. 不可变对象：copy是浅拷贝，mutableCopy是深拷贝
        3. copy方法返回的对象都是不可变对象
     
     -- 1224
     Swift 5.1: https://zhuanlan.zhihu.com/p/68621003
     
     -- 1230
     @objc / @nonobjc 控制方法对于 objc 的可见性。但是不会改变 swift 中的函数如何被派发
     编译器无法对动态派发进行优化操作
     
     -- 1231
     Collection: lazy.map, lazy.filter
     https://seinf.mobi/2019/04/16/using-collections-effectively
     https://stackoverflow.com/questions/51917054/why-and-when-to-use-lazy-with-array-in-swift
     Array.prefix
     
     /////////////////////////  --------------------  ////////////////////////
     -- 2020 0102
     图片解码: https://code.imerc.cc/2017/07/09/ios-image-decode/
     
     url -> MD5 / MD5算法具有以下特点：
     1、压缩性：任意长度的数据，算出的MD5值长度都是固定的。
     2、容易计算：从原数据计算出MD5值很容易。
     3、抗修改性：对原数据进行任何改动，哪怕只修改1个字节，所得到的MD5值都有很大区别。
     4、强抗碰撞：已知原数据和其MD5值，想找到一个具有相同MD5值的数据（即伪造数据）是非常困难的
     
     YYYY是以周为单位计算的，如果一周结束后剩下的几天就会计算到下一年中。yyyy更精确
     
     -- 0105
     内存屏障：CPU或者编译器在对内存进行操作的时候，严格按照一定的顺序来执行，不会由于系统优化等原因而导致乱序
     volatile在C/C++和Java含义不同：
     C/C++：告诉编译器不要进行优化
     Java：可以看作是一种轻量级的同步，会增加一个内存屏障，修饰的变量在被修改后会立即同步到主内存，每次用之前都从主内存刷新
     volatile只能作用于属性，属性的读写操作都是无锁的
     volatile并不保证原子性，volatile仅仅用来保证该变量对所有线程的可见性
     
     -- 0106
     预审: https://center.effirst.com/login?appId=yanshu
     
     -- 0107
     https://www.appcoda.com/learnswift/
     
     防抓包：https://www.jianshu.com/p/4682aecf162d / https://www.jianshu.com/p/4682aecf162d
     1. 判断当前是否设置了代理，如果设置了代理，不允许进行访问
     2. 客户端本地做证书校验
     3. 对返回数据进行加密
     
     -- 0111
     responder chain:
     事件的传递是从上到下 UIApplication(Events) -> UIWindow -> UIView? -> subViews(hit-test/pointInside找到第一响应者)，
     事件的响应是从下到上 touches方法 -> 将事件交给上一个响应者进行处理 -> UIWindow -> UIApplication(不能处理该事件，则被丢弃)
     https://www.cnblogs.com/iOS-mt/p/4197256.html
     https://www.jianshu.com/p/3d0e8b8586f6
     https://juejin.cn/post/6905914367171100680
     
     https://xiaozhuanlan.com/olddriver-selection
     
     -- 0131
     仅当列表是有序的时候，二分查找才管用
     树是特殊的图，没有往后指的边
     
     -- 0201
     algorithm article: https://mp.weixin.qq.com/s/MArPUE8wmDNMAalvzoLgcA
     寄存器/内存：https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485211&idx=1&sn=a4b551f22d04fe04928068ac3f8af2cb&scene=21#wechat_redirect
     SQL:https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485346&idx=1&sn=22b36c3bdcca070adb2cac0ce3bc4ace&scene=21#wechat_redirect
     IP：https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485141&idx=1&sn=4f809c29c74277d65e664b745acf4e38&scene=21#wechat_redirect
     0.0.0.0:https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485168&idx=1&sn=98798922c2a2b30e9c9117f0d0f7331e&scene=21#wechat_redirect
     SQL执行慢: https://mp.weixin.qq.com/s?__biz=Mzg2NzA4MTkxNQ==&mid=2247485346&idx=1&sn=22b36c3bdcca070adb2cac0ce3bc4ace&chksm=ce404c76f937c56018c4da7f0844357e3daeffb414def5dbc0cc8522dbed76f40b9e9577c805&scene=21#wechat_redirect
     
     -- 0202
     映射(map)：将一个数组转换成另一个数组
     归并(reduce)：将一个数组转换为一个元素 / WMZDropDownMenu
     
     -- 0210
     Simulator notification: 
     xcrun simctl push <device> com.example.my-app playload.apns
     xcrun simctl ui <device> appearance dark
     https://www.avanderlee.com/workflow/testing-push-notifications-ios-simulator/
     https://sarunw.com/posts/testing-remote-push-notification-in-ios-simulator/
     
     -- 0213
     如果一个算法的时间复杂度为O(n平方)，它最大能处理大约为10的4次方的数据，当接近5次方时会超时
     
     -- 0221
     启动：http://www.cocoachina.com/articles/896633?filter=rec
      http://lingyuncxb.com/2018/01/30/iOS%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96/
          https://www.jianshu.com/p/229dd6190b95
     dyld: https://juejin.im/post/5e4b7b01f265da57301bece8
           http://roadmap.isylar.com/iOS/Knowledge/Dyld.html
     
     加载plist(解析配置信息) -> 创建沙盒 -> 检查权限状态 -> 加载Mach-O文件(读取dyld) ->
     dyld会寻找合适的CPU运行环境 -> 运行依赖库和自己的.h/.m文件编译成的.o可执行文件，并进行链接 -> 加载方法runtime初始化 -> 加载C函数/category扩展 -> 加载C++静态函数，加载+load -> dyld返回main函数地址，main函数被调用
     
     dyld: 配置环境变量 -> 加载共享缓存 -> 实例化主程序 -> 加载动态库 -> 链接动态库
     
     main函数: 创建UIApplication对象 -> 创建UIApplication的delegate -> 创建MainRunloop -> delegate对象开始处理/监听事件 -> 根据plist加载storyboard(如有) -> 程序加载完毕调用didFinishLaunchingWithOptions方法，创建UIWindow，设置rootViewController -> 显示第一个窗口
     
     -- 0301
     优化：http://www.cocoachina.com/articles/896783?filter=rec
     
     -- 0303
     Instruments Leaks: https://www.wangquanwei.com/63.html
     
     -- 0304
     隐式动画/面试： https://juejin.im/post/5e43ab846fb9a07c7e3d87e2
     底层面试： https://juejin.im/post/5e61f04c6fb9a07cab3aa518
     swift面试： https://juejin.cn/post/6844904085095710734
                https://juejin.cn/post/6844904087197073415
     
     -- 0307
     StringInterpolation: https://swift.gg/2019/10/18/swift5-stringinterpolation-part2/
     https://swift.gg/2019/06/24/sequence-head-tail/
     
     -- 0312
     计算机基础：https://mp.weixin.qq.com/s/yyZZ2VMb40TSZXRLUnofIA
     iOS技术栈：https://juejin.im/post/5e6b4777518825493038de5a
     面试：https://juejin.im/post/5e687e76e51d4526ed66c5c2
          https://juejin.im/post/5e707540f265da57455b5f70
          https://juejin.im/post/5e706fb8518825490455f1f6
          https://juejin.im/post/5e75aba6e51d4526d71d6558
          https://juejin.im/post/5e7da7c1e51d4546d83af63d
          https://www.jianshu.com/p/9eb3d9db1f3f
     
          https://www.jianshu.com/p/e709fde38de3
     
     -- 0316
     https://service.tp-link.com.cn/detail_article_763.html
     非对称加密：https://code.imerc.cc/2017/06/20/about-asymmetric-encryption/
     加密：公钥加密 -> 私钥解密
     数字签名 私钥加密 -> 公钥解密
     
     -- 0318
     Swift 5: Int isMultiple(of:) 判断数字是否是另一个的倍数
     Swift 5.1: https://seinf.mobi/2019/08/06/swift-what-new-in-swift5/
     core animation:  https://wiki.jikexueyuan.com/project/ios-core-animation/layer-properties.html
     
     -- 0322
     NSURLSession/分片上传: https://mp.weixin.qq.com/s/s-6s4eSioCoL9Es5nBcOvg
     
     -- 0325
     optional.map{}
     lock: objc_sync_enter(lockObj) / objc_sync_exit(lockObj)
     literal: ExpressibleByIntegerLiteral / ExpressibleByArrayLiteral...
     多元组交换: (a, b) = (b, a)
     DNS: 主机名->IP地址转换的目录服务
     
     -- 0328
     H264结构: https://juejin.cn/post/6844903566209990669
              http://gavinxyj.com/2017/03/30/h264-protocol/
     https://www.desgard.com/iOS-Source-Probe/Objective-C/Runtime/%E6%B5%85%E8%B0%88Associated%20Objects.html
     
     -- 0331
     引用计数要么存放在isa的extra_rc中，要么存放在引用计数表中，而引用计数表包含在 SideTable中，SideTable又包含在全局的 StripeMap哈希映射表中，这个表的名字叫SideTables
     https://www.jianshu.com/p/c3f1b0797517
     
     GCD有一个底层线程池，池中存放的是一个个线程，这些线程是可以复用的。当任务出队后，线程池提供一个线程供任务执行，执行完毕线程再回到线程池
     
     -- 0401
     断点续传: https://www.ibm.com/developerworks/cn/mobile/mo-cn-breakpoint/index.html
             https://juejin.cn/post/6974332195280257061
             https://www.cnblogs.com/sundaysgarden/p/10524095.html
     
     -- 0413
     内存: https://juejin.im/post/6844904119723884551
     GCD: https://juejin.im/post/6844904122068500487
     swift lazy var可能导致Thread Sanitizer/https://www.avanderlee.com/swift/thread-sanitizer-data-races/
     
     -- 0416
     blog: https://blog.devorz.com/
    
     swift closure [weak self]: depends on whether you want self to retained until the closure is called.
     https://stackoverflow.com/questions/41991467/where-does-the-weak-self-go
     https://stackoverflow.com/questions/21987067/using-weak-self-in-dispatch-async-function
     
     -- 0417
     DispatchQueue.main.asyncAfter，闭包强引用了控制器，如果闭包不释放，控制器就不会释放，控制器的生命被延续，浪费了资源
     传入async方法的闭包是会逃逸的，如果不使用weak，会使被捕获的对象延迟释放
     
     protocol方法派发: https://zhuanlan.zhihu.com/p/80577816
     协议中定义的方法，是动态调用的(放在virtual table里)，未定义的方法，仅出现在Extension中，是静态调用，这个方法属于协议，不属于协议的遵从者
     
     WKWebView坑: https://zhuanlan.zhihu.com/p/24990222
     
     -- 0421
     深度优先遍历/广度优先遍历: https://www.jianshu.com/p/5c676d76f3a3
     
     -- 0423
     CPU/disk: 资源调度，磁盘读写，内存申请和清理
     优化: https://juejin.cn/post/6844904131941892110
     
     -- 0427
     面试题: https://juejin.cn/post/6844904142368931853
     
     -- 0504/05
     Swift编译: https://juejin.cn/post/6844904144512221198
     https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode
     
     block: https://juejin.im/post/5eaa2a87e51d454db7436726
     
     Runtime: fastpath()为1的概率大，slowpath为0的概率大，允许程序员将最可能执行的分支告诉编译器，从而避免跳转语句，提高CPU执行效率
     
     blog: https://jinxuebin.cn/#blog
     load/initialize: https://juejin.im/post/5d204a9af265da1b6e65c431#heading-18
     
     -- 0506
     self/super: https://www.jianshu.com/p/15fa5e84c897
     当 发送 class 消息 时不管是 self 还是 super 其消息主体依然是 self ,也就是说 self 和 super 指向的是同一个对象。只是 查找方法的位置 区别，一个从本类，一个从本类的父类
     self the starting point is determined dynamically, in the super case it is known at compile time
     
     -- 0515
     https://zhuanlan.zhihu.com/p/39271268
     静态库：程序编译时链接到目标代码中，.a和.framework为文件后缀名，.a + .h + sourceFile = .framework
     动态库：运行时才被载入，.tbd(之前叫.dylib) 和 .framework
     
     CATiledLayer：分块处理大图的加载，减小内存
     
     -- 0523
     当触发事件后，IOKit.framework生成一个 IOHIDEvent事件，会将事件封装成IOHIDEvents对象，接着用mach port转发给需要的App进程，随后Source1就会接收IOHIDEvent，之后再回调__IOHIDEventSystemClientQueueCallback()，回调内触发Source0，Source0再触发_UIApplicationHandleEventQueue()
     
     -- 0525
     object_getClass(obj)：返回的是指向obj中的isa指针
     [obj class]：obj为实例对象时，返回指向obj中的isa指针；当obj为类对象时，返回的结果为其本身
     
     -- 0709
     popLast() / removeLast(): 原collection值改变 (var修饰)
     popLast() returns an optional, so it can be nil; removeLast() returns the last element, not optional, so it will crash if the array is empty
     https://stackoverflow.com/questions/41253723/what-is-the-difference-between-removelast-and-poplast-methods-of-array-in-sw
     dropFirst() 原collection值不变 (let修饰)
     
     AsyncDisplayKit/Texture: https://zhuanlan.zhihu.com/p/25371361
     占用CPU时间的元凶: 渲染、布局、对象的创建和销毁
     
     AsyncDisplayKit渲染过程：
     ~ 初始化 ASDisplayNode 对应的 UIView 或者 CALayer；
     ~ 在当前视图进入视图层级时执行 setNeedsDisplay；
     ~ display 方法执行时，向后台线程派发绘制事务；
     ~ 注册成为 RunLoop 观察者，在每个 RunLoop 结束时回调。
     
     
     FDTemplateLayoutCell 原理
     UICollectionViewDiffableDataSource
     
     
     -- 0730
     网站301重定向原因：防止网站权重和流量流失 / 降低对SEO造成影响
     
     -- 0805
     多线程： https://juejin.im/post/6844903588930519047#heading-17
     
     DispatchTime vs DispatchWallTime
     https://stackoverflow.com/questions/51863940/what-does-dispatchwalltime-do-on-ios
     
     -- 0819
     github docs: https://docs.github.com/cn
     
     -- 0820
     APNs: 1. the app registers for push notifications
           2. the app receives the device token
           3. the app send the token to your server
           4. your server sends a push notification to APNs server
           5. APNs sends the push notification to your app
     
     -- 0827
     ios9在使用方法ViewController()实例化时，会默认加载同名ViewController.xib
     
     -- 0901
     Swift protocol optional func:   (https://juejin.im/post/6844903847463403533)
     https://stackoverflow.com/questions/24032754/how-to-define-optional-methods-in-swift-protocol
     1. 使用 @objc optional，限制了protocol的功能，只有继承自 NSObject 的类才能遵守该协议 / 还要每次判断是否实现了方法
     2. 使用 extension，默认实现，对于有返回值的函数，需要返回一个合适的默认值，并不总是可行的 / 无法区分是否提供了默认实现
     
     -- 0902
     Podfile使用use_frameworks! -> dynamic frameworks 方式 -> 生成.framework文件
     不使用use_frameworks! -> static libraries 方式 -> 生成.a文件
     
     对于for循环，continue语句后自增语句仍会执行，对于 while 和 do...while 循环，continue语句重新执行条件判断语句
     
     -- 0904
     体验优化: https://zhuanlan.zhihu.com/p/192727235
     Xcode build: https://chaosky.tech/2020/04/20/optimize-xcode-build-time/
     
     -- 0908
     protocol var property {get}:
     https://stackoverflow.com/questions/54144063/swift-protocols-difference-between-get-and-get-set-with-concrete-exampl
     
     The mutating keyword is only used by structures and enumerations
     
     Swift Method Dispatch: https://gpake.github.io/2019/02/11/swiftMethodDispatchBrief/
     http://chuquan.me/2020/04/20/implementing-swift-generic/
     
     -- 0909
     Objective-C -> Swift:  （小专栏10680）
     指定构造器加上 NS_DESIGNATED_INITIALIZER
     .h init方法用 NS_UNAVAILABLE 声明，不会被继承
     
     -- 0910
     AudioSession: https://www.sunyazhou.com/2018/01/12/20180112AVAudioSession-Category/
     
     -- 0927
     文字末尾显示展开: https://blog.csdn.net/u014084081/article/details/107080322
     
     -- 1009
     Swift String:  https://sarunw.com/posts/different-ways-to-check-string-suffix-in-swift/
     
     -- 1014
     Tools: https://ai-chan.top/2020/06/07/iOS-debug-tools/
     
     -- 1021
     UserDefaults: The value that is set through register(defaults:) method isn't actually written to disk until you explicitly set it with set(_:forKey:).. That means you need to call register(defaults:) each time your application starts to get the right behavior.
     https://sarunw.com/posts/setting-default-value-for-nsuserdefaults/
     
     n & 1 == 0，判断偶数(更快 =1为奇数)
     
     -- 1022
     打包framework: https://juejin.im/post/6844903935866601485 / https://www.jianshu.com/p/957d38b65b23
     
     -- 1023
     /*
     let decoder = JSONDecoder()
     decoder.keyDecodingStrategy = .convertFromSnakeCase
     decode "total_visitors" -> totalVisitors
     */
     
     后台保活：https://juejin.cn/post/6844904041680470023#heading-9
     flutter混合开发：https://juejin.cn/post/6844904087918477320
                    https://juejin.cn/post/6844904000211386375
     
     altool: https://juejin.cn/post/6934517482791272456
     
     -- 21/03/04
     runloop: http://www.devzhang.cn/2019/12/01/Runloop/
     
     -- 03-11
     函数防抖：在事件触发n秒后再执行回调，如果在这n秒内再次触发，则重新计时
     函数节流：每隔一段时间，只执行一次函数
     
     -- 03-31
     面试：https://juejin.cn/post/6899689319809286158
          https://juejin.cn/post/6939308864240254984
          https://juejin.cn/post/6844903615157501965
          https://juejin.cn/post/6904834156740657159
          https://juejin.cn/post/6844904064937902094
     
     并发编程: https://juejin.cn/post/6844903618781380621#heading-30
     
     函数响应式编程(FRP Functional Reactive Programming)
     https://www.jianshu.com/p/723bf9457d4b
     
     swift影响编译时间：字符串拼接、强转，提前计算
     
     资料： https://juejin.cn/post/6958760289223327780
     
     05-18
     https://www.swiftbysundell.com/articles/mixing-enums-with-other-swift-types/
     
     ASWebAuthenticationSession:  https://mp.weixin.qq.com/s/QUiiCKJObfDPKWCvxAg5nQ
     
     https://www.swiftbysundell.com/articles/ignoring-invalid-json-elements-codable/
     https://www.swiftbysundell.com/questions/array-with-mixed-types/
     https://www.swiftbysundell.com/articles/reducers-in-swift/
     https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
     https://www.swiftbysundell.com/tips/the-power-of-key-paths/
     
     05-21
     埋点：https://juejin.cn/post/6926065299418513415
          https://juejin.cn/post/6844903811786473479
     
     05-26
     https://swift.org/blog/iuo/
     
     06-09
     WKWebView cookie: https://juejin.cn/post/6971401336705253384
     blog: https://zhangferry.com/archives/
     
     06-15
     https://medium.com/flawless-app-stories/archive
     https://medium.com/topic/ios-development
     UIBUtton add target: https://juejin.cn/post/6970616471898554381
     
     06-21
     动态库懒加载：https://mp.weixin.qq.com/s/g5FKnOcW6KonqBSW8XO9Jw
     
     06-23
     CryptoKit: http://www.cocoachina.com/articles/899342
     
     07-06
     ipa: https://juejin.cn/post/6970958512557916190
     
     https://blog.mzying.com/index.php/archives/52/comment-page-1
     
     07-22
     Codable-dictionary:
     https://adamrackis.dev/blog/swift-codable-any
     https://www.fivestars.blog/articles/codable-swift-dictionaries/
     https://dev.to/absoftware/how-to-make-swift-s-string-any-decodable-5c6n
     http://blog.danthought.com/programming/2020/06/30/advance-swift-encode-decode/
     https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift
     https://swift.gg/2018/10/11/friday-qa-2017-12-08-type-erasure-in-swift/
     https://grapeup.com/blog/variable-key-names-for-codable-objects-how-to-make-swift-codable-protocol-even-more-useful/
     https://medium.com/makingtuenti/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d
     https://lostmoa.com/blog/CodableConformanceForSwiftEnumsWithMultipleAssociatedValuesOfDifferentTypes/
     https://kaitlin.dev/files/encoder_decoder_slides.pdf
     https://juejin.cn/post/6844903894733062152
     https://www.jianshu.com/p/15c42c06dc86
     
     Swift提高代码质量: https://juejin.cn/post/6984768684250120222#heading-26
     
     07-26
     https://nemocdz.github.io/post/apple-官方异步编程框架swift-combine-应用/
     https://www.swiftbysundell.com/questions/array-with-mixed-types/
     
     08-02
     技术总结：http://roadmap.isylar.com/iOS/ReadME.html
     
     blog: https://mobdevgroup.com/platform/ios/blog
           https://www.cnblogs.com/mustard22/articles/11318436.html
     
     08-05
     localizedStandardContains
     https://sarunw.com/posts/different-ways-to-check-if-string-contains-another-string-in-swift/
     https://sarunw.com/posts/easy-way-to-detect-retain-cycle-in-view-controller/
     https://sarunw.com/posts/print-unescaped-string/
     https://sarunw.com/posts/how-to-change-back-button-image/
     
     08-09
     preconditionFailure(): https://www.swiftbysundell.com/articles/picking-the-right-way-of-failing-in-swift/
     
     iOS15: https://www.jianshu.com/p/39c529cbedc3
     get top controller: https://gist.github.com/snikch/3661188
     
     08-18
     https://stackoverflow.com/questions/19332283/detecting-taps-on-attributed-text-in-a-uitextview-in-ios/44226491#44226491
     编译优化：https://juejin.cn/post/6988711943905214478
     热重载：https://juejin.cn/post/6990285526901522463/
     
     08-23
     GCD efficient: https://gist.github.com/tclementdev/6af616354912b0347cdf6db159c37057
                    https://juejin.cn/post/6844903766701916168
     
     https://swiftrocks.com/useful-global-swift-functions (https://rockbruno.com)
     
     08-27
     iOS14 UTType: https://serialcoder.dev/text-tutorials/swift-tutorials/getting-local-files-type-identifier-from-url/#:~:text=In%20iOS%2014%20there’s%20a%20new%20structure%20to,identifier%20public.mp3%2C%20conforms%20to%20the%20following%20other%20types%3A
     
     08-30
     CollectionofOne: https://swiftrocks.com/faster-swift-array-operations-with-collectionofone#:~:text=CollectionOfOne%20is%20a%20type%20inside%20the%20Swift%20Standard,Let%27s%20check%20out%20why.%20Operating%20on%20single%20elements
     
     backgroundtasks: https://developer.apple.com/documentation/backgroundtasks/refreshing_and_maintaining_your_app_using_background_tasks
     
     09-14
     TaggedPointer: https://juejin.cn/post/7006132113258840100
     
     10-18
     iOS15 AttributedString: https://mp.weixin.qq.com/s/4P8hX7WoBUeUtvBOS4Tx7g
     
     11-29
     Alamofire: https://juejin.cn/post/6875140053635432462
     
     浮点类型精度问题：https://juejin.cn/post/7047767024931438605
     
     2022-01-21
     
     01-24
     tool: https://github.com/yagiz/Bagel
     
     01-25
     正则网站：https://regex101.com/
     https://juejin.cn/post/6844903894066151431
     
     01-26
     Swift doc: https://swift.bootcss.com/02_language_guide/21_Protocols
     
     02-17
     Xcode MemGraph:
     https://rderik.com/blog/using-xcode-s-visual-debugger-and-instruments-modules-to-prevent-memory-overuse/#:~:text=When%20you%20run%20your%20app%20on%20Xcode%2C%20you,it%20and%20analyze%20it%20later%20if%20you%20want.
     
     02-25
     Swift编写CLI工具：https://mp.weixin.qq.com/s/tX8LPjmGLEV9IT1_smMQBw
     xcodebuild命令：https://www.cnblogs.com/liuluoxing/p/8622108.html
     
     03-30
     Swift内存模型：https://juejin.cn/post/6844903477861171207
     
     04-21
     blog: https://kean.blog/post/learn-ios
     Stanford课程: https://cs193p.sites.stanford.edu
     
     05-05
     Xcode-Configuration Setting File: https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/建立方便大家安裝到手機的-xcode-專案-搭配-xcconfig-team-id-fb072ed08b2f
     
     05-07
     正则: https://digitalbunker.dev/regex-with-xcode-in-10-minutes/
     
     06-09
     Swift指针: https://juejin.cn/post/7106157896521482271
     SwiftLint: https://www.hackingwithswift.com/articles/97/how-to-clean-up-your-code-formatting-with-swiftlint
     https://xuebaonline.com/在iOS工程中Swift代码进行约束保持团队内部代码风格一致性的实践/
     https://www.kodeco.com/38422105-swiftlint-in-depth
     
     判断是否在范围内 ~=
     let number = 3
     if 1...5 ~= number {}
     
     storyboard & xib -> lock(All Properties)
     https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-16-texteditor-uitextview-的-find-and-replace-8617d605eb71
     
     07-25
     单位换算: https://holyswift.app/using-native-swift-to-make-units-conversions
     
     07-29
     Xcode scheme: https://www.jianshu.com/p/fd505b7900e1
     
     08-10
     正则: https://www.cnblogs.com/wgb1234/p/12426085.html
          https://useyourloaf.com/blog/getting-started-with-swift-regex/
     
     10-10
     命令打包问题: https://zhuanlan.zhihu.com/p/358592676
     
     2023-01-16
     "".applyingTransform 文字转拼音
     StringTransform("Hant-Hans") 繁简转换
     
     断点下载：https://help.aliyun.com/document_detail/101673.html
     
     Swift5.4 @resultBuilder：https://swiftsenpai.com/swift/section-snapshot-builder/
     
     KeyValuePairs：当您需要键值对的有序集合并且不需要 Dictionary 类型提供的快速键查找时，请使用 KeyValuePairs 实例(允许重复键，保留传递的元素顺序)
     
     05-06
     assertionFailure()，结束app，release不执行
     
     06-08
     高频使用的正则表达式: https://projects.lukehaas.me/regexhub/?
     
     06-12
     dump(T) 可以打印更多有用的信息
     
     07-31
     collection.lazy
     
     swift编码规范：https://iweiyun.github.io/2019/01/09/weiyun-swift-style/
     空集合，无法判断有效类型 arr = [Int](), arr is [String] //true
     
     系统文件：https://www.appcoda.com/files-app-integration/
     
     */
}

extension ZLDiary {
    //MARK: - async/await
    
    /*
     https://www.swiftwithvincent.com/blog/three-mistakes-to-avoid-with-async-await-in-swift
     3 mistake to avoid with async/await
     #01 - Not running code concurrently when possible
     #02 - Not understanding that `Task` automatically captures `self`
     #03 - Using `Task.detached` when not needed
     */
}

extension ZLDiary {
    //MARK: - SwiftUI
    
    /*
     教程：https://goswiftui.com/swiftui-view-layout-and-presentation/
     
     Store/Action/Reducer
     1. 将app作为一个状态机，状态决定用户界面
     2. 这些状态保存在一个Store对象中，被称为State
     3. View不能直接操作State，只能通过发送Action的方式，间接改变存储在Store中的State
     4. Reducer接受原有的State和发送过来的Action，生成新的State
     5. 用新的State替换Store中原有的State，并用新State来驱动界面更新
     
     
     @ObservedObject：不管存储，会随着view的创建被多次创建
     @StateObject：保证对象只会被创建一次
     
     @State：对于 @State 修饰的属性的访问，只能发生在 body 或者 body 所调用的方法中。你不能在外部改变 @State 的值，它的所有相关操作和状态改变都应该是和当前 View 挂钩的
     @Binding：对被声明为 @Binding 的属性进行赋值，改变的将不是属性本身，而是它的引用，这个改变将被向外传递
     
     Combine: 事件发布(Publisher) -> 操作(Operator) -> 订阅(Subscriber)
     一个事件及其对应的数据被发布出来，通过一系列的操作变形，成为我们最终需要的事件和数据，最后被订阅者消化和使用，
     */
}

extension ZLDiary {
    //MARK: - blog
    
    /*
     https://coldstone.fun
     https://draveness.me
     http://www.samirchen.com
     https://www.desgard.com/
     https://www.desgard.com/iOS-Source-Probe/
     https://harryyan.github.io/
     https://kemchenj.github.io/archives/
     https://gpake.github.io/archives/
     https://awhisper.github.io/ (404)
     https://liujunmin.com/archives/
     http://blog.cnbang.net/tech/3386/
     https://savvyapps.com/blog/swift-tips-for-developers (找不到服务器)
     http://zxfcumtcs.github.io/archives/
     https://blog.chenyalun.com
     http://www.devzhang.cn/
     https://satanwoo.github.io/archives/
     https://kaaaaai.cn/archives/
     http://www.otao.me/tabs/archives/
     https://poos.github.io
     http://djs66256.github.io
     https://a1049145827.github.io/
     https://sketchk.xyz
     https://github.com/RickeyBoy/Rickey-iOS-Notes
     http://chuquan.me/archives/
     http://shevakuilin.com/page/2/
     https://junyixie.github.io/archives/
     https://zhangbuhuai.com
     https://swiftsenpai.com/swift
     https://blog.jerrychu.top/archives/
     https://www.hanleylee.com/archives/
     https://ryukiedev.gitbook.io/wiki/swift
     https://useyourloaf.com/archives/
     https://gewill.org/archives/
     https://digitalbunker.dev
     https://eisel.me/
     https://apppeterpan.medium.com
     
     https://steppark.net/archives.html
     https://huberyyang.com
     http://www.lymanli.com
     http://www.veryitman.com/
     https://www.cnblogs.com/mustard22/articles/11318436.html
     
     https://www.kodeco.com/ios/articles
     https://iweiyun.github.io/archives/
     
     Swift笔记：https://www.kancloud.cn/curder/swift/406013
     https://swiftui.cc
     
     website:
     https://www.swiftbysundell.com/articles/
     https://sarunw.com/tags/swift/
     https://www.avanderlee.com
     https://sarunw.com/posts/
     https://xiaozhuanlan.com/wwdc22
     https://swiftsenpai.com
     https://serialcoder.dev/category/text-tutorials/swift-tutorials/
     https://www.polpiella.dev
     https://ampersandsoftworks.com
     https://mp.weixin.qq.com/s/TXynmzf6u-JVG1ezENg53g
     
     https://blog.eidinger.info
     https://www.vadimbulavin.com
     https://www.swiftwithvincent.com
     
     https://daily-blog.chlinlearn.top/blogs/1
     https://ohmyswift.com/blog/archives/
     https://douglashill.co/archive/
     
     */
}

extension ZLDiary {
    //MARK: - Flutter
    /*
     
     知识点总结：https://juejin.cn/post/6990216098587246628
     http://laomengit.com/guide/widgets/NestedScrollView.html
     控件大全：http://laomengit.com/flutter/widgets/widgets_structure.html
     
     book: https://www.bookstack.cn/read/flutter-cookbook-zh/e8f564cf42cec8e1.md
     http://gityuan.com/2019/06/15/flutter_ui_draw/
     
     渲染：https://juejin.cn/post/6938693559004430350
     https://mp.weixin.qq.com/s/dF5Id3w_To4aXeXDbUnUjQ
     渲染：
     Flutter的Framewrok在启动初始化后主要构建了四颗树Widget、Element、RenderObject和Layer。然后在系统Vsync的驱动下，通过它们的改变生成出绘制每一帧画面的数据，然后显示到屏幕上
     
     Widget与Element：
     1. Framework调用Widget.createElement创建Element实例(element)
     2. Framework调用element.mount()方法，mount方法首先调用element对应的Widget的 createRenderObject方法，创建于element关联的RenderObject对象，然后调用element.attachRenderObject方法将element.renderObject添加到渲染树中指定位置(这一步不是必须的，一般发生在Element树结构发生变化时才需要重新attach)，插入到渲染树后的element处于active状态，就可以显示在屏幕上了
     3. 当有父Widget的配置数据改变时，此时需要重新构建Element树，为了进行复用，Element重新构建前会尝试是否可以复用旧树上相同位置的element，element节点在更新前都会调用其对应Widget的canUpdate方法，为true则复用旧Element，反之创建一个新Element。Widget.canUpdate主要是判断新旧Widget的runtimeType和Key是否相同
     4.
     
     ～从创建到渲染的大体流程：根据Widget生成Element，然后创建对应的RenderObject并关联到Element.renderObject属性上，最后再通过RenderObject完成布局排列和绘制
     ～Element就是Widget在UI树具体位置的一个实例化对象，大多数Emelent只有唯一的renderObject，但还有一些Emelent有多个子节点，如继承RenderObjectElement的一些类
     ～Element树根据Widget树生成，而渲染树又依赖于Element树，最终的UI树其实就是由一个个独立的Element节点构成
     ～Element同时持有Widget和RenderObject对象，Element负责Widget的渲染逻辑，同时决定要不要把 RenderObject实例 attach 到 Render Tree 上，只有 attach 到 Render Tree 上，才会被真正的渲染到屏幕
     
     https://zhuanlan.zhihu.com/p/36577285
     Widget：存放渲染内容，视图布局信息
     Element：存放上下文，同时持有Widget和RenderObjec
     RenderObject：根据Widget的布局属性进行layout，paint Widget传入的内容
     
     Flutter HotReload过程：
     · 扫描代码，根据修改时间找到上次编译后有变化的Dart代码
     · 将有变化的Dart代码转为增量Dart kernel文件
     · 将增量Dart kernel文件发送到运行设备的Dart VM 虚拟机
     · 将Dart kernel与源Dart kernel合并，通知Flutter Framework重新构建Widget(会保留Flutter之前的状态)
     Flutter framework中BindingBase注册了名为reassemble的Dart VM服务，用于外部与正在运行的Dart VM通信，能够触发根节点树重建操作
     
     Flutter HotReload不支持的场景：
     · 代码出现编译错误
     · Widget状态变更
     · 全局变量和静态属性的更改
     · initState方法里的更改
     · 枚举和泛型类型更改
     · main方法代码更改
     
     Flutter布局约束：
     1. 上层widget向下层widget传递约束条件
     2. 下层widget向上层widget传递大小信息
     3. 上层widget决定下层widget位置
     
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       ZLToast.showLoadingText();
     });
     
     There are multiple heroes that share the same tag within a subtree，在ListView里用需要注意加上index
     常见问题：https://mp.weixin.qq.com/s/snU-mNlmEnOUHw3I-DrJ_w
     
     //
     当我们访问 late 声明的对象时，如果对象还没有初始化，就会返回一个异常
     对于编译后的代码，typedef 并不会对性能和运行结果产生影响
     
     Dart-Isolate: https://www.jiangkang.tech/2020/11/25/flutter/dart-zhong-de-isolate/
                   https://www.psvmc.cn/article/2020-08-08-flutter-isolate.html
     
     异步和多线程：https://juejin.cn/post/7039115158261596191
     ~ 任务执行事件很短的，比如几十毫秒以内的建议用 Future
     ~ 任务执行时间长，只有一次返回的用compute，有多次返回的用Isolate
     
     setState是无法影响通过showDialog构建的UI
     
     ValueListenableBuilder: https://juejin.cn/post/6912206134078078990
     
     var objects = [1, 'a', 2, 'b', 3];
     var ints = objects.whereType<int>();
     
     2022-02-11
     setState无效：SimpleDialog()中的子组件默认是无状态的, 组件外部“套”一个StatefulBuilder组件即可
     setState流程：https://book.flutterchina.club/chapter14/flutter_app_startup.html
     
     03-02
     JsonToDart plugin: 右键：New—>JsonToDart
     JSON to Dart online: https://javiercbk.github.io/json_to_dart/
     
     03-09
     Flutter原理简介：https://www.cnblogs.com/awanglilong/p/14602420.html
     Page一般占用全部屏幕，是“全屏不透明的”， 弹窗一般只占用全部屏幕的一部分，是“全屏透明的”
     
     blog: https://xinbaos.github.io/archives/
     
     03-10
     Flutter并不是都在以每16.6ms产生一帧来布局绘制界面，当没有动画，或者不调起setState方法，或者不调ScheduleBinding.scheduleFrame关联的方法，Flutter并不好进行布局绘制和刷新界面。只能靠dart自身的事件循环
     
     初始化：https://www.cnblogs.com/lxlx1798/articles/11099164.html
     main() ->
     runApp() -> WidgetsFlutterBinding.ensureInitialized() -> WidgetsFlutterBinding初始化 -> BindingBase子类绑定各自实现(GestureBinding/ServicesBinding/SchedulerBinding/RendererBinding/WidgetsBinding) ->
     RendererBinding调用函数实例化了一个RenderView类(继承自RenderObject，render tree的根节点) - 调用addPersistentFrameCallback添加回调 ->
     
     runApp() -> scheduleAttachRootWidget(app) -> RenderObject需要有对应的Widget和Element与之关联
     
     runApp() -> scheduleWarmUpFrame() -> onBeginFrame()/onDrawFrame()回调
     
     03-16
     https://wizardforcel.gitbooks.io/gsyflutterbook/content/Flutter-5.html
     
     03-18
     blog: http://www.ptbird.cn/th-large.html
     
     */
    
    
    
    //MARK: - Flutter command
    /*
     
     flutter channel master
     flutter upgrade
     
     多环境配置：https://www.jianshu.com/p/ef86d6fafb25
     运行开发/生产版本
     flutter run -t lib / main_dev.dart
     flutter run -t lib / main_pro.dart
     
     flutter build apk -t lib / main_<environment> .dart
     flutter build ios -t lib / main_<environment> .dart
     */
    
    //MARK: - Android Studio
    /*
     commond + E   弹出最近打开的文件列表
     commond + D   复制当前行
     commond + Y   复制当前行
     commond + O   重写父类方法
     Shift + Shift    工作空间内全局搜索文件
     */
    
    //MARK: - VS Code
    /*
     快捷键：https://zhuanlan.zhihu.com/p/385837739
     Shift + Option + F         格式化代码
     Command+ Option + [ / ]    折叠/打开代码
     Shift + Option + Up/Down   向上/向下复制代码
     Command + d                选中单词
     Command + Shift +d         复制行
     Command + x                删除行
     Command + p                命令面板
     */
}

extension ZLDiary {
    //MARK: - Computer
    /*
     https://sportsnba.qq.com/team/list
     
     浏览器输入url到网页显示经历了什么过程：
     DNS解析，获取域名的web服务器的IP地址
     与web服务器建立TCP连接
     浏览器向web服务器发送请求
     web服务器响应请求，并返回指定url的数据
     浏览器下载返回的数据并解析html
     生成DOM(文档对象模型)树，解析css/js，渲染页面，直到显示完成
     
     
     //
     二进制数的值转换成十进制数的值，只需将二进制数的各数位的值和位权相乘，然后将相乘的结果相加
     有一些十进制数的小数无法转换成二进制数
     计算机无法直接处理循环小数
     
     
     ~ 地址隔离: 间接地址访问法：把程序给定的地址看作是一种虚拟地址，通过某种映射方法，将虚拟地址转换成实际的物理地址
       每个进程都有自己独立的虚拟空间，有效的做到了进程隔离
     
     ~ 内存使用效率: 分页
     ~ 运行地址不确定: 分段
     
     线程调度：优先级调度、轮转法
     automic: 单指令的操作，执行不会被打断
     
     -- 0423
     信号量：在整个系统可以被任意线程获取并释放
     互斥量：仅同时允许一个线程访问，哪个线程获取了互斥量，哪个线程就要负责释放这个锁
     临界区：作用范围仅限于本进程，其他进程无法获取改锁
     
     -- 0424
     预处理(Prepressing) - 编译(Compilation) - 汇编(Assembly) - 链接(Linking)
     编译过程：扫描 -> 语法分析 -> 生成语法树 -> 语义分析 -> 源代码优化 -> 代码生成 -> 目标代码优化
    
    预编译：处理以"#"开始的预编译指令，并且展开所有的宏定义(#include, #define)
     语法分析：对扫描产生的记号进行语法分析，从而产生语法树（可以根据用户给定的语法规则对输入的记号序列进行解析，从而构建出一颗语法树。对于不同的编程语言，编译器的开发者只须改变语法规则，而无需为每个编译器编写一个语法分析器）
     源代码优化：直接在语法树上作优化比较困难，所以源代码优化器往往将整个语法树转换成中间代码(Intermediate Code)，中间代码使得编译器可以被分为前端和后端。编译器前端负责产生机器无关的中间代码，后端将中间代码转换成目标机器代码，主要包括代码生成器和目标代码优化器
     
     目标文件：源代码编译后但未进行链接的中间文件
     
     -- 0425
     CPU：寄存器、控制器、运算器、时钟
     根据时钟信号，控制器会从内存中读取指令和数据，通过对这些指令加以解释和运行，运算器就会对数据进行运算，控制器根据运算结果来控制计算机
     
     机器语言指令的主要类型和功能：
     数据传送指令：寄存器和内存、内存和内存、寄存器和外围设备之间的数据读写操作
     运算指令：用累加寄存器执行算术、逻辑、比较和移位运算
     跳转指令：实现条件分支、循环、强制跳转等
     call/return指令：函数的调用/返回调用前的地址
     
     -- 0426
     操作系统（operating system）是指管理和控制计算机硬件与软件资源的计算机程序
     
     -- 0427
     计算机能处理的运算，大体分为算术运算和逻辑运算
     算术运算是指加减乘除四则运算，逻辑运算是指对二进制数各数字位的0和1分别进行处理的运算，包括逻辑非、逻辑与、逻辑或和逻辑异或
     逻辑非(!)：0 变成 1、1 变成 0 的取反操作
     逻辑与(&)：两个都是1时运算结果为1，其他情况都为0
     逻辑或(|)：至少有一方是1时，运算结果为1，其他情况都为0
     逻辑异或(^)：其中一方是1，另一方是0，运算结果为1，其他情况都为0
     
     — 0429
     扇区是磁盘保存数据的物理单位
     一般把输入装置、输出装置、存储器、运算器和控制器这5种部件设备成为计算机的5大部件
     
     磁盘缓存：把磁盘中读取的数据存储到内存空间中
     虚拟内存：把磁盘的一部分作为假想的内存使用
     
     -- 0502
     编程语言代码 - 编译 - 本地代码(机器语言) - 链接 - 可执行文件
     
     -- 0523
     头部是用来记录和交换控制信息的，TCP头部中发送方和接收方端口号可以找到要连接的套接字
     
     -- 0529
     TCP头部 -> 发送方和接收方端口号 -> 找到要连接的套接字 -> 通过序号和ACK号确认接收方是否收到了网络包
     路由器根据目标地址判断下一个路由器的位置
     路由器有一张IP协议的表，可根据IP头部记录的信息查出接下来应该发往哪个路由器
     集线器在子网中将网络包传输到下一个路由
     集线器里有一张表(用于以太网协议的表)，可根据以太网头部记录的目的信息查出相应的传输方向
     IP协议根据目标地址判断下一个IP转发设备的位置，子网中的以太网协议将网络包传输到下一个转发设备
     IP模块负责添加两个头部：MAC头部(以太网用的头部)，IP头部
     
     不需要重发的数据用UDP发送更高效，向DNS服务器查询IP地址的时候用的就是UDP协议
     
     -- 0530
     交换机内部有一张MAC地址与网线端口的对应表，通过这些信息判断应该把包转发到哪里
     网卡本身具有MAC地址，并通过核对收到的包的接收方MAC地址判断是不是发给自己的，不是则丢弃
     交换机的端口不核对接收方的MAC地址，而是直接接收所有的包并存放到缓冲区中，和网卡不同，交换机的端口不具有MAC地址
     交换机是通过MAC头部的接收方MAC地址来判断转发目标的，而路由器则是根据IP头部中的IP地址来判断的
     路由器的各个端口都具有MAC地址和IP地址
     给包加上MAC头部并发送，从本质上说就是将IP包装进以太网的数据包中，委托以太网去传输这些数据。IP协议本身没有传输包的功能，因此包的实际传输要委托以太网进行
     路由器是基于IP设计的，而交换机是基于以太网设计的，
     
     -- 0605
     所谓同步(synchronize)，是指在一个线程访问数据未结束的时候，其他线程不得对同一数据进行访问
     
     -- 0612
     链接过程：
     第一步 空间与地址分配 扫描所有的输入目标文件，并且获得它们各个段的长度、属性和位置，并且将输入文件中的符号表中所有的符号定义和符号引用收集起来，统一放到一个全局符号表
     第二步 符号解析与重定位 使用上面第一步收集到的信息，读取输入文件中段的信息、重定位信息，并且进行符号解析与重定位、调整代码中的的地址等
     
     -- 0615
     客户端与服务器区别：客户端是发起连接的一方，服务器是等待连接的一方
     
     -- 0617
     链接：操作系统会读取可执行文件的头部，检查文件的合法性，然后从头部中读取每个“segment”的虚拟地址，文件地址和属性，并将它们映射到进程虚拟空间的相应位置
     
     -- 0618
     动态链接基本步骤：
     启动动态链接器本身 - 装载所需要的共享对象 - 重定位和初始化
     
     -- 0620
     /lib：这个目录主要存放系统最关键和基础的共享库，是系统启动时需要的库
     /usr/lib： 这个目录下主要保存的是一些非系统运行时所需要的关键性的共享库，主要是一些开发时用到的共享库
     /usr/local/lib：这个目录主要用来放置一些跟操作系统本身不想关的库，主要是一些第三方应用程序的库
     
     -- 0626
     收到数据包时，TCP模块：
     1. 根据收到的包的发送方IP地址、发送方端口号、接收方IP地址、接收方端口号找到相对应的套接字
     2. 将数据块拼接起来并保存在接受缓冲区中
     3. 向客户端返回ACK
     
     -- 0629
     程序运行：创建进程 - 入口函数 - 对运行库和程序运行环境进行初始化(包括堆、I/O、线程、全局变量构造等等) - 调用main函数 - 入口函数(清理、全局变量析构、堆销毁等) - 进行系统调用结束进程
     
     -- 1116
     计算机主要存储部件是内存和磁盘，磁盘中存储的程序，需要加载到内存中才能运行
     因为负责解析和运行程序内容的CPU，需要内部程序计数器来指定内存地址，才能读出程序
     
     CLI(Command Line Interface)：命令行界面
     GUI(Graphical User Interface图形用户界面)：窗口的菜单及图表等都可以进行可视化操作的方式
     
     */
}
