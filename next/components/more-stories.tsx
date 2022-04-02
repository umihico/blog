import PostPreview from './post-preview'
import PostType from '../types/post'

type Props = {
    posts: PostType[]
}

const Stories = ({ posts }: Props) => {
    return (
        <section>
            <div className="grid grid-cols-1 lg:grid-cols-2 md:gap-x-16 lg:gap-x-32 gap-y-20 md:gap-y-32 mb-32">
                {posts.map((post) => (
                    <PostPreview
                        tags={post.tags}
                        key={post.slug}
                        title={post.title}
                        date={post.date}
                        slug={post.slug}
                        excerptHtml={post.excerptHtml}
                    />
                ))}
            </div>
        </section>
    )
}

export default Stories
