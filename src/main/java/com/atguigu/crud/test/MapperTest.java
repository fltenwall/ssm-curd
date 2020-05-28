package com.atguigu.crud.test;

import com.atguigu.crud.bean.Department;
import org.apache.ibatis.jdbc.Null;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

import java.util.UUID;

/**
 *  测试dao层的工作
 *  @author Double_Xu
 *  推荐：
 *  	Spring 的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件
 *  	1、导入 SpringTest 模块
 *  	2、使用 @ContextConfiguration 指定 Spring 配置文件的位置
 *  	3、直接使用 Autowired 注入要使用的组件即可
 *
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

	@Autowired
	DepartmentMapper departmentMapper;

	@Autowired
	EmployeeMapper employeeMapper;

	@Autowired
	SqlSession sqlSession;

	/**
	 * 测试 DepartmentMapper
	 */
	@Test
	public void testCRUD(){
		/*
		// 1、创建 SpringIOC 容器
		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
		// 2、从容器中获取 mapper
		Department bean = (Department) ioc.getBean(DepartmentMapper.class);
		*/
		//System.out.println(departmentMapper);

		// 1、插入几个部门
//		departmentMapper.insertSelective(new Department(null,"开发部"));
//		departmentMapper.insertSelective(new Department(null,"测试部"));

		// 2、生成员工数据，测试员工插入
		//employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@atguigu.com", 1));

		// 3、批量插入多个员工；批量，使用可以执行批量操作的 SqlSession
		/*
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for (int i = 0; i < 1000; i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5) + i;
			mapper.insertSelective(new Employee(null, uid, "M", uid + "@atguigu.com", 1));
		}
		*/

		System.out.println("Successfully!");
	}
}
