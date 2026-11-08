import { lazy } from "react";
import { Layout } from "./components/Layout.jsx";
import { HomePage } from "./pages/HomePage.jsx";

const FeaturesPage = lazy(() =>
  import("./pages/FeaturesPage.jsx").then((m) => ({ default: m.FeaturesPage })),
);
const ThemesPage = lazy(() =>
  import("./pages/ThemesPage.jsx").then((m) => ({ default: m.ThemesPage })),
);
const DownloadPage = lazy(() =>
  import("./pages/DownloadPage.jsx").then((m) => ({ default: m.DownloadPage })),
);
const AboutPage = lazy(() =>
  import("./pages/AboutPage.jsx").then((m) => ({ default: m.AboutPage })),
);
const DeveloperPage = lazy(() =>
  import("./pages/DeveloperPage.jsx").then((m) => ({ default: m.DeveloperPage })),
);
const ChangelogPage = lazy(() =>
  import("./pages/ChangelogPage.jsx").then((m) => ({ default: m.ChangelogPage })),
);
const FaqPage = lazy(() =>
  import("./pages/FaqPage.jsx").then((m) => ({ default: m.FaqPage })),
);
const CompareLiteXLPage = lazy(() =>
  import("./pages/CompareLiteXLPage.jsx").then((m) => ({ default: m.CompareLiteXLPage })),
);
const CompareVSCodePage = lazy(() =>
  import("./pages/CompareVSCodePage.jsx").then((m) => ({ default: m.CompareVSCodePage })),
);
const BlogPage = lazy(() =>
  import("./pages/BlogPage.jsx").then((m) => ({ default: m.BlogPage })),
);
const BlogLightweightPage = lazy(() =>
  import("./pages/BlogPosts.jsx").then((m) => ({ default: m.BlogLightweightPage })),
);
const BlogLiteXLPage = lazy(() =>
  import("./pages/BlogPosts.jsx").then((m) => ({ default: m.BlogLiteXLPage })),
);
const BlogBuildPage = lazy(() =>
  import("./pages/BlogPosts.jsx").then((m) => ({ default: m.BlogBuildPage })),
);
const LicensePage = lazy(() =>
  import("./pages/LicensePage.jsx").then((m) => ({ default: m.LicensePage })),
);
const PrivacyPage = lazy(() =>
  import("./pages/PrivacyPage.jsx").then((m) => ({ default: m.PrivacyPage })),
);
const NotFoundPage = lazy(() =>
  import("./pages/NotFoundPage.jsx").then((m) => ({ default: m.NotFoundPage })),
);

export const routes = [
  {
    path: "/",
    element: <Layout />,
    children: [
      { index: true, element: <HomePage /> },
      { path: "features", element: <FeaturesPage /> },
      { path: "themes", element: <ThemesPage /> },
      { path: "download", element: <DownloadPage /> },
      { path: "about", element: <AboutPage /> },
      { path: "developer", element: <DeveloperPage /> },
      { path: "changelog", element: <ChangelogPage /> },
      { path: "faq", element: <FaqPage /> },
      { path: "compare/lite-xl-vs-t-code", element: <CompareLiteXLPage /> },
      { path: "compare/vs-code-vs-t-code", element: <CompareVSCodePage /> },
      { path: "blog", element: <BlogPage /> },
      { path: "blog/why-lightweight-editors-still-matter", element: <BlogLightweightPage /> },
      { path: "blog/lite-xl-vs-t-code", element: <BlogLiteXLPage /> },
      { path: "blog/build-t-code-from-source", element: <BlogBuildPage /> },
      { path: "license", element: <LicensePage /> },
      { path: "privacy", element: <PrivacyPage /> },
      { path: "404", element: <NotFoundPage /> },
      { path: "*", element: <NotFoundPage /> },
    ],
  },
];
