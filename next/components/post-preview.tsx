import Avatar from './avatar'
import DateFormatter from './date-formatter'
import Tags from './tags'
import CoverImage from './cover-image'
import Link from 'next/link'
import Author from '../types/author'
import markdownStyles from './markdown-styles.module.css'

type Props = {
    title: string
    date: string
    excerptHtml: string
    slug: string
    tags: string[]
}

const PostPreview = ({ title, date, excerptHtml, slug, tags }: Props) => {
    return (
        <div>
            <div className="mb-4">
                <DateFormatter dateString={date} />
            </div>
            <Tags tags={tags} />
            <h3 className="text-3xl mb-3 leading-snug">
                <Link as={`/posts/${slug}`} href="/posts/[slug]">
                    <a className="hover:underline">{title}</a>
                </Link>
            </h3>
            <p className="text-lg leading-relaxed mb-4">
                <div
                    className={markdownStyles['markdown']}
                    dangerouslySetInnerHTML={{
                        __html: excerptHtml,
                    }}
                />
            </p>
        </div>
    )
}

export default PostPreview
