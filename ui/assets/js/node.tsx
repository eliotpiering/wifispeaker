import React, { useState } from "react";
import { Node } from "./models"
import { ADJUST_VOLUME_ACTION } from "./actions"

import Typography from '@material-ui/core/Typography';
import Slider from '@material-ui/core/Slider';
import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';
import CardActions from '@material-ui/core/CardActions';
import Collapse from '@material-ui/core/Collapse';
import Grid from '@material-ui/core/Grid';

import IconButton from '@material-ui/core/IconButton';
import VolumeDown from '@material-ui/icons/VolumeDown';
import VolumeUp from '@material-ui/icons/VolumeUp';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import ExpandLessIcon from '@material-ui/icons/ExpandLess';



interface NodeProps {
    node: Node;
    key: string;
    handler: any;
}

const NodeComponent: React.FC<NodeProps> = (props: NodeProps) => {

    const [fullDetails, setFullDetails] = useState(false)
    const node = props.node

    const handleVolumeChange = (_event: any, newValue: number) => {
        props.handler(ADJUST_VOLUME_ACTION, { id: node.id, volume: newValue })
    }

    return (
        <Card>
            <CardContent>
                <Typography component="h5" variant="h5">
                    {node.name}
                </Typography>
                <Typography id="volume-slider" gutterBottom>
                    Volume
                </Typography>
                <Grid container spacing={2}>
                    <Grid item>
                        <VolumeDown />
                    </Grid>
                    <Grid item xs>
                        <Slider value={node.volume} onChangeCommitted={handleVolumeChange} aria-labelledby="volume-slider" />
                    </Grid>
                    <Grid item>
                        <VolumeUp />
                    </Grid>
                </Grid>
                <CardActions>
                    <IconButton
                        onClick={() => setFullDetails(!fullDetails)}
                        aria-expanded={fullDetails}
                        aria-label="show more"
                    >
                        {fullDetails ? <ExpandLessIcon /> : <ExpandMoreIcon />}
                    </IconButton>
                </CardActions>
                <Collapse in={fullDetails} timeout="auto" unmountOnExit>
                    <CardContent>
                        <Typography paragraph>Volume: {node.volume}</Typography>
                        <Typography paragraph>Status: {node.status}</Typography>
                        <Typography paragraph>Id: {node.id}</Typography>
                    </CardContent>
                </Collapse>
            </CardContent>
        </Card>

    );
};

export default NodeComponent;
