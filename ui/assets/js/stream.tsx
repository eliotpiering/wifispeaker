import React, { useState } from "react";
import { Stream } from "./models"

import Typography from '@material-ui/core/Typography';
import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';


interface StreamProps {
    stream: Stream;
    key: string;
    handler: (action: string, data: any) => void;
}

const StreamComponent: React.FC<StreamProps> = (props: StreamProps) => {
    const stream = props.stream

    return (
        <Card>
            <CardContent>
                <Typography component="h5" variant="h5">
                    {stream.name}
                </Typography>
            </CardContent>
        </Card>

    );
};

export default StreamComponent;
