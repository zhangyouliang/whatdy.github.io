---
layout: post
title: MyBatis 一些问题
excerpt: 记录下学习mybatis框架遇到的一些问题
ags:
  - java
  - mybatis
---


**#{}**
防止SQL注入,动态解析的时候,会解析成参数标记符,类似于:
```sql
select * from user name = #{name};
select * from user where name =?;
```

**${}**
在解析的时候会将我们传入的值当做 String 填充到我们的语句中
```sql
select * from user where name = "admin";
select * from user where name = ${name};
```


这是 `#{}` 和 `${}` 我们能看到的主要的区别，除此之外，还有以下区别:
#方式能够很大程度防止sql注入。
$方式无法防止Sql注入。
$方式一般用于传入数据库对象，例如传入表名.
一般能用#的就别用$.


mybatis 还需要注意:

```java
## 使用 @Param 注解时,参数不仅有 JavaBean,而且还存在 queryObject 这个对象
@Select("SELECT * from City where id = #{id}")
List<City> getListByCriteria(@Param("queryObject") int id);

## 不使用 @Param 注解时,参数只能有一个(JavaBean)
@Select("SELECT * from City where id = ${id}")
List<City> getListByCriteria(int id);
```

### # selectKey
使用Oracle的序列、mysql的函数生成ID 方式不一样,这里他们可以通过 `selectKey` 这个标签获取到插入数据生成的 ID

下面例子，使用mysql数据库 LAST_INSERT_ID()  用来生成一个key，并把他设置到传入的实体类中的 id 属性上。所以在执行完此方法后，边可以通过这个实体类获取生成的key。
```xml
<insert id="insert" parameterType="com.whatdy.model.City" keyProperty="id">
<selectKey resultType="int" keyProperty="id" order="AFTER">
    SELECT LAST_INSERT_ID() AS id
</selectKey>
insert into city (
<trim suffixOverrides=",">
    id,
    name,
    state,
    country,
</trim>
)
values (
<trim suffixOverrides=",">
    #{id,jdbcType=INTEGER},
    #{name,jdbcType=VARCHAR},
    #{state,jdbcType=VARCHAR},
    #{country,jdbcType=VARCHAR},
</trim>
)
</insert>
```

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class CityService {
    public void testInsert() {
        City city = new City();
        city.setName("北京");
        city.setState("100001");
        city.setCountry("中国");
        int i = cityMapper.insert(city);
        LOGGER.info("insert sql result ======> ");
        System.out.println(city.getId());
    }
}
```

属性 | 描述 | 取值
---|---|---
keyProperty	selectKey | 语句生成结果需要设置的属性。	
resultType | 生成结果类型，MyBatis 允许使用基本的数据类型，包括String 、int类型。	
order | 1：BEFORE，会先选择主键，然后设置keyProperty，再执行insert语句； 2：AFTER，就先运行insert 语句再运行selectKey 语句。 | 	BEFORE AFTER
statementType | MyBatis 支持STATEMENT，PREPARED和CALLABLE 的语句形式， 对应Statement ，PreparedStatement 和CallableStatement 响应 | STATEMENT ,PREPARED,CALLABLE

其他方式获取`插入操作返回的主键`

**1. 使用useGeneratedKeys+keyProperty (推荐)**

> 将插入的ID赋值给设置的keyProperty对象属性字段里面，一般也就是对象的ID，比如插入User对象，设置赋值主键ID给id字段。

```xml
<insert id="" useGeneratedKeys="true" keyProperty="id">
```

**2. 使用selectKey **

**也就是上述方式**

### # select

在操作数据库当中往往查询比插入难度更加大,更加繁琐

Dao 层
```java
@Repository
public interface CityMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(City record);
    City selectByPrimaryKey(Integer id);
    List<City> selectAll();
    int updateByPrimaryKey(City record);
    List<City> getListByCriteria(@Param("queryObject") City record);
}
```


Mapper
```xml
<select id="getListByCriteria" parameterType="com.whatdy.model.City" resultMap="BaseResultMap">
    select * from city
    <include refid="select_where_clause"/>
</select>
<sql id="select_where_clause">
    <trim prefixOverrides="AND|OR" prefix="where">
        <if test="queryObject.id != null">AND id = #{queryObject.id}</if>
        <if test="queryObject.name != null">AND id = #{queryObject.name}</if>
        <if test="queryObject.state != null">AND id = #{queryObject.state}</if>
        <if test="queryObject.country != null">AND id = #{queryObject.country}</if>
    </trim>
</sql>
```


### # association , collection 

1. 关联-association
2. 集合-collection

```java
public class User{
    private Card card_one;
    private List<Card> card_many;
}
```
在映射 `card_one` 属性时候用 `association` 标签,映射 `card_many` 的时候使用 `collection`

association 用于`一对一` 和 `多对一`,collection 用于 `一对多关系`


例子:

```java
class User{
    private List<Products> productsList;
    private Integer id;
    private String username;
    private String password;
    private Date createdAt;
    private Date updatedAt;
}
class Products
{
    private Integer id;
    private String pname;
    private Float price;
    private Integer uid;
    private Date createdAt;
    private Date updatedAt;
    private Users users;
}
```

**UsersMapper.xml**
```xml

<resultMap id="BaseProductResultMap" type="com.whatdy.model.Products">
    <id column="id" property="id" jdbcType="INTEGER"/>
    <result column="pname" property="pname" jdbcType="VARCHAR"/>
    <result column="price" property="price" jdbcType="REAL"/>
    <result column="uid" property="uid" jdbcType="INTEGER"/>
    <result column="created_at" property="createdAt" jdbcType="DATE"/>
    <result column="updated_at" property="updatedAt" jdbcType="DATE"/>
</resultMap>
<!-- 表关联-->
<resultMap id="detailUserResultMap" type="com.whatdy.model.Users">
    <id column="id" property="id" jdbcType="INTEGER"/>
    <result column="username" property="username" jdbcType="VARCHAR"/>
    <result column="password" property="password" jdbcType="VARCHAR"/>
    <result column="created_at" property="createdAt" jdbcType="DATE"/>
    <result column="updated_at" property="updatedAt" jdbcType="DATE"/>
    <!-- property: 指的是集合属性的值, ofType：指的是集合中元素的类型 -->
    <collection property="productsList" ofType="com.whatdy.model.Products"  javaType="ArrayList" resultMap="BaseProductResultMap">
    </collection>
</resultMap>

<select id="selectUserDetails" resultMap="detailUserResultMap">
    SELECT * FROM users B left  JOIN products A on B.id = A.uid
    WHERE B.id = #{id}
</select>
```

**ProductMapper.xml**

```xml
<resultMap type="com.whatdy.model.Users" id="userResult">
    <id column="id" property="id" jdbcType="INTEGER"/>
    <result column="username" property="username" jdbcType="VARCHAR"/>
    <result column="password" property="password" jdbcType="VARCHAR"/>
    <result column="created_at" property="createdAt" jdbcType="DATE"/>
    <result column="updated_at" property="updatedAt" jdbcType="DATE"/>
</resultMap>

<resultMap id="userAndProductResultMap" type="com.whatdy.model.Products">
    <id column="id" property="id" jdbcType="INTEGER"/>
    <result column="pname" property="pname" jdbcType="VARCHAR"/>
    <result column="price" property="price" jdbcType="REAL"/>
    <result column="uid" property="uid" jdbcType="INTEGER"/>
    <result column="created_at" property="createdAt" jdbcType="DATE"/>
    <result column="updated_at" property="updatedAt" jdbcType="DATE"/>
    <!--使用 resultMap 属性引用上面的 User 实体映射-->
    <association property="users" column="uid" javaType="com.whatdy.model.Users" jdbcType="INTEGER" resultMap="userResult">
    </association>
</resultMap>

<!--关联 一对一-->
<select id="selectUserAndProduct" resultMap="userAndProductResultMap">
   select * from products A LEFT JOIN users B ON A.uid = B.id
</select>
```

**Dao 层**
```java

@Repository
public interface ProductsMapper {
    List<Products>  selectUserAndProduct();
}
@Repository
public interface UsersMapper {
    List<Users> selectUserDetails(Integer id);
}
```

**测试**

**TestUserService**
```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class UserService {
    protected static final Logger LOGGER = (Logger) LoggerFactory.getLogger(UserService.class);
    @Autowired
    protected UsersMapper usersMapper;
    @Test
    public void testAssociationTable() {
        List<Users> usersList = usersMapper.selectUserDetails(1);
        for (Users u :
                usersList) {
            System.out.println(u);
        }
    }
}

```
**TestProductService**
```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class ProductService {
    protected static final Logger LOGGER = (Logger) LoggerFactory.getLogger(ProductService.class);
    @Autowired
    protected ProductsMapper productsMapper;
    @Test
    public void testAssociationTable() {
        List<Products> list = productsMapper.selectUserAndProduct();
        System.out.println(list);
    }
}
```