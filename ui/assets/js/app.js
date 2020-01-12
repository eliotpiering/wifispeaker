// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
// import css from "../css/app.css"
const _css = require("../css/app.css");

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import React from "react";
import ReactDOM from "react-dom";
import "phoenix_html";
import nodeSocket from "./node_socket";
import NodeList from "./nodes";

const nodeData =  {"Node1": {id: "Node1", name: "Node One", volume: 80, status: "OK"}};
const nodeName = document.getElementById("node-name").getAttribute("data-node-name");


let channel = nodeSocket.channel("node:" + nodeName);

channel.on("new_state", payload => {
    const newState = payload.nodes;
    const event = new CustomEvent("update-node-state", {detail: newState});
    document.dispatchEvent(event);
});

function reactUpdateState(action, data) {
    channel.push(action, data);
}

channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });


ReactDOM.render(<NodeList nodes={nodeData} actionHandler={reactUpdateState}/>, document.getElementById('nodes'));
