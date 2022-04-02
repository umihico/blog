import Container from '../../components/container'
import Stories from '../../components/more-stories'
import Intro from '../../components/intro'
import Header from '../../components/header'
import Layout from '../../components/layout'
import Tags, { toPath } from '../../components/tags'
import { getAllPosts } from '../../lib/api'
import Head from 'next/head'
import { BLOG_TITLE } from '../../lib/constants'
import PostType from '../../types/post'

type Props = {
    tag: string
    posts: PostType[]
}

const Tag = ({ posts, tag }: Props) => {
    return (
        <>
            <Layout>
                <Head>
                    <title>
                        Tag: #{tag} | {BLOG_TITLE}
                    </title>
                </Head>
                <Container>
                    <Header />
                    <h2 className="font-medium text-4xl md:text-5xl lg:text-6xl font-bold tracking-tighter leading-tight mb-12">
                        <Tags tags={[tag]} />
                    </h2>
                    {posts.length > 0 && <Stories posts={posts} />}
                </Container>
            </Layout>
        </>
    )
}

export default Tag

type Params = {
    params: {
        tag: string
        posts: PostType[]
    }
}

export async function getStaticProps({ params }: Params) {
    const allPosts = getAllPosts()
    const posts = allPosts.filter((post) =>
        post.tags.map((t) => toPath(t)).includes(params.tag)
    )
    return {
        props: {
            tag: posts[0].tags.filter((t) => toPath(t) === params.tag)[0],
            posts: posts,
        },
    }
}

export async function getStaticPaths() {
    const allPosts = getAllPosts()
    const tags = allPosts
        .map((post) => post.tags)
        .flat()
        .filter((x, i, a) => a.indexOf(x) == i)
    return {
        paths: tags.map((tag) => {
            return {
                params: {
                    tag: toPath(tag),
                },
            }
        }),
        fallback: false,
    }
}
