using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    /// <summary>
    /// class DSRTreeNodePointer
    /// </summary>
    public class DSRTreeNodePointer : DSRTreeNode
    {
    };

    /// <summary>
    /// class DSRTreeNodeCursor
    /// </summary>
    public class DSRTreeNodeCursor : DSRTypes
    {
        // pointer current node
        protected DSRTreeNode NodeCursor;

        // stack of node pointers. Used to store the cursor position of upper levels.
        protected Stack<DSRTreeNode> NodeCursorStack;

        // current position within the current level
        protected int Position;

        // list of position counters in upper levels
        protected List<int> PositionList;

        /// <summary>
        /// Constructor
        /// </summary>
        public DSRTreeNodeCursor()
        {
            NodeCursor = new DSRTreeNode(1);
            NodeCursorStack = new Stack<DSRTreeNode>();
            Position = 0;
            PositionList = new List<int>();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="cursor"></param>
        public DSRTreeNodeCursor(ref DSRTreeNodeCursor cursor)
        {
            NodeCursor = cursor.NodeCursor;
            NodeCursorStack = cursor.NodeCursorStack;
            Position = cursor.Position;
            PositionList = cursor.PositionList;
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="node"></param>
        public DSRTreeNodeCursor(DSRTreeNode node)
        {
            NodeCursor = node;
            NodeCursorStack = new Stack<DSRTreeNode>();
            if (node != null)
            {
                Position = 1;
            }
            else
            {
                Position = 0;
            }
            PositionList = new List<int>();
        }

        /// <summary>
        /// Destructor
        /// </summary>
        ~DSRTreeNodeCursor()
        {
        }

        /// <summary>
        /// Gets the node cursor of DSRTreeNode
        /// </summary>
        /// <returns></returns>
        public DSRTreeNode getNode()
        {
            return NodeCursor;
        }

        /// <summary>
        /// Check whether the node cursor is valid or not
        /// </summary>
        /// <returns></returns>
        public bool isValid()
        {
            return (NodeCursor != null);
        }

        /// <summary>
        /// Clears the node and stack
        /// </summary>
        public void clear()
        {
            NodeCursor = null;
            clearNodeCursorStack();
            Position = 0;
            PositionList.Clear();
        }

        /// <summary>
        /// Clears the node cursor stack
        /// </summary>
        protected void clearNodeCursorStack()
        {
            while (NodeCursorStack.Count > 0)
                NodeCursorStack.Pop();
        }

        /// <summary>
        /// Gets the parent node
        /// </summary>
        /// <returns></returns>
        public DSRTreeNode getParentNode()
        {
            DSRTreeNode node = null;
            if (NodeCursorStack.Count > 0)
                node = NodeCursorStack.Peek();
            return node;
        }

        /// <summary>
        /// Gets the next node
        /// </summary>
        /// <returns></returns>
        public DSRTreeNode getNextNode()
        {
            DSRTreeNode node = null;
            if (NodeCursor != null)
                return NodeCursor.Next;
            return node;
        }

        /// <summary>
        /// Sets the cursor
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        protected int setCursor(DSRTreeNode node)
        {
            int nodeID = 0;
            NodeCursor = node;
            clearNodeCursorStack();
            PositionList.Clear();
            if (NodeCursor != null)
            {
                nodeID = NodeCursor.Ident;
                Position = 1;
            }
            else
                Position = 0;
            return nodeID;
        }

        /// <summary>
        /// Goes to the previous node
        /// </summary>
        /// <returns></returns>
        public int gotoPrevious()
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                if (NodeCursor.Prev != null)
                {
                    NodeCursor = NodeCursor.Prev;
                    nodeID = NodeCursor.Ident;
                    --Position;
                }
            }
            return nodeID;
        }


        /// <summary>
        /// Goes to the next node
        /// </summary>
        /// <returns></returns>
        public int gotoNext()
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                if (NodeCursor.Next != null)
                {
                    NodeCursor = NodeCursor.Next;
                    nodeID = NodeCursor.Ident;
                    ++Position;
                }
            }
            return nodeID;
        }


        /// <summary>
        /// Goes top to the node
        /// </summary>
        /// <returns></returns>
        public int goUp()
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                if (NodeCursorStack.Count > 0)
                {
                    DSRTreeNode cursor = NodeCursorStack.Peek();
                    NodeCursorStack.Pop();
                    if (cursor != null)
                    {
                        NodeCursor = cursor;
                        nodeID = NodeCursor.Ident;
                        if (PositionList.Count > 0)
                        {
                            Position = PositionList.LastOrDefault();
                            PositionList.RemoveAt(Position);
                        }
                    }
                }
            }
            return nodeID;
        }

        /// <summary>
        /// Goes down to the node
        /// </summary>
        /// <returns></returns>
        public int goDown()
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                if (NodeCursor.Down != null)
                {
                    NodeCursorStack.Push(NodeCursor as DSRTreeNodePointer);
                    NodeCursor = NodeCursor.Down;
                    nodeID = NodeCursor.Ident;
                    if (Position > 0)
                    {
                        PositionList.Insert(0, Position);
                        Position = 1;
                    }
                }
            }
            return nodeID;
        }

        /// <summary>
        /// Iterates the node
        /// </summary>
        /// <param name="searchIntoSub"></param>
        /// <returns></returns>
        public int iterate(bool searchIntoSub = true)
        {
            int nodeID = 0;
            if (NodeCursor != null)
            {
                /* perform "deep search", if specified */
                if (searchIntoSub && (NodeCursor.Down != null))
                {
                    NodeCursorStack.Push(NodeCursor);
                    NodeCursor = NodeCursor.Down;
                    nodeID = NodeCursor.Ident;
                    if (Position > 0)
                    {
                        PositionList.Insert(0, Position);
                        Position = 1;
                    }
                }
                else if (NodeCursor.Next != null)
                {
                    NodeCursor = NodeCursor.Next;
                    nodeID = NodeCursor.Ident;
                    ++Position;
                }
                else if (searchIntoSub && (NodeCursorStack.Count > 0))
                {
                    do
                    {
                        if (NodeCursorStack.Any())
                        {
                            NodeCursor = NodeCursorStack.Peek();
                            NodeCursorStack.Pop();
                            if (PositionList.Any())
                            {
                                Position = PositionList.LastOrDefault();
                                PositionList.RemoveAt(PositionList.Count - 1);
                            }
                        }
                        else
                        {
                            NodeCursor = null;
                        }
                    } while ((NodeCursor != null) && (NodeCursor.Next == null));
                    if (NodeCursor != null)
                    {
                        if (NodeCursor.Next != null)
                        {
                            NodeCursor = NodeCursor.Next;
                            nodeID = NodeCursor.Ident;
                            ++Position;
                        }
                    }
                }
            }
            return nodeID;
        }

        /// <summary>
        /// Go to the node using node ID
        /// </summary>
        /// <param name="searchID"></param>
        /// <returns></returns>
        public int gotoNode(int searchID)
        {
            int nodeID = 0;
            if (searchID > 0)
            {
                if (NodeCursor != null)
                {
                    nodeID = NodeCursor.Ident;
                    while ((nodeID > 0) && (nodeID != searchID))
                        nodeID = iterate();
                }
            }
            return nodeID;
        }


        /// <summary>
        /// Goes to node using position and separator
        /// </summary>
        /// <param name="position"></param>
        /// <param name="separator"></param>
        /// <returns></returns>
        public int gotoNode(ref string position, char separator = '.')
        {
            int nodeID = 0;
            if (position.Length > 0)
            {
                if (NodeCursor != null)
                {
                    nodeID = NodeCursor.Ident;
                    int posStart = 0;
                    int posEnd = 0;
                    int goCount = 0;
                    do
                    {
                        /* go down after first valid substring/segment */
                        if (posStart > 0)
                            nodeID = goDown();
                        /* current node still valid? */
                        if (nodeID > 0)
                        {
                            /* search for next separator */
                            posEnd = position.IndexOf(separator, posStart);
                            /* is last segment? */
                            if (posEnd == -1)
                                goCount = DSRTypes.stringToNumber(position.Substring(posStart));
                            else
                            {
                                goCount = DSRTypes.stringToNumber(position.Substring(posStart, posEnd - posStart));
                                posStart = posEnd + 1;
                            }
                            /* is valid number? */
                            if (goCount > 0)
                            {
                                while ((nodeID > 0) && (goCount > 1))
                                {
                                    nodeID = gotoNext();
                                    goCount--;
                                }
                            }
                            else
                                nodeID = 0;
                        }
                    } while ((nodeID > 0) && (posEnd != -1));
                }
            }
            return nodeID;
        }


        /// <summary>
        /// Gets the node ID
        /// </summary>
        /// <returns></returns>
        public int getNodeID()
        {
            int nodeID = 0;
            if (NodeCursor != null)
                nodeID = NodeCursor.Ident;
            return nodeID;
        }

        /// <summary>
        /// Get the level/count/size of stack
        /// </summary>
        /// <returns></returns>
        public int getLevel()
        {
            int level = 0;
            if (NodeCursor != null)
                level = NodeCursorStack.Count + 1;
            return level;
        }

        /// <summary>
        /// Gets the position using the separator.
        /// </summary>
        /// <param name="position"></param>
        /// <param name="separator"></param>
        /// <returns></returns>
        public string getPosition(ref string position, char separator = '.')
        {
            position = string.Empty;
            if (Position > 0)
            {
                string stringBuf = string.Empty;
                foreach (int _value in PositionList)
                {
                    stringBuf = string.Empty;
                    if (position.Length > 0)
                    {
                        position += separator;
                    }

                    position += DSRTypes.numberToString(_value, stringBuf);
                }

                if (position.Length > 0)
                    position += separator;
                position += DSRTypes.numberToString(Position, stringBuf);
            }
            return position;
        }
    }
}
