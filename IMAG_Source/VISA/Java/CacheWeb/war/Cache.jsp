<%@ page language="java" import="java.util.*"
	import="gov.va.med.cache.*" import="gov.va.med.cache.gui.shared.*"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://imaging.med.va.gov/cache/functions" prefix="f"%>

<jsp:useBean id="itemPath"
	class="gov.va.med.cache.gui.shared.CacheItemPath" scope="request" />

<jsp:setProperty name="itemPath" property="cacheName" param="cache" />
<jsp:setProperty name="itemPath" property="regionName" param="region" />
<jsp:setProperty name="itemPath" property="groupNames" param="group" />
<jsp:setProperty name="itemPath" property="instanceName"
	param="instance" />

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
	+ request.getServerName() + ":" + request.getServerPort()
	+ path + "/";
	request.setAttribute("metadata",
	CacheManagementService.resolveMetadata(itemPath));
	List<AbstractNamedVO> children = CacheManagementService
	.resolveChildren(itemPath);
	request.setAttribute("children", children);
	request.setAttribute("numChildren", children.size());
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<title>VIX Cache Manager</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
</head>

<body>
	<header>
		<h1>VIX Cache Manager</h1>
		<script type="text/javascript" src="scripts/jquery-1.9.1.min.js"></script>
		<script type="text/javascript">
			function deleteItem(item) {
				var confirmQuestion = "Are you sure you want to delete " + item
						+ "?";
				if (confirm(confirmQuestion)) {
					$
							.ajax({
								url : 'cacheitem' + item,
								type : 'DELETE',
								success : function(data, textStatus, jqXHR) {
									var message = this.url.substring(this.url
											.indexOf("/"));
									message += " has been queued for deletion."
											+ " The cache may take a minute to actually delete the item.";
									alert(message);
									window.location.assign("Cache.jsp?" + data);
								},
								error : function(jqXHR, textStatus, errorThrown) {
									alert("error: " + errorThrown + " "
											+ this.url);
								}
							});
				}
			}
		</script>
	</header>
	<c:if test="${itemPath.cacheName != null}">
		<div role="navigation">
			<a href="Cache.jsp">Home</a>
			<c:forEach var="breadCrumb" items="${itemPath.ancestors}">
				<a href="Cache.jsp?${f:buildQueryString(breadCrumb) }">${breadCrumb.name}</a>:
			</c:forEach>
			${itemPath.name}
		</div>
		<section id="details">
			<c:choose>
				<c:when test='${ itemPath.itemType == "cache" }'>
					<h3>Cache Information</h3>
					<table>
						<tr>
							<td>URI:</td>
							<td>${metadata.cacheUri}</td>
						</tr>
						<tr>
							<td>Location:</td>
							<td>${metadata.location}</td>
						</tr>
						<tr>
							<td>Protocol:</td>
							<td>${metadata.protocol}</td>
						</tr>
					</table>
				</c:when>
				<c:when test='${ itemPath.itemType == "region" }'>
					<h3>Region Information</h3>
					<table>
						<tr>
							<td>Total Space:</td>
							<td>${metadata.totalSpaceFormatted}</td>
						</tr>
						<tr>
							<td>Used Space:</td>
							<td>${metadata.usedSpaceFormatted}</td>
						</tr>
					</table>
				</c:when>
				<c:when test='${ itemPath.itemType == "group" }'>
					<h3>Group Information</h3>
					<table>
						<tr>
							<td>Size:</td>
							<td>${metadata.sizeFormatted}</td>
						</tr>
						<%-- <tr>
							<td>Created:</td>
							<td>${metadata.createDate}</td>
						</tr> --%>
						<tr>
							<td>Last Accessed:</td>
							<td>${metadata.lastAccessDate}</td>
						</tr>
						<tr>
							<td>Type:</td>
							<td>${f:getGroupSemanticType(itemPath.cacheName,
								itemPath.regionName, fn:length(itemPath.groupNames) - 1)}</td>
						</tr>
					</table>
					<input type="button" value="Delete"
						onClick="deleteItem('${f:createPathInfo(itemPath)}')" />
				</c:when>
				<c:when test='${ itemPath.itemType == "instance" }'>
					<h3>Instance Information</h3>
					<table>
						<tr>
							<td>Size:</td>
							<td>${metadata.sizeFormatted}</td>
						</tr>
						<%-- <tr>
							<td>Created:</td>
							<td>${metadata.createDate}</td>
						</tr> --%>
						<tr>
							<td>Last Accessed:</td>
							<td>${metadata.lastAccessDate}</td>
						</tr>
						<%-- <tr>
							<td>Media Type:</td>
							<td>${metadata.mediaType}</td>
						</tr> --%>
						<tr>
							<td>Checksum:</td>
							<td>${metadata.checksum}</td>
						</tr>
						<tr>
							<td>Type:</td>
							<td>${f:getInstanceSemanticType(itemPath.cacheName,
								itemPath.regionName)}</td>
						</tr>
					</table>
					<input type="button" value="Delete"
						onClick="deleteItem('${f:createPathInfo(itemPath)}')" />
				</c:when>
			</c:choose>
		</section>
	</c:if>
	<c:if test="${ itemPath.instanceName == null }">
		<section id="children">
			<h3>Contents</h3>
			<c:choose>
				<c:when test='${ numChildren > 0 }'>
					<div style="margin-left: 50px">
						<table>
							<c:forEach var="child" items="${children}">
								<tr>
									<c:if
										test='${ child.path.itemType == "group" || child.path.itemType == "instance" }'>
										<td><input type="button" value="Delete"
											onClick="deleteItem('${f:createPathInfo(child.path)}')" />
										</td>
									</c:if>
									<td><a
										href="Cache.jsp?${f:buildQueryString(child.path) }">${
											child.name}</a></td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</c:when>
				<c:when test='${ numChildren == 0 }'>Empty</c:when>
			</c:choose>
		</section>
	</c:if>
</body>
</html>
