---
layout: post
title: spring boot 发送网络请求
excerpt: spring boot 发送网络请求相关误区
tags:
  - java
  - spring-boot
---


#### # Spring boot RestTemplate GET 请求误区

错误使用方式

```java
String url = "http://localhost:8080/test/sendSms";

Map<String, Object> uriVariables = new HashMap<String, Object>();
uriVariables.put("phone", "151xxxxxxxx");
uriVariables.put("msg", "测试短信内容");

String result = restOperations.getForObject(url, String.class, uriVariables);
```

正确使用方式
```java
 String url = "http://localhost:8080/test/sendSms?phone={phone}&msg={msg}";

HashMap<String, Object> uriVariables = new HashMap<>();
uriVariables.put("phone","153xxxxxxxx");
uriVariables.put("msg","短息消息");

String result = restOperations.getForObject(url,String.class,uriVariables);
// 等价于  String result = restOperations.getForObject(url, String.class,  "151xxxxxxxx", "测试短信内容");
System.out.println(result);
```

#### # String Boot 使用 RestTemplate 中文乱码问题

由于 `StringHttpMessageConverter` 默认使用的是 `ISO-8859-1` 编码,所以这里我们采用下面的策略修改默认编码,有的同学通过修改源码,这里不推荐

```java
package com.zw.utils;

import org.springframework.http.*;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * @author youliangzhang
 * @date 2018/3/24  下午6:11
 **/

public class HttpClient {

    public String client(String url, HttpMethod method, MultiValueMap<String, String> params) {
        // 获取对话
        RestTemplate client = new RestTemplate();
        this.reInitMessageConverter(client);

        // 请求头
        HttpHeaders headers = new HttpHeaders();
        //  请勿轻易改变此提交方式，大部分的情况下，提交方式都是表单提交
        MediaType type = MediaType.parseMediaType("application/x-www-form-urlencoded; charset=UTF-8");
        headers.setContentType(type);
        headers.add("Accept", MediaType.APPLICATION_JSON.toString());
        //我们发起 HTTP 请求还是最好加上"Connection","close" ，有利于程序的健壮性
        headers.set("Connection", "close");

        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);
        //  执行HTTP请求
        ResponseEntity<String> response = client.exchange(url, method, requestEntity, String.class);
        return response.getBody();
    }
    /**
     * 初始化RestTemplate，RestTemplate会默认添加HttpMessageConverter,添加的StringHttpMessageConverter非UTF-8
     * 所以先要移除原有的StringHttpMessageConverter，再添加一个字符集为UTF-8的StringHttpMessageConvert
     * @param restTemplate
     */
    private void reInitMessageConverter(RestTemplate restTemplate) {
        List<HttpMessageConverter<?>> converterList = restTemplate.getMessageConverters();
        HttpMessageConverter<?> converterTarget = null;
        for (HttpMessageConverter<?> item : converterList) {
            if (item.getClass() == StringHttpMessageConverter.class) {
                converterTarget = item;
                break;
            }
        }

        if (converterTarget != null) {
            converterList.remove(converterTarget);
        }
        HttpMessageConverter<?> converter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        converterList.add(converter);
    }
    public static void main(String[] args) {
        HttpClient client = new HttpClient();
        //String url = "http://localhost:8000";
        String url = "https://www.baidu.com";
        HttpMethod method = HttpMethod.POST;
        // 封装参数,千万不要替换为Map与HashMap,否则无法传参
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("access_token", "xxxx");
        String content = client.client(url, method, params);
        System.out.println(content);
    }

}

```
exchange 参数列表情况:
```java
restTemplate.exchange(
    String url, 
    HttpMethod method,
    HttpEntity requestEntity, 
    Class responseType, 
    Object uriVariables[]
)
```


说明：
1）url: 请求地址；

2）method: 请求类型(如：POST,PUT,DELETE,GET)；

3）requestEntity: 请求实体，封装请求头，请求内容

4）responseType: 响应类型，根据服务接口的返回类型决定

5）uriVariables: url中参数变量值
