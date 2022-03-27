import Avatar from './avatar'
import DateFormatter from './date-formatter'
import CoverImage from './cover-image'
import PostTitle from './post-title'
import Author from '../types/author'

type Props = {
    title: string
    date: string
}

const PostHeader = ({ title, date }: Props) => {
    return (
        <>
            <PostTitle>{title}</PostTitle>
            <div className="max-w-2xl mx-auto">
                <div className="mb-6">
                    <DateFormatter dateString={date} />
                </div>
            </div>
        </>
    )
}

export default PostHeader
