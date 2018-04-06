---
layout: page
title: 关于
menu: About
---
{% assign current_year = site.time | date: '%Y' %}

{{ site.customize.profile.author }}
===
男 95年

## 概况

- 邮箱：{{ site.email }}
- 主页：[{{ site.url }}]({{ site.url }})

计算机专业毕业，{{ current_year | minus: 2016 }} 年在职工作经验，{{ current_year | minus: 2015 }} 年 web 开发经验。

## 教育
- 山东泰安商业学院计算机专业 — 大专 2014 - 2016
- 中国石油大学计算机专业 — 本科 2017 - 2020 （自考）

## keywords
<div class="btn-inline">
{% for keyword in site.skill_keywords %} <button class="btn btn-outline" type="button">{{ keyword }}</button> {% endfor %}
</div>

### 综合技能

| 名称 | 熟悉程度
|--:|:--|
| PHP | ★★★★☆ |
| Java | ★★★☆☆ |
| Python | ★★★☆☆ |
| javascript | ★★★☆☆ |
| Docker | ★★★☆☆ |
| Linux | ★★★★☆ |
| Nodejs | ★★☆☆☆ |
| Markdown | ★★☆☆☆ |
| C | ★★☆☆☆ |
