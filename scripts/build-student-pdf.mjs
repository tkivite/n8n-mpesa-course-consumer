#!/usr/bin/env node
import { readFile, writeFile, mkdir, access } from 'node:fs/promises';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { marked } from 'marked';
import hljs from 'highlight.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const DOCS = path.join(ROOT, 'docs');
const BUILD = path.join(ROOT, '.build');

const CHROME_CANDIDATES = [
  process.env.CHROME_PATH,
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  '/Applications/Chromium.app/Contents/MacOS/Chromium',
  '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
  '/usr/bin/google-chrome',
  '/usr/bin/chromium',
  '/usr/bin/chromium-browser',
].filter(Boolean);

async function findChrome() {
  for (const p of CHROME_CANDIDATES) {
    try { await access(p); return p; } catch {}
  }
  throw new Error('Google Chrome / Chromium not found. Set CHROME_PATH.');
}

marked.use({
  gfm: true,
  breaks: false,
  renderer: {
    code({ text, lang }) {
      const language = lang && hljs.getLanguage(lang) ? lang : 'plaintext';
      const html = hljs.highlight(text, { language, ignoreIllegals: true }).value;
      return `<pre><code class="hljs language-${language}">${html}</code></pre>`;
    }
  }
});

const CSS = `
  :root { --accent:#2b7a3e; --accent-dark:#1f5a2d; --fg:#1a1a1a; --muted:#555; --border:#e2e2e2; --code-bg:#f5f7f9; }
  @page { size: A4; margin: 22mm 18mm; }
  * { box-sizing: border-box; }
  body { margin:0; padding:0; font-family:-apple-system,"Segoe UI",Arial,sans-serif; color:var(--fg); line-height:1.55; font-size:11pt; }
  h1, h2, h3, h4 { color:var(--accent-dark); line-height:1.2; }
  h1 { font-size:26pt; border-bottom:3px solid var(--accent); padding-bottom:.3em; }
  h2 { font-size:18pt; border-bottom:1px solid var(--border); padding-bottom:.2em; margin-top:1.6em; }
  h3 { font-size:14pt; margin-top:1.2em; }
  p, ul, ol { margin:.55em 0; }
  code { font-family:ui-monospace,Menlo,Consolas,monospace; font-size:9.8pt; background:var(--code-bg); padding:1px 5px; border-radius:4px; }
  pre { background:var(--code-bg); border:1px solid var(--border); border-radius:6px; padding:10px 12px; white-space:pre-wrap; word-break:break-word; }
  pre code { background:transparent; padding:0; }
  table { border-collapse:collapse; width:100%; font-size:10pt; }
  th, td { border:1px solid var(--border); padding:6px 10px; text-align:left; }
  th { background:var(--accent); color:#fff; }
  .cover { height:92vh; display:flex; flex-direction:column; justify-content:center; page-break-after:always; }
  .cover h1 { font-size:36pt; border:none; margin:0 0 .3em; }
  .cover .sub { color:var(--muted); font-size:14pt; }
  .cover .meta { margin-top:auto; color:var(--muted); font-size:10pt; }
`;

function wrap(title, subtitle, bodyHtml) {
  return `<!doctype html><html><head><meta charset="utf-8"><title>${title}</title><style>${CSS}</style></head><body>
    <section class="cover">
      <h1>${title}</h1>
      <div class="sub">${subtitle}</div>
      <div class="meta">n8n M-Pesa Mastery · Consumer Repo<br/>Updated ${new Date().toISOString().slice(0,10)}</div>
    </section>
    ${bodyHtml}
  </body></html>`;
}

function runChrome(chrome, htmlPath, pdfPath) {
  return new Promise((resolve, reject) => {
    const p = spawn(chrome, [
      '--headless=new',
      '--disable-gpu',
      '--no-sandbox',
      '--no-pdf-header-footer',
      `--print-to-pdf=${pdfPath}`,
      `file://${htmlPath}`
    ], { stdio: ['ignore', 'pipe', 'pipe'] });
    let err = '';
    p.stderr.on('data', d => err += d.toString());
    p.on('exit', code => code === 0 ? resolve() : reject(new Error(err || `chrome exit ${code}`)));
  });
}

const srcPath = path.join(DOCS, 'student-quickstart.md');
const htmlPath = path.join(BUILD, 'student-quickstart.html');
const pdfPath = path.join(DOCS, 'student-quickstart.pdf');

await mkdir(BUILD, { recursive: true });
const chrome = await findChrome();
const md = await readFile(srcPath, 'utf8');
const html = wrap('Student Quickstart', 'First-hour setup for macOS, Windows, and Linux', marked.parse(md));
await writeFile(htmlPath, html, 'utf8');
await runChrome(chrome, htmlPath, pdfPath);
console.log(`✓ ${path.relative(ROOT, pdfPath)}`);

