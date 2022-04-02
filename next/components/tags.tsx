import { parseISO, format } from 'date-fns'

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
                    <a
                        key={tag}
                        href={`/tags/${toPath(tag)}`}
                        className="text-sky-900 text-opacity-80 rounded-lg bg-sky-100 px-2 py-1 mb-1 mr-2"
                    >
                        #{tag}
                    </a>
                ))}
            </p>
        </>
    )
}

export default Tags
