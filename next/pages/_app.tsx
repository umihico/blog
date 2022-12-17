import { AppProps } from 'next/app'
import { useEffect } from 'react'
import TagManager from 'react-gtm-module'
import { GTM_ID } from '../lib/constants'
import '../styles/index.css'
export default function MyApp({ Component, pageProps }: AppProps) {
    useEffect(() => {
        if (GTM_ID && GTM_ID.startsWith('GTM-')) {
            TagManager.initialize({ gtmId: GTM_ID })
        }
    }, [])
    return <Component {...pageProps} />
}
