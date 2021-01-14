import { makeStyles } from '@material-ui/core';
import { ReactElement } from 'react'
import VideoPartItem from '../../../models/items/video'
import { CoursePartItemProps } from './route'

const useStyles = makeStyles((theme) => ({
    media: {
        position: "absolute",
        top: 0,
        left: 0,
        width: "100%",
        height: "100%",
    },
    container: {
        position: "relative",
        paddingBottom: "56.25%" /* 16:9 */,
        paddingTop: 25,
        margin: theme.spacing(2),
        height: 0
    }
}));
export default function CourseVideoPage({item}: CoursePartItemProps<VideoPartItem>): ReactElement {
    const classes = useStyles();
    const build = () => {

    switch(item.source){
        case 'youtube':
            return <iframe className={classes.media} title={item.slug} width="560" height="315" src={`https://www.youtube-nocookie.com/embed/${item.url}`} frameBorder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowFullScreen></iframe>;
        case 'url':
            return <video className={classes.media} width="400" controls><source src={item.url} /></video>;
        default:
            return null;
    }
    };
    return <div className={classes.container}>
        {build()}
    </div>;
}
