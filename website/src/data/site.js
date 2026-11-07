export const siteConfig = {
  name: "T Code",
  // GitHub Pages project site. Keep base in sync with vite.config.js
  // (VITE_BASE=/TCode/) and .github/workflows/pages.yml. Point back to
  // https://tcode.thinakaran.dev when using the custom domain.
  url: "https://thinakaranmanokaran.github.io/TCode",
  version: "2.1.7",
  tagline: "A lightweight code editor that gets out of your way.",
  description:
    "T Code is a free, open-source code editor for Windows, Linux, and macOS. About 5 MB, instant startup, an integrated terminal, and 24 themes.",
  releaseLabel: "T Code 2.1.7",
  license: "MIT",
  author: {
    name: "Thinakaran Manokaran",
    alternateName: "Dheena",
    role: "Full Stack MERN Developer & Creator of T Code",
    location: "Thanjavur, Tamil Nadu, India",
    experience: "4+ years",
    projectCount: "100+",
    photo: "/brand/developer-avatar.webp",
    bio: "I'm Thinakaran Manokaran, also known as Dheena. I'm a full-stack developer from Thanjavur, Tamil Nadu. I build web apps, mobile apps, and small tools that make everyday work feel lighter. T Code is the latest one.",
    skills: [
      "React",
      "Next.js",
      "Node.js",
      "Express",
      "MongoDB",
      "MySQL",
      "React Native",
      "Tailwind CSS",
      "Python",
      "Java",
    ],
  },
  links: {
    github: "https://github.com/thinakaranmanokaran/TCode",
    releases: "https://github.com/thinakaranmanokaran/TCode/releases/latest",
    portfolio: "https://thinakaran.dev",
    linkedin: "https://www.linkedin.com/in/thinakaran-manohar",
    dev: "https://dev.to/thinakaran",
    githubProfile: "https://github.com/thinakaranmanokaran",
    email: "dheenamanohar@gmail.com",
  },
  downloads: {
    windowsPortable: {
      label: "Windows portable",
      file: "tcode-2.1.7-x86_64-windows-portable.zip",
      note: "Unzip and run tcode.exe. No installer needed.",
    },
    windowsInstaller: {
      label: "Windows installer",
      file: "tcode-2.1.7-x86_64-windows-setup.exe",
      note: "Adds T Code to the Start menu and optionally to PATH.",
    },
    linuxPortable: {
      label: "Linux portable",
      file: "tcode-2.1.7-x86_64-linux-portable.tar.gz",
      note: "Extract and run ./tcode. Works on most x86_64 distributions.",
    },
    linuxAppImage: {
      label: "Linux AppImage",
      file: "tcode-2.1.7-x86_64-linux.AppImage",
      note: "Make it executable with chmod +x, then run it.",
    },
    macPortable: {
      label: "macOS portable",
      file: "tcode-2.1.7-universal-darwin-portable.tar.gz",
      note: "Universal build for Apple Silicon and Intel Macs.",
    },
    macDmg: {
      label: "macOS DMG",
      file: "tcode-2.1.7-universal-darwin.dmg",
      note: "Drag T Code.app into Applications.",
    },
  },
  stats: [
    { value: "5.0 MB", label: "Windows binary" },
    { value: "24", label: "built-in themes" },
    { value: "3", label: "desktop platforms" },
    { value: "MIT", label: "open-source license" },
  ],
};

export const navItems = [
  { label: "Features", href: "/features" },
  { label: "Themes", href: "/themes" },
  { label: "About", href: "/about" },
  { label: "Download", href: "/download" },
];

export const darkHeaderRoutes = new Set(["/themes", "/about", "/developer", "/404"]);
