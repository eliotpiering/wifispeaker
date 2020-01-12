import React, { useState, useEffect } from "react";
import { Node } from './models'
import NodeComponent from './node'

interface NodesProps {
    nodes: Array<Node>;
    actionHandler: (action: string, data: any) => void;
}


const NodeList: React.FC<NodesProps> = (props: NodesProps) => {
    const nodes = props.nodes;
    const handler = props.actionHandler;
    const [state, setState] = useState(nodes)
    const updateStateListener = function(e: Event) {
        setState(e.detail);
        return false;
    }
    useEffect(() => {
        document.addEventListener('update-node-state', updateStateListener);

        return () => {
            return document.removeEventListener('update-node-state', updateStateListener);
        };
    })
    const nodesJsx = Object.keys(state).map((nodeId) => <NodeComponent node={state[nodeId]} key={nodeId} handler={handler} />);
    return (
        <div>
            {nodesJsx}
        </div>
    );
};

export default NodeList;
