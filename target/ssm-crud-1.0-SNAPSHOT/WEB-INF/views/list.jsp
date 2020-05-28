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
	<title>员工列表</title>
	<%
		pageContext.setAttribute("APP_PATH", request.getContextPath());

		/** 关于路径问题：
		 * 		不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
		 * 		以/开始的相对路径，找资源是以服务器的路径为标准的 (http://localhost:8080);需要加上项目名
		 * 			http://localhost:8080/ssm-crud
		 */
	%>
	<!-- 引入bootstrap -->
	<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
	<!-- 引入jquery -->
	<script src="${APP_PATH }/static/js/jquery-1.12.4.min.js" type="text/javascript"></script>
</head>
<body>
	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题行 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 增加和删除按钮行 -->
		<div class="row">
			<div class="col-md-2 col-md-offset-10">
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<hr>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<tr>
						<th>#</th>
						<th>empName</th>
						<th>gender</th>
						<th>email</th>
						<th>deptName</th>
						<th>操作</th>
					</tr>
					<c:forEach items="${pageInfo.list }" var="emp">
						<tr>
							<td>${emp.empId}</td>
							<td>${emp.empName}</td>
							<td>${emp.gender == "M"?"男":"女"}</td>
							<td>${emp.email}</td>
							<td>${emp.department.deptName}</td>
							<td>
								<button class="btn btn-primary btn-sm">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
									编辑</button>
								<button class="btn btn-danger btn-sm">
									<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
									删除</button>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<hr/>
		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 显示分页文字信息 -->
			<div class="col-md-4">当前第${pageInfo.pageNum}页，总${pageInfo.pages}页，总计${pageInfo.total}条记录</div>
			<!-- 分页条信息 -->
			<div class="col-md-8">
				<nav aria-label="Page navigation">
					<ul class="pagination">
						<li><a href="${APP_PATH}/emps?pn=1">首页</a></li>

						<c:if test="${pageInfo.hasPreviousPage }">
							<li>
								<a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1 }" aria-label="Previous">
									<span aria-hidden="true">&laquo;</span>
								</a>
							</li>
						</c:if>

						<c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
							<c:choose>
								<c:when test="${pageInfo.pageNum == page_Num}">
									<li class="active"><a href="#">${page_Num }</a></li>
								</c:when>
								<c:otherwise>
									<li><a href="${APP_PATH }/emps?pn=${page_Num }">${page_Num }</a></li>
								</c:otherwise>
							</c:choose>
						</c:forEach>

						<c:if test="${pageInfo.hasNextPage }">
							<li>
								<a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1 }" aria-label="Next">
									<span aria-hidden="true">&raquo;</span>
								</a>
							</li>
						</c:if>
						<li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>
					</ul>
				</nav>
			</div>
		</div>
	</div>

</body>
</html>
