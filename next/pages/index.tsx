import Container from '../components/container'
import Stories from '../components/more-stories'
import Intro from '../components/intro'
import Layout from '../components/layout'
import { getAllPosts } from '../lib/api'
import Head from 'next/head'
import { BLOG_TITLE } from '../lib/constants'
import Post from '../types/post'

type Props = {
    allPosts: Post[]
}

const Index = ({ allPosts }: Props) => {
    return (
        <>
            <Layout>
                <Head>
                    <title>{BLOG_TITLE}</title>
                </Head>
                <Container>
                    <Intro />
                    {allPosts.length > 0 && <Stories posts={allPosts} />}
                </Container>
            </Layout>
        </>
    )
}

export default Index

export const getStaticProps = async () => {
    const allPosts = getAllPosts(['title', 'date', 'slug', 'excerpt'])

    return {
        props: { allPosts },
    }
}
