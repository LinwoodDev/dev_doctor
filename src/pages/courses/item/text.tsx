import { ReactElement } from 'react'
import TextPartItem from '../../../models/items/text';
import { CoursePartItemProps } from './route';


export default function CourseTextPage(props: CoursePartItemProps<TextPartItem>): ReactElement {
    return (
        <div>
            <p>TEST!</p>
        </div>
    )
}
