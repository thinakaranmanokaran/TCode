import { ViteReactSSG } from "vite-react-ssg";
import { routes } from "./App.jsx";

import "./styles/fonts.css";
import "./styles/index.css";

export const createRoot = ViteReactSSG({ routes });
