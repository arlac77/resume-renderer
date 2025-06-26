import test from "ava";
import os from "node:os";
import { join } from "path";
import { processResume } from "../src/processor.mjs";

test("t1", async t => {
  const skills = new URL("fixtures/skills.xml", import.meta.url).pathname;
  const profile = new URL("fixtures/profile.xml", import.meta.url).pathname;
  const tmp = os.tmpdir();

  const output = await processResume({
    profile,
    skills,
    languages: ["en"],
    dir: tmp,
    output: {
      html: {
        dir: tmp
      },
      docx: {
        dir: tmp
      }
    }
  });

  t.deepEqual(output.html.files, [join(tmp, "herbert_mueller_en.html")]);
  t.deepEqual(output.docx.files, [join(tmp, "herbert_mueller_en.docx")]);
});
