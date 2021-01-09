import { Typography } from '@material-ui/core';
import React, { ReactElement } from 'react'
import MyMarkdown from '../../../components/markdown';
import TextPartItem from '../../../models/items/text';
import { CoursePartItemProps } from './route';


export default function CourseTextPage(props: CoursePartItemProps<TextPartItem>): ReactElement {
    return (
        <Typography component="p">
            <MyMarkdown body={props.item.text} />
        </Typography>
    )
}
