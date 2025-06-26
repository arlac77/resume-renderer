import { promisify } from "node:util";
import { join } from "node:path";
import { execFile } from "node:child_process";
import { mkdir, cp } from "node:fs/promises";
import os from "node:os";

//import * as xslt3 from "xslt3";

const defaultConfig = {
  skills: "skills.xml",
  profile: "profile.xml",
  relevance: 8,
  from_dates: ["2010-01-01"],
  languages: ["de", "en"],
  name: "herbert_mueller"
  //output: { docx: {}, html: {}, pdf: {} }
};

const efp = promisify(execFile);

const formats = ["html", "pdf", "docx"];

export async function processResume(config = defaultConfig, tmpdir) {
  config = Object.assign({}, defaultConfig, config);

  const recursive = { recursive: true };

  const rrDir = new URL("..", import.meta.url).pathname;

  //const module = await import('xslt3');

  const tmp = os.tmpdir();
  const xsltDir = join(rrDir, "xslt");
  const templateDir = join(rrDir, "template");

  const xslt3 = rrDir + "node_modules/xslt3/xslt3.js";

  const output = Object.fromEntries(formats.map(name => [name, { files: [] }]));

  await Promise.all(
    config.from_dates.map(async from_date => {
      return Promise.all(
        config.languages.map(async lang => {
          const params = [
            `-s:${config.profile}`,
            `skills.url=file:${config.skills}`,
            `relevance=${config.relevance}`,
            `lang=${lang}`,
            `date=${new Date().toISOString()}`,
            `from_date=${from_date}`
          ];

          const ext1 = `${lang}-${from_date}-${config.relevance}`;
          const base = `${config.name}_${lang}`;

          const stage0 = [];
          const stage1 = [];
          const stage2 = [];

          for (const format of formats) {
            if (config.output[format]) {
              const dir = config.output[format].dir || config.dir || tmp;
              stage0.push(mkdir(dir, recursive));
              const file = join(dir, `${base}.${format}`);
              output[format].files.push(file);
              switch (format) {
                case "html":
                  stage1.push(
                    efp("node", [
                      xslt3,
                      `-xsl:${xsltDir}/profile2html.xsl`,
                      ...params,
                      `-o:${file}`
                    ])
                  );
                  break;
                case "docx":
                  const bd = join(tmp, `profile_${ext1}.docx`);
                  stage0.push(mkdir(bd, recursive));
                  stage1.push(
                    cp(templateDir, bd, recursive),
                    efp("node", [
                      xslt3,
                      `-xsl:${xsltDir}/profile2docx.xsl`,
                      ...params,
                      `dest=${bd}`
                    ])
                  );

                  stage2.push(
                    efp("zip", ["-r", file, "."], {
                      cwd: bd
                    })
                  );

                  break;
                case "pdf":
                  const fo = join(tmp, `profile_${ext1}.fo`);
                  stage1.push(
                    efp("node", [
                      xslt3,
                      `-xsl:${xsltDir}/profile2fo.xsl`,
                      ...params,
                      `-o:${fo}`
                    ])
                  );

                  stage2.push(efp("fop", ["-fo", fo, "-pdf", file]));

                  break;
              }
            }
          }

          await Promise.all(stage0);
          await Promise.all(stage1);
          await Promise.all(stage2);
        })
      );
    })
  );

  return output;
}
