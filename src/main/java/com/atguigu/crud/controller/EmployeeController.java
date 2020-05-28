package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.rmi.server.RMIClassLoader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的 CRUD 请求
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;

	/**
	 * 查询员工数据（分页查询）
	 *
	 * @return
	 */


	/**
	 * 需要导入jackson包
	 *
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 这不是要给分页查询；
		// 引入 PageHelper 分页插件
		// 在查询之前只需要调用 PageHelper ,传入页码，以及每页的大小
		PageHelper.startPage(pn, 10);
		// startPage 后边紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用 Pageinfo 包装查询后的结果，只需要将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		return Msg.success().add("pageInfo", page);
	}

	//	@RequestMapping("/emps")
	public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {

		// 这不是要给分页查询；
		// 引入 PageHelper 分页插件
		// 在查询之前只需要调用 PageHelper ,传入页码，以及每页的大小
		PageHelper.startPage(pn, 10);
		// startPage 后边金额的这个查询就是分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用 Pageinfo 包装查询后的结果，只需要将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);

		return "list";
	}

	/**
	 * 员工保存
	 * 1. 支持JSR303校验
	 * 2. 导入Hibernate-Validator包
	 *
	 * @return
	 */
	@RequestMapping(value = "/emp", method = RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		if (result.hasErrors()) {
			// 校验失败，返回失败，在模态框中显示校验失败的校验信息
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError fieldError : errors) {
				System.out.println("错误的字段名：" + fieldError.getField());
				System.out.println("错误信息：" + fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		} else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}

	/**
	 * 检查用户名是否可用
	 *
	 * @param empName
	 * @return true:用户名可用； false：用户名不可用
	 */
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName") String empName) {
		// 先判断用户名是否是合法的表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if (!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
		}

		// 数据库用户名重复校验
		boolean b = employeeService.checkUser(empName);
		if (b) {
			return Msg.success();
		} else {
			return Msg.fail().add("va_msg", "用户名不可用！");
		}
	}

	/**
	 * 按照员工id查询员工
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}

	/**
	 * 员工更新方法
	 * <p>
	 * 如果直接发送ajax=PUT形式的请求
	 * 封装的数据 Employee [empId=1014, empName=null, gender=null, email=null, dId=null]
	 * <p>
	 * 问题： 请求体中有数据；但是Employee对象封装不上；
	 * update tbl_emp  where emp_id = 1014;
	 * <p>
	 * 原因：
	 * Tomcat：
	 * 1、将请求体中的数据，封装一个map。
	 * 2、request.getParameter("empName")就会从这个map中取值。
	 * 3、SpringMVC封装POJO对象的时候。
	 * 会把POJO中每个属性的值，request.getParamter("email");
	 * AJAX发送PUT请求引发的血案：
	 * PUT请求，请求体中的数据，request.getParameter("empName")拿不到
	 * Tomcat一看是PUT不会封装请求体中的数据为 map，只有 POST 形式的请求才封装请求体为 map
	 * org.apache.catalina.connector.Request--parseParameters() (3111);
	 * <p>
	 * protected String parseBodyMethods = "POST";
	 * if( !getConnector().isParseBodyMethod(getMethod()) ) {
	 * success = true;
	 * return;}
	 * <p>
	 * 解决方案；
	 * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
	 * 1、配置上 HttpPutFormContentFilter；
	 * 2、他的作用；将请求体中的数据解析包装成一个map。
	 * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	 *
	 * @param employee
	 * @return
	 */
	@RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee) {
		System.out.println(employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}

	/**
	 * 单个批量二合一
	 * 批量删除：1-2-3；单个删除：1
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids") String ids) {
		if (ids.contains("-")) {
			// 批量删除
			List<Integer> del_ids = new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			// 组装 id的集合
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		} else {
			// 单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Msg.success();
	}
}
