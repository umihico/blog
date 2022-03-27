import { parseISO, format } from 'date-fns'

type Props = {
    dateString: string
}

const DateFormatter = ({ dateString }: Props) => {
    const date = parseISO(dateString)
    return (
        <time className="font-bold text-gray-700 text-lg" dateTime={dateString}>
            {format(date, 'LLLL	d, yyyy')}
        </time>
    )
}

export default DateFormatter
