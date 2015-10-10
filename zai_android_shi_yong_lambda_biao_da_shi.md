# 在android使用lambda表达式

简介：java 8中本人感觉非常感兴趣的有两大特性 
lambda和 stream

但是在android中我们只能使用java7，不支持java8 ，这非常让人感觉沮丧，但是往往都有很多牛人已经帮我们解决了  （嘎嘎嘎嘎，兴奋一下）


大牛的地址 [https://github.com/evant/gradle-retrolambda](https://github.com/evant/gradle-retrolambda)

主要修改添加 build.gradle 配置如下
 

```
buildscript {
    repositories {
        jcenter()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:1.2.3+'
        classpath 'me.tatarka:gradle-retrolambda:3.2.0+'//添加支持
    }
}
apply plugin: 'com.android.application'
apply plugin: 'me.tatarka.retrolambda'//添加插件
android {
	…………………其他配置……………
	compileOptions {//使用jdk 1.8
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
 }
```

只要添加这3个地方就ok了！


###使用
例如dialog 和 view  click 事件

```
Dialog mUnstartDialog = new Dialog(getActivity())
                    .setTitle(R.string.unstar_title)
                    .setMessage(R.string.unstar_message)
                    .setPositiveButton(R.string.unstar_positive,
                            (dialog, which) -> {
                       ……         
                            }).setNegativeButton(R.string.unstar_negative, null).create();
```



`view.setOnClickListener(v -> onRowAdapterClickListener.onClick(v, info, position));`


但是这也有个弊端，搜索类方法的时候可就不好找了  例如OnClick方法变成了 v->{}  你就不好搜索了 o(╯□╰)o