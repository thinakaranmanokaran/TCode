import { PageMeta } from "../components/PageMeta.jsx";
import { PageHero } from "../components/PageHero.jsx";
import { siteConfig } from "../data/site.js";

export function PrivacyPage() {
  return (
    <>
      <PageMeta
        title="T Code Privacy — No Cookies, No Tracking"
        description="How the T Code website handles data: no advertising cookies, no third-party tracking scripts, and no account required."
        path="/privacy"
      />

      <PageHero
        eyebrow="Privacy"
        title={
          <>
            No cookies.
            <br />
            No <em>funny business.</em>
          </>
        }
        sub="A short privacy note for a small website."
        meta={["No tracking scripts", "No account", "No advertising cookies"]}
      />

      <section className="site-container" style={{ paddingBottom: 100, maxWidth: 860 }}>
        <div className="prose" style={{ marginLeft: 0 }}>
          <h2>What this site collects</h2>
          <p>
            This website does not set advertising cookies and does not include
            third-party tracking scripts. There is no account system, no
            newsletter signup, and no comment form.
          </p>
          <p>
            The hosting provider may collect standard server logs (IP address,
            user agent, requested URL, timestamp) for security and reliability.
            Those logs are not used to build a personal profile.
          </p>

          <h2>Analytics</h2>
          <p>
            If privacy-friendly analytics are enabled later, they will be
            cookie-free and aggregate-only. This page will be updated before any
            analytics script is added.
          </p>

          <h2>Download links</h2>
          <p>
            Download buttons link to GitHub Releases. GitHub’s privacy policy
            applies once you leave this site. The T Code application itself does
            not require an account and does not include an advertising SDK.
          </p>

          <h2>Contact</h2>
          <p>
            Questions about privacy can be sent to{" "}
            <a href={`mailto:${siteConfig.links.email}`}>{siteConfig.links.email}</a>.
            This site is maintained by Thinakaran Manokaran.
          </p>
        </div>
      </section>
    </>
  );
}
