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
const CompareHubPage = lazy(() =>
  import("./pages/CompareHubPage.jsx").then((m) => ({ default: m.CompareHubPage })),
);
const EditorComparisonPage = lazy(() =>
  import("./pages/EditorComparisonPage.jsx").then((m) => ({ default: m.EditorComparisonPage })),
);
const LightweightEditorPage = lazy(() =>
  import("./pages/LightweightEditorPage.jsx").then((m) => ({
    default: m.LightweightEditorPage,
  })),
);
const BestEditorsPage = lazy(() =>
  import("./pages/BestEditorsPage.jsx").then((m) => ({ default: m.BestEditorsPage })),
);
const BenchmarksPage = lazy(() =>
  import("./pages/BenchmarksPage.jsx").then((m) => ({ default: m.BenchmarksPage })),
);
const UseCasePage = lazy(() =>
  import("./pages/UseCasePage.jsx").then((m) => ({ default: m.UseCasePage })),
);
const PressPage = lazy(() =>
  import("./pages/PressPage.jsx").then((m) => ({ default: m.PressPage })),
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
const BlogFiveMegabytesPage = lazy(() =>
  import("./pages/BlogPosts.jsx").then((m) => ({ default: m.BlogFiveMegabytesPage })),
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
      { path: "lightweight-code-editor", element: <LightweightEditorPage /> },
      { path: "lightweight-code-editor/windows", element: <UseCasePage slug="windows" /> },
      { path: "lightweight-code-editor/linux", element: <UseCasePage slug="linux" /> },
      { path: "lightweight-code-editor/macos", element: <UseCasePage slug="macos" /> },
      { path: "lightweight-code-editor/low-end-pc", element: <UseCasePage slug="low-end-pc" /> },
      { path: "lightweight-code-editor/portable", element: <UseCasePage slug="portable" /> },
      { path: "lightweight-code-editor/under-10mb", element: <UseCasePage slug="under-10mb" /> },
      { path: "best/lightweight-code-editors", element: <BestEditorsPage /> },
      { path: "benchmarks", element: <BenchmarksPage /> },
      { path: "compare", element: <CompareHubPage /> },
      { path: "compare/lite-xl-vs-t-code", element: <CompareLiteXLPage /> },
      { path: "compare/vs-code-vs-t-code", element: <CompareVSCodePage /> },
      { path: "compare/sublime-text-vs-t-code", element: <EditorComparisonPage slug="sublime-text-vs-t-code" /> },
      { path: "compare/notepad-plus-plus-vs-t-code", element: <EditorComparisonPage slug="notepad-plus-plus-vs-t-code" /> },
      { path: "compare/zed-vs-t-code", element: <EditorComparisonPage slug="zed-vs-t-code" /> },
      { path: "compare/vim-vs-t-code", element: <EditorComparisonPage slug="vim-vs-t-code" /> },
      { path: "compare/codeedit-vs-t-code", element: <EditorComparisonPage slug="codeedit-vs-t-code" /> },
      { path: "blog", element: <BlogPage /> },
      { path: "blog/why-lightweight-editors-still-matter", element: <BlogLightweightPage /> },
      { path: "blog/lite-xl-vs-t-code", element: <BlogLiteXLPage /> },
      { path: "blog/build-t-code-from-source", element: <BlogBuildPage /> },
      { path: "blog/how-t-code-stays-at-5-mb", element: <BlogFiveMegabytesPage /> },
      { path: "press", element: <PressPage /> },
      { path: "license", element: <LicensePage /> },
      { path: "privacy", element: <PrivacyPage /> },
      { path: "404", element: <NotFoundPage /> },
      { path: "*", element: <NotFoundPage /> },
    ],
  },
];
