// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom";
import NodeList from "./node_list";
import { State, Node } from "./models";



function startApp(socket: any, nodeName: string) {
    let channel = socket.channel("ui:" + nodeName);
    channel.on("new_state", (payload: State) => {
        const event = new CustomEvent("update_state", {
            detail: payload
        });
        document.dispatchEvent(event);
    });

    function actionOutHandler(action: string, data: any) {
        channel.push(action, data);
    }

    channel.join()
        .receive("ok", resp => {
            console.log("Joined successfully", resp)
        })
        .receive("error", resp => {
            console.log("Unable Channel", resp)
        });

    ReactDOM.render(<App state={{ nodes: [], streams: [] }} actionOutHandler={actionOutHandler} />, document.getElementById('app'));

}


interface AppProps {
    state: State;
    actionOutHandler: (action: string, data: any) => void;
}

const App: React.FC<AppProps> = (props: AppProps) => {
    const [state, setState] = useState(props.state)
    const updateState = function(e: any) {
        const newState: State = e.detail;
        setState(newState);
        return false;
    }

    useEffect(() => {
        document.addEventListener('update_state', updateState);

        return () => {
            return document.removeEventListener('update_state', updateState);
        };
    })

    return (<div>
        <NodeList nodes={state.nodes} actionHandler={props.actionOutHandler} />
    </div>)

}


export default startApp;
