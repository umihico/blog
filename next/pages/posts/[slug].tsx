import { useRouter } from 'next/router'
import ErrorPage from 'next/error'
import Container from '../../components/container'
import PostBody from '../../components/post-body'
import Header from '../../components/header'
import PostHeader from '../../components/post-header'
import Layout from '../../components/layout'
import { getPostBySlug, getAllPosts } from '../../lib/api'
import PostTitle from '../../components/post-title'
import Head from 'next/head'
import { BLOG_TITLE } from '../../lib/constants'
import markdownToHtml from '../../lib/markdownToHtml'
import PostType from '../../types/post'
import 'highlight.js/styles/github.css'
import { GITHUB_URL } from '../../lib/constants'

type Props = {
    post: PostType
    morePosts: PostType[]
    preview?: boolean
}

const Post = ({ post, morePosts, preview }: Props) => {
    const router = useRouter()
    if (!router.isFallback && !post?.slug) {
        return <ErrorPage statusCode={404} />
    }
    return (
        <Layout preview={preview}>
            <Container>
                <Header />
                {router.isFallback ? (
                    <PostTitle>Loading…</PostTitle>
                ) : (
                    <>
                        <article className="mb-32">
                            <Head>
                                <title>
                                    {post.title} | {BLOG_TITLE}
                                </title>
                                <meta property="og:image" />
                            </Head>
                            <PostHeader title={post.title} date={post.date} />
                            <div className="markdown">
                                <PostBody content={post.content} />
                            </div>
                            <a
                                className="mt-20 grid justify-items-center font-bold hover:underline"
                                href={`${GITHUB_URL}/edit/main/posts/${post.slug}.md`}
                            >
                                Edit this aricle on GitHub
                            </a>
                        </article>
                    </>
                )}
            </Container>
        </Layout>
    )
}

export default Post

type Params = {
    params: {
        slug: string
    }
}

export async function getStaticProps({ params }: Params) {
    const post = getPostBySlug(params.slug)
    if (post.references) {
        post.content =
            post.content +
            '\n## References\n\n' +
            post.references.map((url) => `- ${url}`).join('\n')
    }
    const content = await markdownToHtml(post.content || '')

    return {
        props: {
            post: {
                ...post,
                content,
            },
        },
    }
}

export async function getStaticPaths() {
    const posts = getAllPosts()

    return {
        paths: posts.map((post) => {
            return {
                params: {
                    slug: post.slug,
                },
            }
        }),
        fallback: false,
    }
}
