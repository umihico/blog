import { parseISO, format } from 'date-fns'
import Link from 'next/link'

type Props = {
    tags: string[]
}

export function toPath(tag: string) {
    return tag
        .toLowerCase()
        .replace(/[\.\ ]+/g, '-')
        .replace(/[^\-^a-z^0-9]+/g, '')
}

const Tags = ({ tags }: Props) => {
    return (
        <>
            <p className="flex flex-wrap mb-3">
                {tags.map((tag) => (
                    <Link
                        key={tag}
                        as={`/tags/${toPath(tag)}`}
                        href="/tags/[tag]"
                    >
                        <a className="text-sky-900 text-opacity-80 rounded-lg bg-sky-100 px-2 py-1 mb-1 mr-2">
                            #{tag}
                        </a>
                    </Link>
                ))}
            </p>
        </>
    )
}

export default Tags
