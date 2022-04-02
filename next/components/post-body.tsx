import markdownStyles from './markdown-styles.module.css'
import Tags from './tags'

type Props = {
    contentHtml: string
    tags: string[]
}

const PostBody = ({ contentHtml, tags }: Props) => {
    return (
        <div className="max-w-2xl mx-auto">
            <Tags tags={tags} />
            <div
                className={markdownStyles['markdown']}
                dangerouslySetInnerHTML={{ __html: contentHtml }}
            />
        </div>
    )
}

export default PostBody
