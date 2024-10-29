using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRTree : DSRTreeNodeCursor
    {
        //Static variable
        private static int IdentCounter = 1;

        //Object for DSRTreeNodeCursor
        public DSRTreeNodeCursor dsrTreeNodeCursor;

        //Object for DSRTreeNode
        private DSRTreeNode RootNode;

        /// <summary>
        /// Constructor
        /// </summary>
        public DSRTree()
        {
            dsrTreeNodeCursor = new DSRTreeNodeCursor();
            RootNode = null;
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRTree()
        {
            clear();
        }

        /// <summary>
        /// Get the DSRTreeNode root node
        /// </summary>
        /// <returns></returns>
        protected DSRTreeNode getRoot()
        {
            return RootNode;
        }

        /// <summary>
        /// checks whether empty or not
        /// </summary>
        /// <returns></returns>
        public bool isEmpty()
        {
            return (RootNode == null);
        }

        /// <summary>
        /// Clear the root/remove node
        /// </summary>
        public virtual void clear()
        {
            if (gotoRoot() == 1)
                removeNode();
        }

        /// <summary>
        /// Sets the cursor
        /// </summary>
        /// <returns></returns>
        public int gotoRoot()
        {
            return setCursor(RootNode);
        }

        /// <summary>
        /// Gets the root node using search ID
        /// </summary>
        /// <param name="searchID"></param>
        /// <param name="startFromRoot"></param>
        /// <returns></returns>
        public int gotoNode(int searchID, bool startFromRoot = true)
        {
            int nodeID = 0;
            if (searchID > 0)
            {
                if (startFromRoot)
                    gotoRoot();
                nodeID = dsrTreeNodeCursor.gotoNode(searchID);
            }
            return nodeID;
        }

        /// <summary>
        /// Goto the node 
        /// </summary>
        /// <param name="reference"></param>
        /// <param name="startFromRoot"></param>
        /// <returns></returns>
        public int gotoNode(ref string reference, bool startFromRoot = true)
        {
            int nodeID = 0;
            if (!(String.IsNullOrEmpty(reference)))
            {
                if (startFromRoot)
                    gotoRoot();
                nodeID = dsrTreeNodeCursor.gotoNode(ref reference);
            }
            return nodeID;
        }

        /// <summary>
        /// Adds the node
        /// </summary>
        /// <param name="node"></param>
        /// <param name="addMode"></param>
        /// <returns></returns>
        public int addNode(DSRTreeNode node, E_AddMode addMode)
        {
            int nodeID = 0;
            if (node != null)
            {
                if (NodeCursor != null)
                {
                    switch (addMode)
                    {
                        case E_AddMode.AM_afterCurrent:
                            node.Prev = NodeCursor;
                            node.Next = NodeCursor.Next;
                            NodeCursor.Next = node;
                            ++Position;
                            break;
                        case E_AddMode.AM_beforeCurrent:
                            node.Prev = NodeCursor.Prev;
                            node.Next = NodeCursor;
                            NodeCursor.Prev = node;
                            break;
                        case E_AddMode.AM_belowCurrent:
                            /* store old position */
                            if (Position > 0)
                            {
                                PositionList.Insert(0, Position);
                                Position = 1;
                            }
                            NodeCursorStack.Push(NodeCursor);
                            /* parent node has already child nodes */
                            if (NodeCursor.Down != null)
                            {
                                DSRTreeNode tempNode = NodeCursor.Down;
                                /* goto last node (sibling) */
                                while (tempNode.Next != null)
                                {
                                    tempNode = tempNode.Next;
                                    ++Position;
                                }
                                tempNode.Next = node;
                                node.Prev = tempNode;
                            }
                            else
                                NodeCursor.Down = node;
                            break;
                    }
                    NodeCursor = node;
                }
                else
                {
                    RootNode = NodeCursor = node;
                    Position = 1;
                }
                nodeID = NodeCursor.Ident;
            }
            return nodeID;
        }

        /// <summary>
        /// Removes the node
        /// </summary>
        /// <returns></returns>
        public int removeNode()
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                DSRTreeNode cursor = NodeCursor;

                /* extract current node (incl. subtree) from tree */

                /* are there any siblings? */
                if ((cursor.Prev != null) || (cursor.Next != null))
                {
                    /* connect to previous node */
                    if (cursor.Prev != null)
                    {
                        (cursor.Prev).Next = cursor.Next;
                    }
                    else
                    {
                        /* is there any direct parent node? */
                        if (NodeCursorStack.Count > 0)
                        {
                            DSRTreeNode parent = NodeCursorStack.Peek();
                            if (parent != null)
                                parent.Down = cursor.Next;
                        }
                    }
                    /* connect to next node */
                    if (cursor.Next != null)
                    {
                        (cursor.Next).Prev = cursor.Prev;
                        if (NodeCursor == RootNode)
                            RootNode = cursor.Next;        // old root node deleted
                        NodeCursor = cursor.Next;
                    }
                    else
                    {
                        /* set cursor to previous node since there is no next node */
                        NodeCursor = cursor.Prev;
                        --Position;
                    }
                }
                else
                {
                    /* no siblings: check for child nodes */
                    if (NodeCursorStack.Count > 0)
                    {
                        NodeCursor = NodeCursorStack.Peek();
                        NodeCursorStack.Pop();
                        Position = PositionList.LastOrDefault();
                        PositionList.RemoveAt(Position);
                        /* should never be NULL, but ... */
                        if (NodeCursor != null)
                            NodeCursor.Down = null;
                        else
                        {
                            RootNode = null;                // tree is now empty
                            Position = 0;
                        }
                    }
                    else
                    {
                        RootNode = NodeCursor = null;       // tree is now empty
                        Position = 0;
                        PositionList.Clear();
                    }
                }

                /* remove references to former siblings */
                cursor.Prev = null;
                cursor.Next = null;

                /* delete all nodes from extracted subtree */
                /* (this routine might also use the "new" DSRTreeNodeCursor class) */

                DSRTreeNode delNode = null;
                Stack<DSRTreeNode> cursorStack = new Stack<DSRTreeNode>();
                while (cursor != null)
                {
                    delNode = cursor;
                    if (cursor.Down != null)
                    {
                        if (cursor.Next != null)
                            cursorStack.Push(cursor.Next);
                        cursor = cursor.Down;
                    }
                    else if (cursor.Next != null)
                        cursor = cursor.Next;
                    else if (cursorStack.Count > 0)
                    {
                        cursor = cursorStack.Peek();
                        cursorStack.Pop();
                    }
                    else
                        cursor = null;
                    delNode = null;
                }

                if (NodeCursor != null)
                    nodeID = NodeCursor.Ident;
            }
            return nodeID;
        }
    };

    public class DSRTreeNode : DSRTypes
    {
        // pointer to previous tree node (if any)
        public DSRTreeNode Prev;

        // pointer to next tree node (if any)
        public DSRTreeNode Next;

        // pointer to first child node (if any)
        public DSRTreeNode Down;

        // unique identifier (created automatically)
        public int Ident;

        // global counter used to create the unique identifiers
        private static int IdentCounter = 1;

        /// <summary>
        /// constructor
        /// </summary>
        public DSRTreeNode(int ident = 0)
        {
            Prev = null;
            Next = null;
            Down = null;
            if (ident == 0)
            {
                Ident = IdentCounter++;
            }
        }

        /// <summary>
        /// destructor
        /// </summary>
        ~DSRTreeNode()
        {
        }
    };
}
