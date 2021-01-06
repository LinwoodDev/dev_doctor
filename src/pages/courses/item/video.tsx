import { ReactElement } from 'react'
import VideoPartItem from '../../../models/items/video'
import { CoursePartItemProps } from './route'

export default function CourseVideoPage(props: CoursePartItemProps<VideoPartItem>): ReactElement {
    return (
        <div>
            <p>VIDEO!</p>
        </div>
    )
}
