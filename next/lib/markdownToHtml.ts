import { marked } from 'marked'
marked.setOptions({
    highlight: function (code, lang) {
        const hljs = require('highlight.js')
        const language = hljs.getLanguage(lang) ? lang : 'plaintext'
        return hljs.highlight(code, { language }).value
    },
    langPrefix: 'hljs language-',
})

export function markdownToHtmlSync(markdown: string) {
    return marked.parse(markdown).toString()
}

export default async function markdownToHtml(markdown: string) {
    const result = await marked.parse(markdown)
    return result.toString()
}
