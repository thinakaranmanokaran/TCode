import { ViteReactSSG } from "vite-react-ssg";
import { routes } from "./App.jsx";

import "./styles/fonts.css";
import "./styles/index.css";

// basename keeps client-side routing under the Pages subpath (/TCode/)
// when VITE_BASE=/TCode/ is set; it is "/" for custom domains (Vite default).
export const createRoot = ViteReactSSG({
  routes,
  basename: import.meta.env.BASE_URL,
});
