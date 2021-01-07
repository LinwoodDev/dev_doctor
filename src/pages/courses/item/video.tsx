import { makeStyles } from '@material-ui/core';
import { ReactElement } from 'react'
import VideoPartItem from '../../../models/items/video'
import { CoursePartItemProps } from './route'

const useStyles = makeStyles((theme) => ({
    youtube: {
        maxWidth: '100%'
    }
}));
export default function CourseVideoPage({item}: CoursePartItemProps<VideoPartItem>): ReactElement {
    const classes = useStyles();
    switch(item.source){
        case 'youtube':
            return <iframe className={classes.youtube} title={item.slug} width="560" height="315" src={`https://www.youtube-nocookie.com/embed/${item.url}`} frameBorder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowFullScreen></iframe>;
        case 'url':
            return <video width="400" controls><source src={item.url} /></video>;
        default:
            return null;
    }
}
