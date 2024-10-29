/************************************************************************************************************
Static folder tree
Copyright (C) October 2005  DTHMLGoodies.com, Alf Magne Kalleland

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Dhtmlgoodies.com., hereby disclaims all copyright interest in this script
written by Alf Magne Kalleland.

Alf Magne Kalleland, 2006
Owner of DHTMLgoodies.com
	
************************************************************************************************************/	
	
/*
* Update log:
* December, 19th, 2005 - Version 1.1: Added support for several trees on a page(Alf Magne Kalleland)
* January,  25th, 2006 - Version 1.2: Added onclick event to text nodes.(Alf Magne Kalleland)
* February, 3rd 2006 - Dynamic load nodes by use of Ajax(Alf Magne Kalleland)
* July, 2nd 2008 - refactored using object orientation to encapsulate variables 
*/

/*
* The HTML that this class manages must be arranged like:
* <ul id="tree">
*   <li>
*     <a href="#">BranchNode1</a>
*     <ul>
*       <li>
*         <a href="#">BranchNode11</a>
*         <ul>
*           <li>
*             <a href="#">LeafNode111</a>
*           </li>
*           <li>
*             <a href="#">LeafNode112</a>
*           </li>
*         </ul>
*       </li>
*       <li>
*         <a href="#">LeafNode12</a>
*       </li>
*     </ul>
*   </li>
*   <li>
*     <a href="#">BranchNode2</a>
*     <ul>
*       <li>
*         <a href="#">LeafNode21</a>
*       </li>
*       <li>
*         <a href="#">LeafNode22</a>
*       </li>
*     </ul>
*   </li>
* </ul>
* 
* which would render something like this, when fully expanded:
* 
* -BranchNode1
*   -BranchNode11
*    LeafNode111
*    LeafNode112
*   LeafNode12
* -BranchNode2
*   LeafNode21
*   LeafNode22
* 
* The init() method of this class will insert images as children of the li elements,
* immediately before the a, anchor, elements.  The li elements are referred to in the code
* as the nodes, the images that control the expansion/contraction are the nodeControls, the
* folder images (when a node has sub-nodes) are called nodeIcons.  A node with sub-nodes is
* a called a branchNode when differentiation from a leaf node is required.  The anchor element
* within the node is referred to as the nodeAnchor.
* The root element, which must be a UL element, is referred to as the rootElement. 
* 
* A new JavaScript class is defined by creating a simple function. 
* When a function is called with the new operator, the function serves as the 
* constructor for that class. Internally, JavaScript creates an Object, and then calls 
* the constructor function. Inside the constructor, the variable this is initialized to 
* point to the just created Object.
*/
function StaticTree(treeElement)
{
	// staticTreeElement is the root of the tree
	this.rootElement = treeElement;
	
	this.imageFolder = '../images/';	// Path to images
	this.folderImage = 'dhtmlgoodies_folder.gif';
	this.plusImage = 'dhtmlgoodies_plus.gif';
	this.minusImage = 'dhtmlgoodies_minus.gif';
	this.initExpandedNodes = '';	// Cookie - initially expanded nodes;
	
	this.treeUlCounter = 0;
	this.nodeId = 1;

	this.initTree();		// creates the node state and folder image elements 
	//this.initTreeState();	// set the expansion state of tree nodes
}

StaticTree.prototype.initTree = function()
{
	// The staticTreeElement, the root of the tree, must be a UL element.
	// Within the OL must be list elements, LI elements.
	var listItems = this.rootElement.getElementsByTagName('LI');	// Get an array of all list items
	for(var nodeIndex=0; nodeIndex < listItems.length; nodeIndex += 1) {					
		var node = listItems[nodeIndex];	// any LI, this may be a branch or a leaf node
		var nodeAnchor = node.getElementsByTagName('A')[0];	// the first, only, anchor within the LI element
		                                                    // the anchor tag must be there because we use it to
		                                                    // reference where we insert the outline controls
		
		// if there is no ID for the menu item then create one
		if(!node.id){ node.id = this.getNextNodeId(); }
		
		// if the user clicks on the anchor then change the expand/collapse state
		// menuItemAnchor.onclick = "studyTree.showHideNode('" + menuItem.id + "')";
		
		
		// if there is a subelement list then this must be a branch node
		// add the expansion control (+ or -) with the function call to 
		// handle node expansion/contraction
		var nodeSubMenues = node.getElementsByTagName('UL');
		var nodeSubMenu = (!nodeSubMenues) ? null : nodeSubMenues[0]; 
		var nodeControl = document.createElement('IMG');
		nodeControl.src = this.getExpandImage();
		nodeControl.setAttribute('onclick', 'studyTree.showHideNode(\'' + node.id + '\');');
		nodeControl.id = node.id + '_img';
		
		// the node has sub nodes (it is a branch)
		if(nodeSubMenu){
			nodeSubMenu.id = this.getNextBranchNodeId();
			nodeSubMenu.style.visibility='hidden';
			nodeSubMenu.style.display='none';
		}else{
			nodeControl.style.visibility='hidden';		// do not show the +,- image element
		}
		// The insertBefore method has two parameter: the child object and the brother object.
		// Insert the image as a child of the menu item, before the anchor tag
		node.insertBefore(nodeControl, nodeAnchor);
		
		
		var nodeIcon = document.createElement('IMG');
		nodeIcon.src = this.getNodeIcon(node);
		// insert the folder image as a child of the menu item, immediately before the anchor
		nodeIcon.id = node.id + '_folder';
		node.insertBefore(nodeIcon, nodeAnchor);
	}
};

StaticTree.prototype.getNodeIcon = function(node)
{
	if(node.className){
		return this.imageFolder + node.className;
	}else{
		return this.imageFolder + this.folderImage;
	}
};

StaticTree.prototype.getNextBranchNodeId = function()
{
	this.treeUlCounter += 1; 
	return 'tree_ul_' + this.treeUlCounter;
};

StaticTree.prototype.getNextNodeId = function()
{
	this.nodeId += 1; 
	return 'dhtmlgoodies_treeNode' + this.nodeId;
};

StaticTree.prototype.getExpandImage = function()
{
	return this.imageFolder + this.plusImage;
};
StaticTree.prototype.getCollapseImage = function()
{
	return this.imageFolder + this.minusImage;
};

StaticTree.prototype.initTreeState = function()
{
	// get the cookie that stores our state and reset the node state
	this.initExpandedNodes = this.GetCookie('dhtmlgoodies_expandedNodes');
	if(this.initExpandedNodes){
		var nodes = initExpandedNodes.split(',');
		for(var no=0;no<nodes.length;no += 1){
			if(nodes[no]){this.showHideNode(false,nodes[no]);}	
		}			
	}	
};

StaticTree.prototype.expandAll = function()
{
	var menuItems = this.rootElement.getElementsByTagName('LI');
	for(var no=0;no<menuItems.length;no+=1){
		var subItems = menuItems[no].getElementsByTagName('UL');
		if(subItems.length>0 && subItems[0].style.display!='block'){
			this.showHideNode(false,menuItems[no].id.replace(/[^0-9]/g,''));
		}			
	}
};

StaticTree.prototype.collapseAll = function()
{
	var menuItems = this.rootElement.getElementsByTagName('LI');
	for(var no=0;no<menuItems.length;no+=1){
		var subItems = menuItems[no].getElementsByTagName('UL');
		if(subItems.length>0 && subItems[0].style.display=='block'){
			this.showHideNode(false,menuItems[no].id.replace(/[^0-9]/g,''));
		}			
	}		
};

// a function to find an UL element that is a child of the
// LI element with the given ID
StaticTree.prototype.findBranchNodeChildList = function(node)
{
	if(! node){return null;}
	var nodeLists = node.getElementsByTagName("ul");
	var childList = nodeLists ? nodeLists[0] : null;
	
	return childList;
};

/*
* return the node with the given ID iff it is a node
* in our tree and it is a branch node (has sub-nodes).
*/
StaticTree.prototype.findListItemNodeById = function(nodeId)
{
	if(!nodeId){ return null;}
	return this.findChildListItemNodeById(this.rootElement, nodeId);
};

StaticTree.prototype.findNodeControl = function(node)
{
	if(! node){return null;}
	var nodeLists = node.getElementsByTagName("img");
	var childList = nodeLists ? nodeLists[0] : null;
	
	return childList;
};

/*
* return the node with the given ID iff it is a node
* in our tree and it is a branch node (has sub-nodes).
* a recursive function to find a LI element with the given ID
* within a UL element
*/
StaticTree.prototype.findChildListItemNodeById = function(listElement, nodeId)
{
	if(!nodeId){ return null; }
	if(!listElement || !listElement.childNodes){ return null;}

	var node = document.getElementById(nodeId);
	var ancestor=node.parentNode;
	while(ancestor.nodeName != 'body') {
		if(ancestor == listElement){return node;}
		ancestor = ancestor.parentNode;
	}
	
	return null;
};

// Showing or hiding a node effectively means setting the visibility
// of the nodes submenu.
// We do this in two steps, 1 is to get the node itself and then 2 is
// to get the submenu (if it exists).
StaticTree.prototype.showHideNode = function(nodeId)
{
	//alert('Showing or hiding ' + nodeId);
	var branchNode = this.findListItemNodeById(nodeId);
	var branchNodeChildList = this.findBranchNodeChildList(branchNode);
	var branchNodeControl = this.findNodeControl(branchNode);
	
	if(branchNodeChildList && (branchNodeChildList.style.visibility=='hidden' || branchNodeChildList.style.display=='none') )
	{
		if(branchNodeChildList){branchNodeChildList.style.display='block';branchNodeChildList.style.visibility="visible";}
		if(branchNodeControl){branchNodeControl.src = this.getCollapseImage();}
		return true;
	}
	else
	{
		if(branchNodeChildList){branchNodeChildList.style.display='none';branchNodeChildList.style.visibility="hidden";}
		if(branchNodeControl){branchNodeControl.src = this.getExpandImage();}
		return false;
	}
};

/*
	//inputId = parentNode.id.replace(/[^0-9]/g,'');
	if( thisNode.src.indexOf(plusImage) >= 0 ) {
		// replace the plusImage source with the minusImage source,
		// i.e. replace the string 'dhtmlgoodies_plus.gif'; with the string 'dhtmlgoodies_minus.gif'
		thisNode.src = thisNode.src.replace( this.getExpandImage(), this.getCollapseImage() );
		
		var ul = parentNode.getElementsByTagName('UL')[0];
		ul.style.display='block';
		
		// set the list of expanded nodes to include this newly visible node 
		if(!initExpandedNodes){initExpandedNodes = ',';}
		if(initExpandedNodes.indexOf(',' + inputId + ',')<0){ initExpandedNodes = initExpandedNodes + inputId + ',';}
		
	} else {
		// replace the minusImage source with the plusImage source,
		// i.e. replace the string 'dhtmlgoodies_minus.gif' with the string 'dhtmlgoodies_plus.gif'
		thisNode.src = thisNode.src.replace(this.getCollapseImage(), this.getExpandImage());
		
		parentNode.getElementsByTagName('UL')[0].style.display='none';
		
		// set the list of expanded nodes to exclude this newly hidden node 
		initExpandedNodes = initExpandedNodes.replace(',' + inputId,'');
	}
	
	// set the cookie that remembers the node expansion state	
	this.SetCookie('dhtmlgoodies_expandedNodes',initExpandedNodes,500);
*/

/*
These cookie functions are downloaded from 
http://www.mach5.com/support/analyzer/manual/html/General/CookiesJavaScript.htm
*/
StaticTree.prototype.GetCookie = function (name) 
{ 
   var start = document.cookie.indexOf(name+"="); 
   var len = start+name.length+1; 
   if ((!start) && (name != document.cookie.substring(0,name.length))) {return null;} 
   if (start == -1) {return null;} 
   var end = document.cookie.indexOf(";",len); 
   if (end == -1) {end = document.cookie.length;} 
   return unescape(document.cookie.substring(len,end)); 
};
 
// This function has been slightly modified
StaticTree.prototype.SetCookie = function(name,value,expires,path,domain,secure) { 
	expires = expires * 60*60*24*1000;
	var today = new Date();
	var expires_date = new Date( today.getTime() + (expires) );
    var cookieString = name + "=" +escape(value) + 
       ( (expires) ? ";expires=" + expires_date.toGMTString() : "") + 
       ( (path) ? ";path=" + path : "") + 
       ( (domain) ? ";domain=" + domain : "") + 
       ( (secure) ? ";secure" : ""); 
    document.cookie = cookieString; 
};


