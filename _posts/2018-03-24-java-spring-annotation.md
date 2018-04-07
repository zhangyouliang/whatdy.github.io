---
layout: post
title: spring 注解
excerpt: spring 注解相关使用笔记
tags:
  - java
  - spring
---


SpringCloud 注解
=====

### # @SpringBootApplication

等价于`@Configuration`、`@EnableAutoConfiguration`、`@ComponentScan`,

查看`SpringBootApplication`注解可以发现 `@ComponentScan` 并没有添加任何的参数，它会自动扫描工程里所有的` @Component, @Service, @Repository, @Controller`并把它们注册为Spring Beans。

### # @AutoWired
 
自动装载

### # @Component

泛指组件，一般用于普通POJO,当组件不好归类的时候，也可以使用这个注解进行标注。

### # @Service

用于标注业务层组件

### # @RestController

用于标注控制层组件。`@RestController`同时包含了`@Controller、@ResponseBod`y。


### # @GetMapping

也是一个组合注解，相当于@RequestMapping(method = RequestMethod.GET)的缩写。 类似的还有`@PostMapping、@PutMapping、@DeleteMapping`。


### # @PathVariable

这里出现了`@PathVariable，@Pathvariable`注解可以绑定占位符传过来的值到方法的参数上。

### # @RequestParam 

从请求中提取参数,如果传入参数名字和方法参数名字不一致，可以给@RequestParam的属性赋值

```
@PostMapping(value = "login")
public void login(@RequestParam("account") String name, @RequestParam String password) {
    System.out.println(name + ":" + password);
}
```

### # @RequestBody 

可以用来解析json字符串(还可以解析xml)，并将字符串映射到对应的实体中，实体的字段名和json中的键名要对应。

```
@PostMapping(path = "register")
public String registerUser(@RequestBody User user) {
    return user.toString();
}
```

### # @RequestHeader

注解用来将请求头的内容绑定到方法参数上

```
@PostMapping(value = "login")
public void login(@RequestHeader("access_token") String accessToken,@RequestParam String name) {
    System.out.println("accessToken:" + accessToken);
}
```

@Value 为了简化从 properties 中取配置,可以使用 @Value

application.properties

```
@Value("${wx_appid}")
private String appid;
```
### # @Valid

网上一大片使用@Valid失效不能用的情况。为什么呢？

1.@Valid必需使用在以@RequestBody接收参数的情况下。

2.使用ajax以POST方式提示数据，禁止用Fiddler以及浏览器直接访问的方式测试接口

3.用<mvc:annotation-driven />添加注解驱动。

4.@Valid是应用在javabean上的校验。

全部参数校验如下：

空检查

@Null       验证对象是否为null

@NotNull    验证对象是否不为null, 无法查检长度为0的字符串

@NotBlank 检查约束字符串是不是Null还有被Trim的长度是否大于0,只对字符串,且会去掉前后空格.

@NotEmpty 检查约束元素是否为NULL或者是EMPTY.

 

Booelan检查

@AssertTrue     验证 Boolean 对象是否为 true 

@AssertFalse    验证 Boolean 对象是否为 false 

 

长度检查

@Size(min=, max=) 验证对象（Array,Collection,Map,String）长度是否在给定的范围之内 

@Length(min=, max=)验证注解的元素值长度在min和max区间内

日期检查

@Past           验证 Date 和 Calendar 对象是否在当前时间之前 

@Future     验证 Date 和 Calendar 对象是否在当前时间之后 

@Pattern    验证 String 对象是否符合正则表达式的规则

 

数值检查，建议使用在Stirng,Integer类型，不建议使用在int类型上，因为表单值为“”时无法转换为int，但可以转换为Stirng为"",Integer为null

@Min(value=””)            验证 Number 和 String 对象是否大等于指定的值 

@Max(value=””)             验证 Number 和 String 对象是否小等于指定的值 

@DecimalMax(value=值) 被标注的值必须不大于约束中指定的最大值. 这个约束的参数是一个通过BigDecimal定义的最大值的字符串表示.小数存在精度

@DecimalMin(value=值) 被标注的值必须不小于约束中指定的最小值. 这个约束的参数是一个通过BigDecimal定义的最小值的字符串表示.小数存在精度

@Digits     验证 Number 和 String 的构成是否合法 

@Digits(integer=,fraction=)验证字符串是否是符合指定格式的数字，interger指定整数精度，fraction指定小数精度。

 

@Range(min=, max=) 检查数字是否介于min和max之间.

@Range(min=10000,max=50000,message="range.bean.wage")

private BigDecimal wage;

 

@Valid 递归的对关联对象进行校验, 如果关联对象是个集合或者数组,那么对其中的元素进行递归校验,如果是一个map,则对其中的值部分进行校验.(是否进行递归验证)

@CreditCardNumber信用卡验证

@Email  验证是否是邮件地址，如果为null,不进行验证，算通过验证。

@ScriptAssert(lang=,script=, alias=)

@URL(protocol=,host=,port=,regexp=, flags=)




### # @Scope

singleton：单例，即容器里只有一个实例对象。

request：对每一次HTTP请求都会产生一个新的bean，同时该bean仅在当前HTTP request内有效

prototype：多对象，每一次请求都会产生一个新的bean实例

### # 元注解包括 @Retention  @Target @Document @Inherited 

**@Retention: 定义注解的保留策略：**

@Retention(RetentionPolicy.SOURCE)   //注解仅存在于源码中，在class字节码文件中不包含

@Retention(RetentionPolicy.CLASS)     //默认的保留策略，注解会在class字节码文件中存在，但运行时无法获得，

@Retention(RetentionPolicy.RUNTIME)  //注解会在class字节码文件中存在，在运行时可以通过反射获取到

 

**@Target：定义注解的作用目标:**

@Target(ElementType.TYPE)   //接口、类、枚举、注解

@Target(ElementType.FIELD) //字段、枚举的常量

@Target(ElementType.METHOD) //方法

@Target(ElementType.PARAMETER) //方法参数

@Target(ElementType.CONSTRUCTOR)  //构造函数

@Target(ElementType.LOCAL_VARIABLE)//局部变量

@Target(ElementType.ANNOTATION_TYPE)//注解

@Target(ElementType.PACKAGE) ///包   

 由以上的源码可以知道，他的elementType 可以有多个，一个注解可以为类的，方法的，字段的等等

 

**@Document：说明该注解将被包含在javadoc中**

**@Inherited：说明子类可以继承父类中的该注解**


