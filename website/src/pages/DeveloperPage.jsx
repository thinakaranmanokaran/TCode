import { Link } from "react-router-dom";
import { ArrowUpRight, Mail } from "lucide-react";
import { GithubIcon, LinkedinIcon } from "../components/BrandIcons.jsx";
import { PageMeta } from "../components/PageMeta.jsx";
import { JsonLd } from "../components/JsonLd.jsx";
import { SectionCta } from "../components/SectionCta.jsx";
import { Reveal } from "../components/Reveal.jsx";
import { siteConfig } from "../data/site.js";
import { assetPath } from "../data/base.js";
import { timeline } from "../data/story.js";
import {
  graphSchema,
  websiteSchema,
  personSchema,
  breadcrumbSchema,
} from "../data/schema.js";

const profileSchema = {
  "@type": "ProfilePage",
  name: "Thinakaran Manokaran",
  mainEntity: { "@id": `${siteConfig.url}/#thinakaran` },
  about: { "@id": `${siteConfig.url}/#thinakaran` },
};

const schema = graphSchema([
  websiteSchema,
  personSchema,
  profileSchema,
  breadcrumbSchema([
    { name: "Home", path: "/" },
    { name: "Developer", path: "/developer" },
  ]),
]);

const services = [
  {
    title: "Full-stack web",
    body: "React, Next.js, Node.js, Express, MongoDB, and MySQL. End-to-end product work from interface to deployment.",
  },
  {
    title: "Mobile apps",
    body: "React Native applications with native-feeling interactions, API integration, and store-ready builds.",
  },
  {
    title: "Developer tools",
    body: "Small, focused tools like T Code, VS Code extensions, Chrome extensions, and open-source utilities.",
  },
];

export function DeveloperPage() {
  return (
    <>
      <PageMeta
        title="Thinakaran Manokaran — Developer & Creator of T Code"
        description="Thinakaran Manokaran (Dheena) is a full-stack developer from Thanjavur, Tamil Nadu, and the creator of T Code. MERN, React Native, and developer tools."
        path="/developer"
        keywords="Thinakaran Manokaran, Dheena, full stack developer, MERN developer, T Code creator"
        imageAlt="Thinakaran Manokaran developer portrait"
      />
      <JsonLd data={schema} />

      <div className="dark-surface" style={{ background: "var(--ink)", color: "var(--paper)" }}>
        <section className="developer-hero site-container">
          <Reveal>
            <div className="eyebrow" style={{ color: "var(--lime)" }}>
              Developer · Dheena · {siteConfig.author.location}
            </div>
            <h1 className="display" style={{ fontSize: "clamp(58px, 8.4vw, 124px)", marginTop: 20 }}>
              Thinakaran
              <br />
              <em>Manokaran.</em>
            </h1>
            <p className="page-hero__sub" style={{ color: "rgba(250,250,250,.66)" }}>
              Full-stack developer, freelance web developer, trainer, and creator
              of T Code. I build web apps, mobile apps, and small tools that make
              everyday work feel lighter.
            </p>
            <div className="developer-meta">
              <span>{siteConfig.author.experience} experience</span>
              <span>{siteConfig.author.projectCount} projects delivered</span>
              <span>Thanjavur · Tamil Nadu · India</span>
            </div>
            <div style={{ display: "flex", gap: 12, flexWrap: "wrap", marginTop: 32 }}>
              <a
                className="btn btn--blue"
                href={siteConfig.links.portfolio}
                target="_blank"
                rel="noreferrer"
              >
                Portfolio <ArrowUpRight size={17} strokeWidth={1.6} />
              </a>
              <a
                className="btn btn--outline"
                href={siteConfig.links.githubProfile}
                target="_blank"
                rel="noreferrer"
                style={{ borderColor: "var(--line-dark)", color: "var(--paper)" }}
              >
                <GithubIcon size={17} /> GitHub
              </a>
            </div>
          </Reveal>
          <Reveal className="developer-hero__photo" delay={100}>
            <img
              className="developer-photo"
              src={assetPath(siteConfig.author.photo)}
              alt="Thinakaran Manokaran"
              width="400"
              height="400"
              loading="lazy"
              decoding="async"
            />
          </Reveal>
        </section>

        <section className="site-container" style={{ paddingBottom: 90 }}>
          <div className="prose" style={{ marginLeft: 0 }}>
            <Reveal>
              <h2>Developer by trade. Toolmaker by obsession.</h2>
              <p>
                I&apos;m Thinakaran Manokaran, also known as Dheena. I&apos;ve spent
                the last four years building web applications, mobile apps, and
                developer tools for clients and for myself. My daily stack is
                React, Next.js, Node.js, Express, MongoDB, MySQL, and React Native,
                with a long detour through Python, Java, and anything that makes a
                build faster.
              </p>
              <p>
                I&apos;m based in Thanjavur, Tamil Nadu. I work with businesses and
                students across India and remotely with clients worldwide. The
                through-line is simple: I like software that feels smaller and
                faster than it has any right to.
              </p>
              <h2>What I work on</h2>
            </Reveal>
            <div
              style={{
                display: "grid",
                gridTemplateColumns: "repeat(3, 1fr)",
                gap: 18,
                margin: "34px 0 20px",
              }}
              className="service-grid"
            >
              {services.map((service) => (
                <div
                  key={service.title}
                  style={{
                    padding: 22,
                    border: "1px solid var(--line-dark)",
                  }}
                >
                  <div className="eyebrow" style={{ color: "var(--lime)" }}>
                    {service.title}
                  </div>
                  <p style={{ marginTop: 14, color: "rgba(250,250,250,.66)", fontSize: 14 }}>
                    {service.body}
                  </p>
                </div>
              ))}
            </div>
            <Reveal>
              <h2>Skills</h2>
              <div className="skill-list">
                {siteConfig.author.skills.map((skill) => (
                  <span key={skill}>{skill}</span>
                ))}
              </div>
              <h2>Experience</h2>
              <div className="experience-table">
                {timeline.map((item) => (
                  <div className="experience-row" key={`${item.company}-${item.date}`}>
                    <div className="experience-row__company">{item.company}</div>
                    <div className="experience-row__role">{item.role}</div>
                    <div className="experience-row__date">{item.date}</div>
                  </div>
                ))}
              </div>
              <p style={{ marginTop: 30, color: "rgba(250,250,250,.55)", fontSize: 13 }}>
                Public profile sources:{" "}
                <a href={siteConfig.links.portfolio} target="_blank" rel="noreferrer">
                  thinakaran.dev
                </a>
                ,{" "}
                <a href={siteConfig.links.linkedin} target="_blank" rel="noreferrer">
                  LinkedIn
                </a>
                ,{" "}
                <a href={siteConfig.links.dev} target="_blank" rel="noreferrer">
                  DEV
                </a>
                , and{" "}
                <a href={siteConfig.links.githubProfile} target="_blank" rel="noreferrer">
                  GitHub
                </a>
                .
              </p>
            </Reveal>
          </div>
        </section>

        <section className="site-container" style={{ paddingBottom: 90 }}>
          <div
            style={{
              borderTop: "1px solid var(--line-dark)",
              paddingTop: 34,
              display: "flex",
              flexWrap: "wrap",
              gap: 16,
              justifyContent: "space-between",
              alignItems: "center",
            }}
          >
            <div className="eyebrow" style={{ color: "rgba(250,250,250,.5)" }}>
              Work with me
            </div>
            <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
              <a className="btn btn--outline" href={`mailto:${siteConfig.links.email}`} style={{ borderColor: "var(--line-dark)", color: "var(--paper)" }}>
                <Mail size={17} strokeWidth={1.6} /> Email
              </a>
              <a
                className="btn btn--outline"
                href={siteConfig.links.linkedin}
                target="_blank"
                rel="noreferrer"
                style={{ borderColor: "var(--line-dark)", color: "var(--paper)" }}
              >
                <LinkedinIcon size={17} /> LinkedIn
              </a>
            </div>
          </div>
        </section>

        <SectionCta
          kicker="One more thing"
          title={
            <>
              I built an editor.
              <br />
              <em>Try it.</em>
            </>
          }
          actions={
            <>
              <Link className="btn btn--blue" to="/download">
                Download T Code <ArrowUpRight size={17} strokeWidth={1.6} />
              </Link>
              <Link className="btn btn--paper" to="/about">
                Read the story
              </Link>
            </>
          }
        />
      </div>
    </>
  );
}
