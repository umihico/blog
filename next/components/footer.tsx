import Container from './container'
import { GITHUB_URL } from '../lib/constants'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
    faGithub,
    faTwitter,
    faLinkedin,
    faFacebook,
} from '@fortawesome/free-brands-svg-icons'

const Footer = () => {
    const socials = {
        'https://github.com/umihico': faGithub,
        'https://twitter.com/umihico_': faTwitter,
        'https://www.linkedin.com/in/umihico/': faLinkedin,
        'https://www.facebook.com/umihiko.iwasa': faFacebook,
    }
    return (
        <footer className="bg-neutral-50 border-t border-neutral-200">
            <Container>
                <div className="py-28 flex flex-col lg:flex-row items-center">
                    <div className="tracking-tighter leading-tight text-center lg:text-left mb-10 lg:mb-0 lg:pr-4 lg:w-1/2">
                        {Object.entries(socials).map(([url, icon], index) => (
                            <a href={url}>
                                <FontAwesomeIcon
                                    className={`inline-block h-10 ${
                                        index + 1 < Object.keys(socials).length
                                            ? 'pr-3'
                                            : ''
                                    }`}
                                    icon={icon}
                                />
                            </a>
                        ))}
                        <div className="inline-block align-middle font-bold pt-1 px-3">
                            Other social links are in github.
                        </div>
                    </div>
                    <div className="flex flex-col lg:flex-row justify-center items-center lg:pl-4 lg:w-1/2">
                        <div className="mx-3 font-bold justify-center text-center">
                            The source code for this blog is
                            <a
                                href={`${GITHUB_URL}`}
                                className="underline hover:text-blue-600 duration-200 transition-colors"
                            >
                                {' '}
                                available on GitHub{' '}
                            </a>
                        </div>
                    </div>
                </div>
            </Container>
        </footer>
    )
}

export default Footer
