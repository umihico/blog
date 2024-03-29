import Author from './author'

type PostType = {
    slug: string
    title: string
    date: string
    excerpt: string
    references: string[]
    tags: string[]
    content: string
    contentHtml: string
    excerptHtml: string
}

export default PostType
