<%--
  Created by IntelliJ IDEA.
  User: Double_Xu
  Date: 2018/6/10
  Time: 11:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
	<title>SSM框架CRUD操作模版</title>
	<%
		pageContext.setAttribute("APP_PATH", request.getContextPath());

		/** 关于路径问题：
		 * 		不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
		 * 		以/开始的相对路径，找资源是以服务器的路径为标准的 (http://localhost:8080);需要加上项目名
		 * 			http://localhost:8080/ssm-crud
		 * 		通过request.getContextPath获得的APP_PATH的值是 /ssm-crud
		 */
	%>
	<!-- 引入jquery -->
	<script src="${APP_PATH }/static/js/jquery-1.12.4.min.js" type="text/javascript"></script>
	<!-- 引入bootstrap -->
	<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
	<style type="text/css">
		#emps_table , #emps_table th{
			text-align: center;
		}
	</style>
</head>
<body>
<!-- 修改员工信息的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">员工修改</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">empName</label>
						<div class="col-sm-10">
							<p class="form-control-static" id="empName_update_static"></p>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">email</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="email" id="email_update_input" placeholder="email@126.com">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">gender</label>
						<div class="col-sm-10">
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_update_input" value="F"> 女
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">deptName</label>
						<div class="col-sm-4">
							<%-- 部门提交部门id即可 --%>
							<select class="form-control" name="dId">

							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
				<button type="button" class="btn btn-primary" id="emp_update_btn">更 新</button>
			</div>
		</div>
	</div>
</div>

<!-- 添加员工的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">添加员工</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">empName</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="empName" id="empName_add_input" placeholder="empName">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">email</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" name="email" id="email_add_input" placeholder="email@126.com">
							<span class="help-block"></span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">gender</label>
						<div class="col-sm-10">
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_add_input" value="F"> 女
							</label>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">deptName</label>
						<div class="col-sm-4">
							<%-- 部门提交部门id即可 --%>
							<select class="form-control" name="dId" id="dept_add_select">

							</select>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关 闭</button>
				<button type="button" class="btn btn-primary" id="emp_save_btn">保 存</button>
			</div>
		</div>
	</div>
</div>

<!-- 搭建显示页面 -->
<div class="container">
	<!-- 标题行 -->
	<div class="row">
		<div class="col-md-12">
			<h1>SSM-CRUD模版</h1>
		</div>
	</div>
	<!-- 增加和删除按钮行 -->
	<div class="row">
		<div class="col-md-2 col-md-offset-10">
			<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
			<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
		</div>
	</div>
	<div style="width:auto; border:1px solid #FFFFFF;margin: 10px 0px"></div>
	<!-- 显示表格数据 -->
	<div class="row">
		<div class="col-md-12">
			<table class="table table-hover" id="emps_table">
				<thead style="border-top:2px solid #dddddd;text-align: center;">
					<th>
						<input type="checkbox" id="check_all" />
					</th>
					<th>#</th>
					<th>empName</th>
					<th>gender</th>
					<th>email</th>
					<th>deptName</th>
					<th>操作</th>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	<div style="width:auto; border:0.5px solid #dddddd;margin-top: -20px"></div>
	<!-- 显示分页信息 -->
	<div class="row">
		<!-- 显示分页文字信息 -->
		<div class="col-md-4" id="page_info_area"></div>
		<!-- 分页条信息 -->
		<div class="col-md-8 col-md-offset-4" id="page_nav_area"></div>
	</div>
</div>

	<script type="text/javascript">

		var totalRecord,currentPage;
		// 1. 页面加载完成以后，直接去发送 ajax 请求，要到分页数据
		$(function () {
			// 去首页
			to_page(1);
		});

		function to_page(pn) {
			$("#check_all").prop("checked", false);
			$.ajax({
				url: "${APP_PATH}/emps",
				data : "pn="+pn,
				type:"GET",
				success:function (result) {
					// console.log(result);
					// 1. 解析并显示员工信息
					build_emps_table(result);
					// 2. 解析并显示分页信息
					build_page_info(result);
					// 3. 解析并显示分页条数据
					build_page_nav(result);
				}
			});

		}

		function build_emps_table(result) {
			// 添加前清空表格
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps,function (index,item) {
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department.deptName);
				/** 添加操作的两个按钮
				 <td>
				 <button class="btn btn-primary btn-sm">
				 <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
				 编辑</button>
				 <button class="btn btn-danger btn-sm">
				 <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
				 删除</button>
				 </td>
				 */
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				// 为编辑按钮添加一个自定义的属性，来表示当前员工的 id
				editBtn.attr("edit-id", item.empId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				// 为删除按钮添加一个自定义的属性，来表示当前员工的 id
				delBtn.attr("del-id", item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				// 须知：append 方法执行完成以后还是返回原来的元素
				$("<tr></tr>").append(checkBoxTd)
					.append(empIdTd)
					.append(empNameTd)
					.append(genderTd)
					.append(emailTd)
					.append(deptNameTd)
					.append(btnTd)
					.appendTo("#emps_table tbody");
			})
		}

		// 解析显示分页信息
		function build_page_info(result) {
			// 清空分页信息
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总"+
				result.extend.pageInfo.pages+"页,总"+
				result.extend.pageInfo.total+"条记录");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}

		// 解析显示分页条
		function build_page_nav(result) {
			// page_nav_area
			// 构建之前清空现有的信息
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				// 为首页和前一页添加点击事件
				firstPageLi.click(function () {
					to_page(1);
				});
				prePageLi.click(function () {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}


			// 添加首页和前一页的提示
			ul.append(firstPageLi).append(prePageLi);
			// 添加所显示的页码提示
			$.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				// 点击页码后的跳转事件
				numLi.click(function () {
					to_page(item);
				});
				ul.append(numLi);
			});
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
			if (result.extend.pageInfo.hasNextPage == false) {
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				// 为末页和下一页添加点击事件
				nextPageLi.click(function () {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				lastPageLi.click(function () {
					to_page(result.extend.pageInfo.pages);
				});
			}

			// 添加下一页和末页的提示
			ul.append(nextPageLi).append(lastPageLi);

			// 把 ul加入到 nav
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}

		// 清空表单样式及内容
		function reset_form(ele) {
			// 利用 DOM 的 reset方法重置表单数据
			$(ele)[0].reset();
			// 清空表单样式
			$(ele).find("*").removeClass("has-success has-error");
			$(ele).find(".help-block").text("");
		}

		//点击新增按钮弹出模态框
		$("#emp_add_modal_btn").click(function () {
			// 清除表单数据（表单完整重置：表单数据和表单样式）
			$("#empAddModal form")[0].reset();
			reset_form("#empAddModal form");
			// 发送ajax请求，查出部门信息，显示在下拉列表中
			getDepts("#empAddModal select");
			// 弹出模态框
			$('#empAddModal').modal({
				backdrop : "static"
			});
		});

		// 查出所有的部门信息并显示在下拉列表中
		function getDepts(ele) {
			// 清空之前下拉列表的值
			$(ele).empty();
			$.ajax({
				async : false,
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function (result) {
					// {"code":100,"msg":"处理成功!","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
					// console.log(result);
					// 显示部门信息在下拉列表中
					// $("#dept_add_select").append();

					$.each(result.extend.depts,function () {
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo(ele);
					})
				}
			})
		}
		
		// 校验表单数据
		function validate_add_form() {
			// 1.拿到校验的用户名数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				//alert("用户名可以是2-5位中文或者6-16位英文");
				show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文");
				return false;
			}else{
				show_validate_msg("#empName_add_input", "success", "");
			}

			// 2.拿到邮箱信息，校验邮箱信息
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test(email)){
				//alert("邮箱格式不正确！");
				// 应该清空这个元素之前的样式
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确!");
				return false;
			}else{
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}
		// 显示校验结果的提示信息
		function show_validate_msg(ele,status,msg) {
			// 清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if ("success" == status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if ("error" == status) {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}

		$("#empName_add_input").change(function () {
			// 发送ajax请求，校验用户名是否可用
			var empName = this.value;
			$.ajax({
				url : "${APP_PATH}/checkuser",
				data : "empName="+empName,
				type : "POST",
				success : function (result) {
					if (result.code == 100) {
						show_validate_msg("#empName_add_input","success","用户名可用！");
						$("#emp_save_btn").attr("ajax-va", "success");
					} else{
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va", "error");
					}
				}
			})
		});

		// 点击保存，保存员工
		$("#emp_save_btn").click(function () {
			// 1. 将模态框中填写的表单数据提交给服务器进行保存

			// (1). 判断之前的ajax用户名的校验是否成功，如果成功再进行保存
			if ($(this).attr("ajax-va") == "error") {
				return false;
			}
			// (2). 先对要提交给服务器的数据进行校验
			if (!validate_add_form()) {
				return false;
			}
			// (3). 发送ajax请求保存员工
			$.ajax({
				url : "${APP_PATH}/emp",
				type : "POST",
				data : $("#empAddModal form").serialize(),
				success : function (result) {
					// alert(result.msg);
					if (result.code == 100) {
						// 员工保存成功：
						// 1.关闭模态框；
						$("#empAddModal").modal('hide');
						// 2.来到最后一页，显示保存的数据
						// 发送ajax请求显示最后一页数据即可
						to_page(totalRecord);
					}else {
						// 显示失败信息
						// console.log(result);
						// 有哪个字段的错误信息就显示哪个字段的
						if (undefined != result.extend.errorFields.email) {
							// 显示邮箱错误信息
							show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
						}
						if (undefined != result.extend.errorFields.empName) {
							// 显示员工名字的错误信息
							show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
						}
					}

				}
			});
		});


		// 1. 如果直接用$(".edit_btn")来绑定事件，是绑不上的，因为事件在创建之前
		// 解决办法：1）可以在创建按钮时绑定，但是耦合太大；  2）可以绑定 .live()
		// jQuery新版没有live，使用on进行替代；
		$(document).on("click",".edit_btn",function () {
			// alert("edit");
			// 1. 查出员工信息，显示员工信息
			getDepts("#empUpdateModal select");
			// 2.查出部门信息，并显示部门列表
			getEmp($(this).attr("edit-id"));
			// 3.将员工的id传递给模态框的更新按钮（通过给按钮添加属性实现）
			$("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));

			// 弹出模态框
			$("#empUpdateModal").modal({
				backdrop : "static"
			});
		});

		function getEmp(id) {
			$.ajax({
				url: "${APP_PATH}/emp/" + id,
				type : "GET",
				success : function (result) {
					// console.log(result);
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empUpdateModal input[name=gender]").val([empData.gender]);
					$("#empUpdateModal select[name=dId]").val([empData.dId]);
				}
			});
		}

		// 点击更新，更新员工信息
		$("#emp_update_btn").click(function () {
			// 1. 校验邮箱是否合法
			var email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if (!regEmail.test(email)){
				//alert("邮箱格式不正确！");
				// 应该清空这个元素之前的样式
				show_validate_msg("#email_update_input", "error", "邮箱格式不正确!");
				return false;
			}else{
				show_validate_msg("#email_update_input", "success", "");
			}

			// 2. 发送ajax请求保存更新的数据
			$.ajax({
				url : "${APP_PATH}/emp/" + $(this).attr("edit-id"),
				type : "PUT",
				data : $("#empUpdateModal form").serialize(),
				success : function (result) {
					// alert(result.msg);
					// 1. 关闭对话框
					$("#empUpdateModal").modal("hide");
					// 2. 回到本页面
					to_page(currentPage);
				}
			});
		});

		// 单个删除员工数据
		$(document).on("click",".delete_btn",function () {
			// 1. 弹出确认是否删除对话框
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del-id");
			// alert($(this).parents("tr").find("td:eq(2)").text());
			if (confirm("确认删除【"+empName+"】吗？")){
				// 确认，发送ajax请求删除即可
				$.ajax({
					url : "${APP_PATH}/emp/" + empId,
					type : "DELETE",
					success : function (result) {
						alert(result.msg);
						// 回到本页
						to_page(currentPage);
					}
				});
			}
		});

		// 完成全选、全部选功能
		$("#check_all").click(function () {
			// attr 获取 checked是 undefined；
			// 这些原生的 dom的属性，attr获取自定义属性
			// 使用 prop修改和读取 dom原生属性的值
			$(".check_item").prop("checked", $(this).prop("checked"));
		});
		// 为 check_item绑定事件，使单个都选中时选中 check_all按钮
		$(document).on("click",".check_item",function () {
			// 判断当前选中的元素是否是5个
			var flag = $(".check_item:checked").length == $(".check_item").length;
			$("#check_all").prop("checked", flag);
		});

		// 点击全部删除，就批量删除
		$("#emp_delete_all_btn").click(function () {
			// 找到每一个被选中的数据的empName
			var empNames = "";
			var del_idstr = "";
			$.each($(".check_item:checked"),function () {
				// 组装员工名字的字符串
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				// 组装员工 id字符串
				del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-"
			});
			// 去除最后多余的一个,/-
			empNames = empNames.substring(0, empNames.length-1);
			del_idstr = del_idstr.substring(0, del_idstr.length-1);
			if (confirm("确认删除【"+empNames+"】吗？")){
				// 发送 ajax请求
				$.ajax({
					url : "${APP_PATH}/emp/" + del_idstr,
					type : "DELETE",
					success : function (result) {
						alert(result.msg);
						// 回到当前页面
						to_page(currentPage);
					}
				})
			}
		})

	</script>

</body>
</html>
