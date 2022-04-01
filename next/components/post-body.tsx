import markdownStyles from './markdown-styles.module.css'

type Props = {
    contentHtml: string
}

const PostBody = ({ contentHtml }: Props) => {
    return (
        <div className="max-w-2xl mx-auto">
            <div
                className={markdownStyles['markdown']}
                dangerouslySetInnerHTML={{ __html: contentHtml }}
            />
        </div>
    )
}

export default PostBody
