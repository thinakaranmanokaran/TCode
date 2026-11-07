import { Link } from "react-router-dom";
import { ArrowUpRight } from "lucide-react";
import { PageMeta } from "../components/PageMeta.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { siteConfig } from "../data/site.js";

export function LicensePage() {
  return (
    <>
      <PageMeta
        title="T Code License — MIT and Upstream Notices"
        description="T Code is MIT licensed and built on Lite XL and lite. Read the project license and the upstream dependency notices."
        path="/license"
      />

      <PageHero
        eyebrow="License"
        title={
          <>
            MIT. And a long
            <br />
            list of <em>thanks.</em>
          </>
        }
        sub="T Code is free software. It is built on the work of Lite XL, lite, and a long list of open-source dependencies."
        meta={["MIT license", "Open source", "Upstream notices preserved"]}
      />

      <section className="site-container" style={{ paddingBottom: 100, maxWidth: 900 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <h2>T Code license</h2>
          <p>
            T Code is released under the MIT License. You can use, copy, modify,
            merge, publish, distribute, sublicense, and sell copies of the
            software, provided the copyright notice and permission notice are
            included.
          </p>
          <p>
            The software is provided “as is”, without warranty of any kind. See
            the{" "}
            <a
              href={`${siteConfig.links.github}/blob/master/LICENSE`}
              target="_blank"
              rel="noreferrer"
            >
              full license text
            </a>{" "}
            for the exact terms.
          </p>

          <h2>Upstream projects</h2>
          <p>
            T Code is derived from Lite XL, which is derived from lite. Their
            copyright notices and license terms are preserved in the project’s
            license file. The editor would not exist without that lineage.
          </p>

          <h2>Dependencies</h2>
          <ul>
            <li>SDL3 — zlib license</li>
            <li>Lua 5.4 — MIT license</li>
            <li>PCRE2 — BSD license</li>
            <li>FreeType2 — FreeType License / GPLv2</li>
            <li>Lite XL plugins and themes — their respective licenses</li>
          </ul>
          <p>
            The complete dependency notices live in the repository at{" "}
            <a
              href={`${siteConfig.links.github}/blob/master/application/licenses/licenses.md`}
              target="_blank"
              rel="noreferrer"
            >
              application/licenses/licenses.md
            </a>
            .
          </p>

          <h2>Using T Code in your own work</h2>
          <p>
            You can ship T Code as part of a larger distribution, bundle it for a
            team, or fork it for an internal tool. Keep the license notice, and
            keep the upstream notices intact. If you build something on top of
            T Code, I would love to see it.
          </p>
          <p>
            Questions about licensing? <a href={`mailto:${siteConfig.links.email}`}>Email me</a>.
          </p>
        </div>
      </section>

      <section className="site-container" style={{ paddingBottom: 100 }}>
        <Link className="btn btn--dark" to="/download">
          Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
        </Link>
      </section>
    </>
  );
}
