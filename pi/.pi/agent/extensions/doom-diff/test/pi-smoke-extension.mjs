import assert from "node:assert/strict";
import doomDiff, { __testing } from "../dist/index.js";

export default function (pi) {
  pi.on("session_start", async () => {
    try {
      const tools = new Map();
      await doomDiff({ registerTool: (tool) => tools.set(tool.name, tool) });
      const diff = __testing.parseDiff('const name = "old";\n', 'const name = "new";\n');
      const theme = { fg: (_name, text) => text, bold: (text) => text };
      const component = tools
        .get("edit")
        .renderResult({ details: { _type: "editInfo", diff, language: "typescript" } }, {}, theme, {
          invalidate() {},
        });
      const output = await component.__piDiffTask.render(120);
      const plain = output.replace(/\x1b\[[0-9;]*m/g, "");
      assert.match(plain, /const name = "old"/);
      assert.match(plain, /const name = "new"/);
      assert.match(output, /\x1b\[38;2;\d+;\d+;\d+mconst\x1b\[39m/);
      console.log("doom-diff Pi Shiki smoke passed");
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  });
}
