import { marked } from 'marked'

export default async function markdownToHtml(markdown: string) {
    const result = await marked.parse(markdown)
    return result.toString()
}
