import { chromium } from "playwright";

async function createPDF(websiteUrl) {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  await page.goto(websiteUrl);
  await page.pdf({ path: "my_pdf.pdf" });
  await browser.close();
}

createPDF();
