import fs from 'fs'
import { join } from 'path'
import matter from 'gray-matter'

const postsDirectory = join(process.cwd(), '../posts')

export function getPostSlugs() {
    return fs.readdirSync(postsDirectory)
}

export function getPostBySlug(slug: string, fields: string[] = []) {
    const realSlug = slug.replace(/\.md$/, '')
    const fullPath = join(postsDirectory, `${realSlug}.md`)
    const fileContents = fs.readFileSync(fullPath, 'utf8')
    const { data: meta, content } = matter(fileContents)

    type Post = {
        [key: string]: string
    }

    const data: Post = {
        slug: realSlug,
        content: content,
        ...meta,
    }

    if (typeof data.title === 'undefined' && fields.includes('title'))
        data.content = content.replace(/^#\ .*$/m, function (match) {
            data.title = match.slice(2)
            return ''
        })

    if (typeof data.excerpt === 'undefined' && fields.includes('excerpt'))
        data.excerpt = content
            .split(/^#+\ .*$/gm)
            .filter((s) => s.trim().length > 0)[0]
            .trim()

    if (typeof data.date === 'undefined' && fields.includes('date'))
        data.date = slug.split('-')[0]

    const filtered: Post = Object.fromEntries(
        fields.map((field) => [field, data[field]])
    )
    return filtered
}

export function getAllPosts(fields: string[] = []) {
    const slugs = getPostSlugs()
    const posts = slugs
        .map((slug) => getPostBySlug(slug, fields))
        // sort posts by date in descending order
        .sort((post1, post2) => (post1.date > post2.date ? -1 : 1))
    return posts
}
