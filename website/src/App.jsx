import { Layout } from "./components/Layout.jsx";
import { HomePage } from "./pages/HomePage.jsx";
import { FeaturesPage } from "./pages/FeaturesPage.jsx";
import { ThemesPage } from "./pages/ThemesPage.jsx";
import { DownloadPage } from "./pages/DownloadPage.jsx";
import { AboutPage } from "./pages/AboutPage.jsx";
import { DeveloperPage } from "./pages/DeveloperPage.jsx";
import { ChangelogPage } from "./pages/ChangelogPage.jsx";
import { FaqPage } from "./pages/FaqPage.jsx";
import { CompareLiteXLPage } from "./pages/CompareLiteXLPage.jsx";
import { CompareVSCodePage } from "./pages/CompareVSCodePage.jsx";
import { BlogPage } from "./pages/BlogPage.jsx";
import {
  BlogLightweightPage,
  BlogLiteXLPage,
  BlogBuildPage,
} from "./pages/BlogPosts.jsx";
import { LicensePage } from "./pages/LicensePage.jsx";
import { PrivacyPage } from "./pages/PrivacyPage.jsx";
import { NotFoundPage } from "./pages/NotFoundPage.jsx";

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
