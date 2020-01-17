export interface State {
    nodes: Array<Node>;
    streams: Array<Stream>;
}

export interface Node {
    id: string;
    name: string;
    status: string;
    volume: number;
    stream_id: string;
}

export interface Stream {
    id: string;
    name: string;
    status: string;
}

