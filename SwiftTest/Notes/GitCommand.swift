//
//  Gitcommand.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/9.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit

class Gitcommand: NSObject {
    
    private func Array_Sequence() {
        /*
         → 想要迭代除了第一个元素以外的数组其余部分?  for x in array.dropFirst()
         → 想要迭代除了最后 5 个元素以外的数组?  for x in array.dropLast(5)
         → 想要列举数组中的元素和对应的下标?  for (num, element) in collection.enumerated()
         → 想要寻找一个指定元素的位置?  if let idx = array.index { someMatchingLogic($0) }
         → 想要对数组中的所有元素进行变形?  array.map{someTransformation($0)}
         → 想要筛选出符合某个标准的元素?  array.flter { someCriteria($0) }
     
         Sequence:
         prefix & suffix -- 截取前或者后n个元素
         prefix(while:) -- 从前开始移除元素，直到while条件满足
         dropFirst & dropLast -- 返回移除一个或者最后一个元素的subSequence
         drop(while:) -- 从后开始移除，直到while条件满足
         split -- 以特定的元素进行分割
         */
    }

    private func terminalCommand() {
        /*
         //MARK: - File
         chflags hidden /Users/zhangliang/Documents/fileName 隐藏该文件(Shift+command+. 显示)
         
         //MARK: - SSH
         
         ssh-keygen -t rsa -C "zhangliangmac@163.com"
         ssh-keygen -t rsa -C "zhangliangmac@163.com" -f ~/.ssh/os_project
         ssh-add ~/.ssh/os_project
         cat ~/.ssh/os_project.pub
         ssh -T git@NewProject
         ssh -T git@gitee.com
         mkdir fileName
         
         cd ~/.ssh
         touch config
         
         ///
         Host MyProject
         HostName  code.csdn.net
         PreferredAuthEntications  publicly
         User  zlmac
         IdentityFile  ~/.ssh/os_socialGram
         ///
         
         
         //MARK: - iterm/zsh
         https://support.apple.com/zh-cn/guide/terminal/trmlshtcts/mac
         https://support.apple.com/zh-cn/guide/terminal/apd3cf6fe02-3ec8-48f1-951f-866e52955fc8/mac
         
         homebrew install: /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
         
         Oh My Zsh inatall: sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
         iterm/zsh:
             https://xiaozhou.net/learn-the-command-line-iterm-and-zsh-2017-06-23.html
             https://wuzhuti.cn/mac-use-iterm2-and-oh-my-zsh
             https://juejin.cn/post/7006526195420364836
         zsh plugin: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
         
         cd ~/.oh-my-zsh/themes && ls  //显示zsh主题名
         vim ~/.zshrc      //编辑zshrc
         source ~/.zshrc   //使zsh的配置立即生效
         
         brew install autojump
         brew install thefuck
         brew install tig (git log)
         命令行工具: https://xiaozhou.net/learn-the-command-line-tools-md-2018-10-11.html
         
         
         //MARK: - Xcode
         关闭崩溃报告弹框
         defaults write com.apple.CrashReporter DialogType none
         恢复崩溃报告弹框
         defaults write com.apple.CrashReporter DialogType crashreport
         
         xcode-select --print-path   打印当前xcode的路径
         sudo xcode-select -switch /Applications/Xcode10.app/Contents/Developer
         
         -- 找到Xcode应用程序的文件夹
         xcrun simctl get_app_container booted BundleID data  ///当前App在模拟器的文件目录
         open -a Finder <Path ↑↑↑>
         
         open `xcrun simctl get_app_container booted ` -a Finder
         xcrun simctl erase all  //删除模拟器
         
         xcrun swift -version //查看Swift版本
         xcrun --find swift
         
         -- 显示Xcode编译时间
         defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES
         
         
         //MARK: - xcodebuild
         /Users/zhangliang/Library/MobileDevice/Provisioning
         /usr/bin/security cms -D -i xxx..mobileprovision (获取Provisioning文件UUID)
         
         xcodebuild archive -scheme SUPVP -archivePath ~/Desktop/SUPVP.xcarchive
         xcodebuild archive -workspace SUPVP.xcworkspace -scheme SUPVP -configuration Debug/AdHoc/Release -archivePath ~/Desktop/SUPVP/SUPVP.xcarchive CODE_SIGN_IDENTITY=Apple Distribution: House730 Limited (2B3F85ZNPD) PROVISIONING_PROFILE=a001a44a-2d8c-434d-a6ab-0df8803457d2 (UUID)
         
         xcodebuild archive -project SUPVP.xcodeproj -scheme SUPVP -configuration Debug/AdHoc/Release -archivePath ~/Desktop/SUPVP/SUPVP.xcarchive CODE_SIGN_IDENTITY=Apple Distribution: House730 Limited (2B3F85ZNPD) PROVISIONING_PROFILE=a001a44a-2d8c-434d-a6ab-0df8803457d2 (UUID)
         
         xcodebuild -project SUPVP.xcodeproj -target SUPVP -configuration release -showBuildSettings
         
         
         xcodebuild -exportArchive -archivePath SUPVP.xcarchive -exportPath 2.2.1.ipa -exportOptionsPlist AdHocExportOptionsPlist.plist -allowProvisioningUpdates
         
         xcodebuild -exportArchive -archivePath /Users/zhangliang/Desktop/diyueArchive/uat-adhoc/diyue.xcarchive -exportPath ~/Desktop/diyueArchive/xcode10/uat-adhoc/diyue -exportOptionsPlist /Users/zhangliang/Desktop/diyueArchive/uat-adhoc/ExportOptions.plist
         
         Application Loader - altool: https://help.apple.com/itc/apploader/#/apdATD1E53-D1E1A1303-D1E53A1126
         
         //MARK: - Scheme 环境变量
         Edit Scheme → Run → Arguments
         // 代码里读取
         if ProcessInfo.processInfo.environment["IS_UI_TESTING"] == "1" {
             
         }
         
         //MARK: - rvm
         source ~/.rvm/scripts/rvm  载入 rvm
         source /Users/zhangliang/.rvm/scripts/rvm
         rvm use ruby-2.7.1   切换到指定 ruby 版本
         
         安装ruby失败：
         https://stackoverflow.com/questions/69510334/ruby-2-7-4-3-0-0-fails-on-macos-big-sur-11-2-3-undeclared-identifier-rsa-ss
         brew install openssl@3
         rvm install 3.2.2 --with-openssl-dir=$(brew --prefix openssl@3)
         
         //MARK: - curl
         登录拿到 token
         curl -X POST -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2470" -H "OSVersion: 16.2" -d '{"account": "542216109@qq.com", "password":"house730" }' "https://uatpmsapi.house730.com.cn/CompanyUser/PreLogin" -s | jq
         
         curl -X POST -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2470" -H "OSVersion: 16.2" -d '{"accountID": 15864, "departmentID":8443, "password": "house730"}' "https://uatpmsapi.house730.com.cn/CompanyUser/Login" -s | jq
         
         curl -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2470" -H "token: A15864_m:4e17f6ee3db54563be7e5477b69f7079" -H "OSVersion: 16.2" "https://uatpmsapi.house730.com.cn/CompanyUser/GetPopupMessage" -s | jq
         
         curl -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2480" -H "token: A15864_m:167e44aa2d374d27a7a8ca772e804b07" -H "OSVersion: 16.2" "https://uatpmsapi.house730.com.cn/Property/GetCompanyCofig" -s | jq
         
         curl -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2490" -H "token: A15864_m:17105532a75543b0a38ea4e4f7135477" -H "OSVersion: 16.4" "https://uatpmsapi.house730.com.cn/AppConfig/GetAppConfig?version=config_2510" -s | jq
         
         -- 生成json文件
         curl -H "Cookie: SERVERID=n1" -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2720" -H "token: A10770_m:fa45cfd5d2f243f5861cbc51c6d99b94" -H "OSVersion: 18.2" "https://pmsapi.house730.com/AppConfig/GetAppConfig?version=config_2520" -s | jq > json.text
         
         curl -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2620" -H "token: A35138_m:3d4010d47194417b979d43373fb45ced" -H "OSVersion: 17.2" "https://uatpmsapi.house730.com.cn/DictionaryInfo/SearchDictionaryInfo" -s | jq
         
         curl -X POST -H "Content-Type: application/json" -H "cityen: hk" -H "platform: app-ios" -H "language: zh-hk" -H "AppVersion: 2470" -H "token: A15864_m:da3d7b8b79f14d1d871c27e7e9cc3371" -H "OSVersion: 16.2" -d '{"pageIndex": 1, "pageCount":20 }' "https://uatpmsapi.house730.com.cn/Property/SearchPropertyDraft" -s | jq
         
         ////// ---- /////
         curl -X POST -d '_api_key=60f055a1938d1ec2c1f01818cfd774a6' -d 'appKey=776432020811a244e0e0e27019a85b72' https://www.pgyer.com/apiv2/app/builds -s | jq
         
         ---- pgyer upload
         /Users/zhangliang/Documents/pgyer_upload.sh -k 1b1d7c45c974847fecec6399ad51ebff /Users/zhangliang/Desktop/pms_adhoc/adhoc_ipa_2.5.30/PMS.ipa
         
         itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/{buildKey}
         
         //MARK: - httpie
         https://www.poloxue.com/mytermenv/docs/commands/dev/httpie/
         http GET http://httpbin.org/get name==poloxue age==18
         http POST http://httpbin.org/post name=poloxue age=18
         https httpie.io/hello
         
         //MARK: - hurl
         echo GET http://httpbin.org/get | hurl | jq
         hurl session.hurl
         
         //MARK: - other
         ----- file / application -----
         显示隐藏的文件
         defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder
         隐藏隐藏的文件
         defaults write com.apple.finder AppleShowAllFiles -boolean false ; killall Finder
         
         du -hs *  //获取当前目录下所有文件大小 ls -> du -d 1 -h
         find . -name '*.log' //查找以‘.log’结尾的文件
         
         control + u  //快速删除一行命令
         
         killall WeChat              //强制退出
         rm -R /Applications/QQ.app  //删除程序
         open -a wechat.app          //打开程序
         control + C                 //终止命令
         
         cd -   回到上一个目录
         cd ~   回到用户目录
         pwd    显示当前目录的路径名
         
         defaults write com.apple.screencapture type jpg  //默认截图保存为.jpg
         
         命令大全: https://www.macdaxue.com/macos-command/
         
         
         ----- other -----
         退出python命令行：control + d / exit() / quit()
         
         pip安装报错：-bash: pip: command not found ->
         运行: sudo easy_install pi，然后再运行：sudo pip install web.py
         
         sudo spctl –-master-disable  //允许安装其它来源的软件
         sudo spctl --master-enable   //不显示"任何来源"选项
         
         */
    }
    
    private func CocoaPodscommand() {
        /*
         platform :ios, ‘9.0’
         use_frameworks!
         target ‘SwiftTest’ do
         pod 'Alamofire', '~> 4.4'
         end
         
         
         cd /Users/zhangliang/Desktop
         
         CocoaPods 升级新版本问题:
         https://www.colabug.com/2019/1225/6769937/amp/
         
         
         rm -rf ~/.cocoapods
         mkdir -p ~/.cocoapods/repos
         cd ~/.cocoapods/repos
         git clone https://github.com/CocoaPods/Specs.git master
         git config --global http.postBuffer 524288000
         
         
         Cocoapods安装：https://www.jianshu.com/p/5c66c0c1ee87
         Cocoapods私有仓库：https://www.jianshu.com/p/0c640821b36f
         
         
         /// update pod version
         Execute the following on your terminal to get the latest stable version:
         sudo gem install cocoapods
         
         Add --pre to get the latest pre release:
         sudo gem install cocoapods --pre
         ///
         
         
         pod repo update 更新本地所有的repo信息
         pod spec cat GrowingCoreKit 查看当前kit的版本号
         
        
         -- 如果遇到pod install或者pod update慢的问题
         pod install --verbose --no-repo-update
         pod update --verbose --no-repo-update
        
         
         -- 升级CocoaPods版本: sudo gem install cocoapods /sudo gem install -n /usr/local/bin cocoapods
         卸载CocoaPods: sudo gem uninstall cocoapods
         
         pod:command not found: https://stackoverflow.com/questions/35441041/bash-pod-command-not-found-while-running-pod-install
         
         -- pod版本更新报错：You don't have write permissions for the /usr/bin directory
         解决办法：
         sudo gem install cocoapods -n /usr/local/bin
         
         /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
         brew install ruby````
        
         
         -- pod install报ruby的警告(warning: URI.escape is obsolete)解决：在~/.zshrc文件添加 export RUBYOPT=-W0
         
         
         //MARK: - Podfile
         
         在Podfile最上方加上:
         install! 'cocoapods', :disable_input_output_paths => true  //(new build system)
         require_relative 'patch_static_framework'                  //把所有 pod 变成 Static Framework
         
         
         -- 在Podfile文件中加上下面这行后，pods下的源文件就可写了。
         install! 'cocoapods', :lock_pod_sources => false
         示例的Podfile如下。
         install! 'cocoapods', :lock_pod_sources => false
         target 'MyProject' do
         pod 'AFNetworking'
         end
         
         
         -- 移除pod
         sudo gem install cocoapods-deintegrate cocoapods-clean
         pod deintegrate
         pod clean
         rm Podfile
         
         
         -- 你会发现当引入MJExtension的头文件时，可以#import <MJExtension.h>或者#import <MJExtension/MJExtension.h>，但是却不能在输入#import "MJExtension.h"的时候出现提示。虽然强制输入也可以编译通过，但是感觉很不爽。
         解决这个问题的办法是在工程的Build Settings搜索Search，然后在User header search paths中添加$(SRCROOT)并选择recursive
         
         -- Clear DerivedData :
         rm -rf ~/Library/Developer/Xcode/DerivedData
         
         //MARK: - PMD(重复代码检测)
         https://blog.jerrychu.top/2018/08/05/Xcode-cpd/
         
         1. brew install pmd
         2. pmd cpdgui
         pmd cpd --files ZLSwiftTest --minimum-tokens 20 --language swift --encoding UTF-8 --format xml > output.xml
         
         //MARK: - Mempraph(内存分析)
         https://juejin.cn/post/7107507601545363493
         https://rderik.com/blog/using-xcode-s-visual-debugger-and-instruments-modules-to-prevent-memory-overuse/#:~:text=When%20you%20run%20your%20app%20on%20Xcode%2C%20you,it%20and%20analyze%20it%20later%20if%20you%20want.
         1. ps aux | grep Testing.app
         2. leaks 93016
         3. echo $?
         4. leaks 93016 --outputGraph=testingApp
         5. open testingApp.memgraph
         6. vmmap testingApp.memgraph
         
         vmmap --summary SwiftTestApp.memgraph
         vmmap SwiftTestApp.memgraph | grep 'IOKit'
         
         leaks SwiftTestApp.memgraph
         
         heap SwiftTestApp.memgraph
         heap SwiftTestApp.memgraph -sortBySize
         heap SwiftTestApp.memgraph -address all
         malloc_history SwiftTestApp.memgraph --fullStacks [address]
         
         //MARK: - swiftgen(自动生成资源代码)
         https://xuebaonline.com/Swift%20tips/
         brew update
         brew install swiftgen
         swiftgen config init
         swiftgen config lint
         swiftgen config run --config swiftgen.yml
         
         //MARK: - LinkMap(分析类或库占用的空间大小)
         https://github.com/huanxsd/LinkMap
         https://dishibolei.github.io/2017/08/17/ios-linkmap/
         
         //MARK: - FengNiao(扫描删除无用资源)
         安装
         Mint is a tool that installs and runs Swift command line tool packages. Make sure you have Xcode installed, then:
         > brew install mint
         > mint install onevcat/fengniao
         
         使用
         > cd 文件路径
         > fengniao
         也可添加 Run Scripts
         
         //MARK: - fdupes(扫描重复资源)
         brew install fdupes
         fdupes -r --recurse <filePath>
         fdupes -Sr <filePath>
         fdupes -r -S -m .
         
         //MARK: - swift-scripts(查找废弃方法和属性)
         > cd 文件路径
         > 运行 unused.rb
         
         //MARK: - Periphery(识别 Swift 项目中未使用代码)
         brew install peripheryapp/periphery/periphery
         periphery scan --setup (cd到项目路径)
         
         //MARK: - Onefetch(在终端展示Git仓库的项目详情和代码统计等信息)
         https://github.com/o2sh/onefetch/wiki/getting-started
         > onefetch /path/of/your/repo
         Or
         > cd /path/of/your/repo
         > onefetch
         
         //MARK: - On-Demand Resources
         https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/index.html#//apple_ref/doc/uid/TP40015083-CH2-SW1
         
         //MARK: - Xcode模拟器命令
         -- 测试推送
         xcrun simctl list devices
         xcrun simctl push <device-uuid> <bundle-identifier> test.apn
         
         //下方两种都可行
         xcrun simctl push booted com.house730.pms.debug /Users/liangzhang/Documents/test.apns
         xcrun simctl push 8EC19713-0350-412F-9145-AD4A89A757DC com.house730.pms.debug /Users/liangzhang/Documents/test.apns
         
         -- 模拟器录屏
         xcrun simctl io booted recordVideo <filename>.<extension>
         xcrun simctl io booted recordVideo ios.mov
         ls -all
         
         -- 截图(会保存到当前执行的文件目录下)
         xcrun simctl io booted screenshot "screen.png"
         xcrun simctl io booted screenshot --type=jpeg --mask=black screenshot.jpeg
         
         获取应用的沙盒路径
         xcrun simctl appinfo booted "com.house730.pms.debug"
         
         //MARK: - find命令
         -- 当前目录 一天前修改过的文件（没有加号，就是最近24-48小时修改过的）
         find . -mtime +1
         find . -name '*.swift' -mtime 4
         
         一天内修改过的文件
         find . -type f -mtime -1
         find . -name '*.swift' -mtime -1
         
         find /home -size +512k  查大于512k的文件
         find /home -size -512k  查小于512k的文件
         
         -maxdepth：指定最大查找深度，即最大向指定目录下面搜索maxdepth级
         -mindepth：指定最小查找深度，即从指定目录下面第mindepth级目录开始搜索
         find . -mindepth 2 -name "*.swift" -newermt "2025-04-16"  只找出 2025-04-16 这一天修改的文件
         
         //MARK: - fd文件查找
         https://www.poloxue.com/mytermenv/docs/commands/search/fd/
         
         brew install fd
         fd '.*\.txt'    查出所有以 .txt 结尾的文件
         
         */
    }
    
    private func gitCommand() {
        /*
         https://github.com/k88hudson/git-flight-rules/blob/master/README_zh-CN.md
         
         git status
         git pull origin master
         git add .
         git commit -m 'add files'
         git push origin master
         
         cat .git/config             //查看当前仓库的远程地址、分支信息
         cat .git/refs/heads/master  //输出一个SHA-1 校验和
         
         git add -A .     //一次性把更改的文件加到暂存区
         gii add -u       //一次性添加更改过的文件到暂存区，但是不包括untracted的文件
         git add -i       //可以查看更改且没有提交的文件
         git rm -cached   //取消 git add
         
         git stash                   //贮藏
         git stash push -m '贮藏名称' //贮藏并设置名称
         git stash list              //贮藏列表
         git stash apply             //应用贮藏
         git stash apply stash@{0}   //应用最近一次贮藏
         git stash pop               //恢复贮藏(并删除)
         git stash drop/clear        //删除最近的一个贮藏(所有的)
         git stash drop stash@{0}    //删除列表第一个
         
         git checkout -- fileName    //撤销对某个文件的修改(未暂存)
         git checkout -- .           //撤销工作区下所有文件的修改
         
         git --amend
         
         git tag                               //查看标签
         git tag v1.0 commit id                //打一个新标签
         git show tagname                      //查看标签信息
         git tag -a tagname -m "blablabla..."  //可以指定标签信息
         git tag -d v1.0                       //删除本地tag
         git push origin v1.0.0                //将本地某个特定标签推送到远程
         git push --tag(tags)                  //将本地标签一次性推送到远程
         
         git push --delete origin v1.0.0 或者git push origin -d(delete) v1.0 //删除远程的某个标签
         git push origin :refs/tags/v1.0.0  //删除远端的指定tag
         
         
         ---------------------------  ///////////////////////  -----------------------------
         git fetch origin zl_real                 //从远程拉取分支
         git checkout -b zl_real origin/zl_real   //将远程分支与本地分支关联
         
         
         ------------------  new (late 2019)  ------------------------
         git switch <分支名>      (替代 git checkout)
         git switch -c <分支名>   (替代 git checkout -b)
         
         git restore             (替代 git checkout --)
         git restore <file>            //将在工作区但是不在暂存区的文件撤销更改
         git restore --staged <file>   //从暂存区中恢复至work tree，不会撤销更改
         git restore --staged .        //将当前目录所有暂存区文件恢复状态
         git restore --worktree <file> //撤销工作区下某文件的修改
         git restore --worktree .      //撤销工作区下所有文件的修改
         
         撤销和回滚：https://www.jianshu.com/p/38921d19ba0a
         
         ------------------  ///// ------------------------
         git branch testing    //新建一个分支--1
         git checkout testing  //切换到分支--2
         git checkout -b       //切换到分支b，相当于上面1和2
         
         git branch               //获取本地分支列表
         git branch -r            //获取远程分支列表
         git branch -a            //查看本地和远程所有分支
         git branch -d testing    //删除本地分支
         
         git branch -m oldName newName   //分支重命名
         git push --delete origin oldName    //删除远程分支
         git push origin newName                //上传新命名的本地分支
         git branch --set-upstream-to origin/newName   //把修改后的本地分支与远程分支关联
         git branch -v                                //查看每一个分支的最后一次提交
         git branch -vv                              //列出所有本地分支及跟踪信息
         git branch --merged(-- no-merged)  //已合并(尚未合并)到当前分支的分支
         
         git remote prune origin  //清除本地分支缓存
         git remote -v            //查看远程仓库地址
         
         git push origin :remote        //删除远程分支
         git ls-remote                  //获得远程引用的完整列表
         git clone -o booyah            //那么默认的远程分支名字将会是 booyah/master
         git fetch origin               //查找"origin"是哪一个服务器
         
         git config --global init.defaultBranch main  //修改默认分支
         
         
         git reset --soft commit_id             //撤销commit,将改动放在缓存区(不撤销git add .)
         git reset --soft HEAD^/HEAD~1/HEAD~2,  //撤销commit,修改保留
         git reset --mixed commit_id            //撤销commit,不把改动放在缓存区(撤销git add .)
         git reset --hard commit_id             //撤销commit,但是不会保留修改
         git reset --hard                       //撤销对文件的修改(已暂存)
         
         ------- 撤销分支合并 ------
         git merge --abort (未提交)
         
         git reset --hard HEAD^
         git push origin dev -f  //撤销远程仓库上一次push
         
         git revert commit_id          //用一次新的commit来回滚之前的commit
         git revert HEAD/HEAD^/HEAD~n  //同上
         对于单一parent的commit，直接使用git revert commit_id;
         对于具有多个parent的commit，需要结合 -m 属性：git revert commit_id -m parent_id;
         对于从branch合并到 master 的 merge commit，master的parent_id是1，branch的parent_id是2, 反之亦然;
         
         reset/revert区别：
         git revert是用一次新的提交来回滚之前的commit，git reset是直接删除制定的commit
         git revert是继续前进，git reset是把HEAD向后移动了一下
         
         
         git rebase //将提交到某一分支上的修改都移至另一分支上
         git rebase testing (rebase 会改写历史记录)
         git rebase 的黄金法则：绝不要在公共分支上使用它
         
         
         git commit --amend     进入默认vim编辑器,修改commit注释
         git commit --amend -m "提交信息"   //修订最后一次提交的commit message
         git rebase --continue  commit注释修改完，继续操作
         
         
         git log                                    //会按提交时间列出所有的更新
         git log -p -2                              //显示最近两次提交
         git log --stat
         git log --pretty=oneline --abbrev-commit   //找到历史提交的commit id
         git log --pretty=oneline/short/full/fuller //单行显示提交历史
         git log --pretty=format
         git log --since=2.weeks                    //最近两周内的提交
         git log --oneline --decorate               //查看各个分支当前所指的对象
         git log --graph --pretty=oneline --abbrev-commit
         
         git reflog  //记录你的每一次命令
         git shortlog -sn  //列出代码的提交者
         
         gitignore文件不生效解决办法：
         git rm -r --cached .
         git add .
         git commit -m 'clear git cache'
         git push
         
         
         git代码统计：http://jartto.wang/2019/07/09/git-stats/
         
         --------------  merge pull request  ----------------
         step1:
         git fetch origin
         git checkout -b zl origin/zl
         git merge master
         
         step2:
         git checkout master
         git merge --no-ff zl
         git push origin master
         
         
         //查看用户名和邮箱
         git config user.name
         git config user.email
         
         //修改用户名和邮箱
         git config --global user.name zhangliangmac
         git config --global user.email zhangliangmc@163.com
         git config --global --unset user.name
         
         
         alias gs="git status" //路径别名
         alias ga="git add”
         
         //git flow删除
         git config --remove-section "gitflow.path"
         git config --remove-section "gitflow.prefix"
         git config --remove-section "gitflow.branch"
         
         */
    }
    
    private func Xcode_Shortcuts() {
        /*
         fileName
         /Users/ZhangLiang/Library/Developer/Xcode/DerivedData
         ~/Library/Developer/Xcode/DerivedData/
         
         control + command + 空格   显示表情和特殊字符
         control + command + R     跳过编译，直接运行
         
         command + N              //New File
         command + shift + N      //创建新工程
         command + W              //(关闭窗口)
         command + control + ←/→  //(按刚浏览的顺序退/进)
         option + 左键点击文件      //在当前编辑框右边打开的文件(一个快速打开Assistant Editor的方式)
         
         command + 0              //隐藏左侧工具栏
         command + option + 0     //隐藏右侧工具栏
         command + shift + Y      //显示底部控制台
         {
         command + F              //当前类文件查找
         command + G              //搜索下一处
         shift + command + G      //搜索上一处
         }
         
         command + L              //快速跳转到类的特定行
         command + shift + O      //快速查找打开类
         command + shift + O      //输入AppDelegate:44，能直接跳转到AppDelegate的44行
         command + shift + J      //快速定位当前类在项目文件中的位置
         command + shift + L      //查找搜索 Library
         command + shift + M      //查找搜索 Media Assets
         control + command + ↑/↓  //类文件".h"与“.m”之间切换
         
         command + shift + 0（zero）          //查看Apple文档
         control + shift + 0（zero）          //选择模拟器或手机设备
         control + shift + ↑/↓               //多行光标
         control + shift + 鼠标单击            //多行光标
         
         command + shift + K                  //clean
         command + K                          //清除控制台打印信息
         control + 6（键入方法/变量名+Enter跳转） //当前类 方法/变量查找
         command + z /command + shift + z     //撤销/反撤销
         
         光标操作：
         control + F: 向右一个字符（forward）
         control + B: 向左一个字符（backward）
         control + P: 前一行（previous）
         control + N: 后一行（next）
         control + A: 去行首
         control + E: 到行尾（end）
         control + T: 调换光标两边的字符（transpose）
         control + D: 删除光标右侧字符（delete）
         control + K: 删除本行剩余的字符（kill）
         
         control + I: 自动调整代码缩进
         
         整体位移代码:
         选中的代码 + command + [                 //向左位移
         选中的代码 + command + ]                 //向右位移
         选中的代码 + command + option + [        //向上位移
         选中的代码 + command + option + ]        //向下位移
         
         option + command + /                   //Add Documentation
         
         command + option + J                   //方法的description(Objective-C)
         command + option + T                   //隐藏/打开Toolar
         command + option + ← / →               //方法体收起/展开
         command + option + ←/→                 //局部折叠（折叠一个函数）
         shift + command + option + Left/Right  //全局折叠（折叠当前文件下的全部函数）
         control + shift + command + ←/→        //折叠注释块：（/* */之间的文字）
         
         cmd +/- 可以实现编译器的放大缩小
         
         control + command + 单击                //Jump to Definition
         鼠标用户: 对准你的对象，command + 鼠标右键   //Jump to Definition
         触摸板用户: 对准你的对象, command + 双指点击 //Jump to Definition
         */
    }
    
    private func Simulator_Shortcuts() {
        /*
         command + M              最小化
         command + H              隐藏模拟器
         command + Q              关闭模拟器
         command + L              锁屏
         command + shift + H      回到首页
         command + shift + 双击H   双击home键
         command + ←/→            顺时针或者逆时针
         command + k              显示/不显示键盘(前提是要有用到输入框的地方)
         command + shift + k      打开/关闭从电脑键盘输入内容到模拟器
         command + control + C    复制屏幕操作
         option + shift           进行拖动手势
         */
    }
    
    private func Xcode_LLDB() {
        /*lldb
         https://objccn.io/issue-19-2/
         po [[[UIApplication sharedApplication] keyWindow] recursiveDescription]
         在swift环境下：expr -l objc++ -O -- [[[UIApplication sharedApplication] keyWindow] recursiveDescription]
         
         LLDB: Create dependent breakpoints using "breatpoint set --one-shot true"
         "po $arg1"($arg2, etc) in assembly frames to point function arguments
         Skip lines of code by dragging Instruction Pointer or "thread jump --by 1"
         Evaluate Obj-C code in Swift frames with "expression -l objc -o -- <expr>"
         Flush view changes to the screen using "expression CATransaction.flush()"
         
         lldb: https://medium.com/flawless-app-stories/debugging-swift-code-with-lldb-b30c5cf2fd49
               https://www.jianshu.com/p/22fa4e4e1cc4
               https://juejin.cn/post/6872764160640450574
         
         e item -> e item = 4 修改变量的值
         frame info 显示当前断点的条件状况，断点所在的文件位置
         la(launage) swift refcount 查看对象引用计数，查找内存泄露
         process status
         process continue
         platform status
         x, x/4gx        读取内存
         bt              堆栈打印 (bt 10，只打印10行)
         thread list     列出当前线程列表
         thread return   跳出当前方法的执行
         image lookup -a 查看崩溃位置
         
         thread jump --by 1 (th j -b 1) 跳过第一个语句
         */
    }
    
    private func iTerm_Shortcuts() {
        /*
         st  //打开Sublime Text
         google/baidu (web-search插件) 要搜索的内容  //直接跳转并打开搜索结果
         
         https://support.apple.com/zh-cn/guide/terminal/trmlshtcts/mac
         快捷键
         ⌘ + d           Tab纵向分割
         ⌘ + shift + d   Tab横向分割
         ⌘ + t           新建Tab
         ⌘ + /           快速定位到光标所在位置
         ⌘ + alt+ e      一屏显示所有窗口
         ⌘ + ；          命令补全提示
         ⌘ + shift + h   打开粘贴历史
         ⌘ + alt + /     打开最近目录
         ⌘ + alt + ；    鼠标所在行高亮显示
         ⌘ + Shift + M   将这行标记下来，随后我们在需要的时候，可以按下 ⌘ + Shift + J 就可以立即跳回这一行了
         ⌘ + option + b  快照返回
         ⌘ + option + e  标签排列切换
         ⌘ + Shift + E   显示时间
         ⌘ + Shift + C   复制模式(esc退出)
         */
    }
    
    private func Mac_shortcuts() {
        
        /*
         chrome/system
         https://juejin.im/post/5e15339b6fb9a04811666bba#heading-3
         
         shift + option + K     //打出
         command + option + esc //强制退出应用程序
         */
    }
    
    private func OC_static_framework() {
        /*
         lipo -create iphoneos路径 iphonesimulator路径 -output /Users/zhangliang/Desktop/ZLSDK
 
         
         target script: ↓↓↓
         #如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME

         #例如: FMK_NAME="MyFramework"

         FMK_NAME=${PROJECT_NAME}

         # Install dir will be the final output to the framework.

         # The following line create it in the root

         folder of the current project.

         INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

         # Working dir will be deleted after the framework creation.

         WRK_DIR=build

         DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework

         SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

         # -configuration ${CONFIGURATION}

         # Clean and Building both architectures.

         xcodebuild -configuration"Release"-target"${FMK_NAME}"-sdk iphoneos clean build

         xcodebuild -configuration"Release"-target"${FMK_NAME}"-sdk iphonesimulator clean build

         # Cleaning the oldest.

         if[ -d"${INSTALL_DIR}"]

         then

         rm -rf"${INSTALL_DIR}"

         fi

         mkdir -p"${INSTALL_DIR}"

         cp -R"${DEVICE_DIR}/""${INSTALL_DIR}/"

         # Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.

         lipo -create"${DEVICE_DIR}/${FMK_NAME}""${SIMULATOR_DIR}/${FMK_NAME}"-output"${INSTALL_DIR}/${FMK_NAME}"

         rm -r"${WRK_DIR}"

         open"${INSTALL_DIR}"
 
         */
        
        
        /*
         script(真机): ↓↓↓
         # 1 - Extract the platform (iphoneos/iphonesimulator) from the SDK name
         if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
           RW_SDK_PLATFORM=${BASH_REMATCH[1]}
         else
           echo "Could not find platform name from SDK_NAME: $SDK_NAME"
           exit 1
         fi

         # 2 - Extract the version from the SDK
         if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]; then
           RW_SDK_VERSION=${BASH_REMATCH[1]}
         else
           echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
           exit 1
         fi

         # 3 - Determine the other platform
         if [ "$RW_SDK_PLATFORM" == "iphoneos" ]; then
           RW_OTHER_PLATFORM=iphonesimulator
         else
           RW_OTHER_PLATFORM=iphoneos
         fi

         # 4 - Find the build directory
         if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$RW_SDK_PLATFORM$ ]]; then
           RW_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${RW_OTHER_PLATFORM}"
         else
           echo "Could not find other platform build directory."
           exit 1
         fi
         */
    }
    
    private func swift_static_framework() {
        /*
        Project Target -> Build Phase -> Add Run Script ↓↓↓
        
        bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/YudizFramework.framework/ios-framework-build.sh" YudizFramework
         
         
         script: ↓↓↓
         UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
          
         # make sure the output directory exists
         mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
          
         # Step 1. Build Device and Simulator versions
         xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
         xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
          
         # Step 2. Copy the framework structure (from iphoneos build) to the universal folder
         cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
          
         # Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
         SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
         if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
         cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
         fi
          
         # Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
         lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"
          
         # Step 5. Convenience step to copy the framework to the project's directory
         cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"
          
         # Step 6. Convenience step to open the project's directory in Finder
         open "${PROJECT_DIR}"
         
         */
    }
}
