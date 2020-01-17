import React, { useState, useEffect } from "react";
import { Node } from './models'
import NodeComponent from './node'

interface NodesProps {
    nodes: Array<Node>;
    actionHandler: (action: string, data: any) => void;
}

const NodeList: React.FC<NodesProps> = (props: NodesProps) => {
    const nodes = props.nodes;
    console.table(nodes)
    const handler = props.actionHandler;
    const nodesJsx = nodes.map((node) => <NodeComponent node={node} key={node.id} handler={handler} />);
    return (
        <div>
            {nodesJsx}
        </div>
    );
};

export default NodeList;
