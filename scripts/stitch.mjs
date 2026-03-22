#!/usr/bin/env node
import { stitch } from "@google/stitch-sdk";

const [,, cmd, ...args] = process.argv;

const usage = `Usage: node stitch.mjs <command> [args]
  list-projects
  list-screens <projectId>
  generate <projectId> <prompt> [desktop|mobile]
  edit <projectId> <screenId> <prompt>
  variants <projectId> <screenId> <prompt> [count]
  get-html <projectId> <screenId>
  get-image <projectId> <screenId>`;

async function main() {
  switch (cmd) {
    case "list-projects": {
      const projects = await stitch.projects();
      for (const p of projects) {
        const screens = await p.screens();
        console.log(`${p.projectId}\t${screens.length} screens`);
      }
      break;
    }
    case "list-screens": {
      const screens = await stitch.project(args[0]).screens();
      for (const s of screens) console.log(`${s.screenId}`);
      break;
    }
    case "generate": {
      const [projectId, ...rest] = args;
      const deviceIdx = rest.findIndex(a => a === "desktop" || a === "mobile");
      const device = deviceIdx >= 0 ? rest.splice(deviceIdx, 1)[0].toUpperCase() : "DESKTOP";
      const prompt = rest.join(" ");
      const screen = await stitch.project(projectId).generate(prompt, device);
      const html = await screen.getHtml();
      const image = await screen.getImage();
      console.log(JSON.stringify({ screenId: screen.screenId, html, image }));
      break;
    }
    case "edit": {
      const [projectId, screenId, ...promptParts] = args;
      const screen = await stitch.project(projectId).getScreen(screenId);
      const edited = await screen.edit(promptParts.join(" "));
      const html = await edited.getHtml();
      const image = await edited.getImage();
      console.log(JSON.stringify({ screenId: edited.screenId, html, image }));
      break;
    }
    case "variants": {
      const [projectId, screenId, ...rest] = args;
      const count = Number(rest[rest.length - 1]) || 3;
      if (Number(rest[rest.length - 1])) rest.pop();
      const screen = await stitch.project(projectId).getScreen(screenId);
      const variants = await screen.variants(rest.join(" "), { variantCount: count, creativeRange: "EXPLORE" });
      for (const v of variants) {
        const html = await v.getHtml();
        console.log(JSON.stringify({ screenId: v.screenId, html }));
      }
      break;
    }
    case "get-html": {
      const screen = await stitch.project(args[0]).getScreen(args[1]);
      console.log(await screen.getHtml());
      break;
    }
    case "get-image": {
      const screen = await stitch.project(args[0]).getScreen(args[1]);
      console.log(await screen.getImage());
      break;
    }
    default:
      console.log(usage);
      process.exit(1);
  }
}

main().catch(e => { console.error(e.message); process.exit(1); });
