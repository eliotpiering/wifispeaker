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
import {
    Socket
} from "phoenix"

import startApp from "./start-app"
const nodeName = document.getElementById("node-name").getAttribute("data-node-name")
let socket = new Socket("/socket", {
    params: {
        token: window.userToken
    }
})
socket.connect()

startApp(socket, nodeName)