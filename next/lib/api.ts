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

    const full: Post = {
        slug: realSlug,
        content: content,
        ...meta,
    }

    if (typeof full.title === 'undefined') {
        full.content = content.replace(/^#\ .*$/m, function (match) {
            full.title = match.slice(2)
            return ''
        })
    }

    if (typeof full.excerpt === 'undefined') {
        full.excerpt = content
            .split(/^#+\ .*$/gm)
            .filter((s) => s.trim().length > 0)[0]
            .trim()
    }

    if (typeof full.date === 'undefined') {
        full.date = slug.split('-')[0]
    }

    const filtered: Post = Object.fromEntries(
        fields.map((field) => [field, full[field]])
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
