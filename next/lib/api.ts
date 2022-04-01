import fs from 'fs'
import { join } from 'path'
import matter from 'gray-matter'
import PostType from '../types/post'

const postsDirectory = join(process.cwd(), '../posts')

export function getPostSlugs() {
    return fs.readdirSync(postsDirectory)
}

export function getPostBySlug(slug: string): PostType {
    const realSlug = slug.replace(/\.md$/, '')
    const fullPath = join(postsDirectory, `${realSlug}.md`)
    const fileContents = fs.readFileSync(fullPath, 'utf8')
    const { data: meta, content: rawContent } = matter(fileContents)

    let content = rawContent.replace(/^#\ .*$/m, function (match) {
        if (typeof meta.title === 'undefined') {
            meta.title = match.slice(2)
        }
        return ''
    })

    const excerpt =
        typeof meta.excerpt === 'undefined'
            ? content
                  .split(/^#+\ .*$/gm)
                  .filter((s) => s.trim().length > 0)[0]
                  .trim()
            : meta.excerpt

    const date =
        typeof meta.date === 'undefined' ? slug.split('-')[0] : meta.date

    const references = meta.references
        ? Array(...meta.references).map((n) => String(n))
        : []

    if (references.length > 0) {
        content =
            content +
            '\n## References\n\n' +
            references.map((url) => `- ${url}`).join('\n')
    }

    const post: PostType = {
        slug: realSlug,
        content,
        title: meta.title,
        excerpt,
        date,
        tags: String(meta.tags).split(','),
        references: meta.references ? meta.references : [],
    }
    return post
}

export function getAllPosts() {
    const slugs = getPostSlugs()
    const posts = slugs
        .map((slug) => getPostBySlug(slug))
        // sort posts by date in descending order
        .sort((post1, post2) => (post1.date > post2.date ? -1 : 1))
    return posts
}
