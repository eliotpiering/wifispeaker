import React, { useState, useEffect } from "react";
import { Stream } from './models'
import { StreamComponent } from './stream'

interface StreamProps {
    stream: Array<Stream>;
    actionHandler: (action: string, data: any) => void;
}

const StreamList: React.FC<StreamProps> = (props: StreamProps) => {
    const streams = props.streams;
    const handler = props.actionHandler;
    const streamsJsx = nodes.map((node) => <StreamComponent stream={stream} key={stream.id} handler={handler} />);
    return (
        <div>
            {streamsJsx}
        </div>
    );
};

export default StreamList;
