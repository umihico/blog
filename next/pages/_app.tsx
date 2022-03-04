import { ChakraProvider } from "@chakra-ui/react";
import { AppProps } from "next/app";
import "../styles/index.css";
export default function MyApp({ Component, pageProps }: AppProps) {
  return (
    <ChakraProvider>
      <Component {...pageProps} />
    </ChakraProvider>
  );
}
