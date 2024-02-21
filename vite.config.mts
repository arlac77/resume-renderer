import { defineConfig } from "vite";
import { promisify } from "node:util";
import { execFile } from "node:child_process";
import { mkdir, cp } from "node:fs/promises";

const relevance = 8;
const from_dates = ["2008-01-01"];
const languages = ["de", "en"];
const base_name = "profile_";

const efp = promisify(execFile);

await Promise.all(
  from_dates.map(async from_date =>
    Promise.all(
      languages.map(async lang => {
        const recursive = { recursive: true };
        const bd = `build/profile_${lang}-${from_date}-${relevance}.docx`;
        const base = `${base_name}${lang}`;
        await mkdir(bd, recursive);
        await Promise.all([
          cp("template", bd, recursive),
          efp("node", [
            "node_modules/xslt3/xslt3.js",
            "-xsl:xslt/profile2html.xsl",
            "-s:profile.xml",
            "bundles=../i18n/profile.xml",
            "resources=../resources",
            `relevance=${relevance}`,
            `lang=${lang}`,
            `from_date=${from_date}`,
            `-o:src/${base}.html`
          ]),
          efp("node", [
            "node_modules/xslt3/xslt3.js",
            "-xsl:xslt/profile2fo.xsl",
            "-s:profile.xml",
            "bundles=../i18n/profile.xml",
            `relevance=${relevance}`,
            `lang=${lang}`,
            `from_date=${from_date}`,
            `-o:build/profile_${lang}-${from_date}-${relevance}.fo`
          ]),
          efp("node", [
            "node_modules/xslt3/xslt3.js",
            "-xsl:xslt/profile2docx.xsl",
            "-s:profile.xml",
            "bundles=../i18n/profile.xml",
            `relevance=${relevance}`,
            `lang=${lang}`,
            `from_date=${from_date}`,
            `dest=${bd}`
          ])
        ]);

        await efp("fop", [
          "-fo",
          `build/profile_${lang}-${from_date}-${relevance}.fo`,
          "-pdf",
          `src/public/${base}.pdf`
        ]);

        await efp("zip", ["-r", `../../src/public/${base}.docx`, "."], {
          cwd: bd
        });
      })
    )
  )
);

export default defineConfig(async ({ command, mode }) => {
  return {
    base: "",
    root: "src",
    build: {
      outDir: "../dist",
      emptyOutDir: true,
      rollupOptions: {
        input: {
          "src/index.html": "src/index.html",
          ...Object.fromEntries(
            languages.map(l => [
              `src/${base_name}${l}.html`,
              `src/${base_name}${l}.html`
            ])
          )
        }
      },
      sourcemap: false
    }
  };
});
