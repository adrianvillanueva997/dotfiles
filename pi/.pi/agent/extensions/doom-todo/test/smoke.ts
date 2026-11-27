import assert from "node:assert/strict";
import { visibleWidth } from "@earendil-works/pi-tui";
import { TodoOverlay } from "../todo-overlay.ts";
import { applyTaskMutation } from "../state/state-reducer.ts";
import { setActiveRenderSession, replaceState, getState } from "../state/store.ts";
import { replayFromBranch } from "../state/replay.ts";
import { registerTodoTool, registerTodosCommand } from "../todo.ts";

export default function (pi: any) {
  pi.on("session_start", async () => {
    try {
      const entries: any[] = [];
      let tool: any;
      registerTodoTool({
        registerTool: (value: any) => {
          tool = value;
        },
        appendEntry: (customType: string, data: any) =>
          entries.push({ type: "custom", customType, data }),
      } as any);
      const ctx = { sessionManager: { getSessionId: () => "persist", getBranch: () => entries } };
      await tool.execute(
        "create",
        { action: "create", subject: "Persisted task" },
        undefined,
        undefined,
        ctx,
      );
      assert.equal(replayFromBranch(ctx).tasks[0]?.subject, "Persisted task");
      let state = { tasks: [], nextId: 1 } as any;
      state = applyTaskMutation(state, "create", { subject: "First task" }).state;
      state = applyTaskMutation(state, "create", { subject: "Second task" }).state;
      state = applyTaskMutation(state, "update", { id: 1, status: "in_progress" }).state;
      state = applyTaskMutation(state, "update", { id: 1, status: "completed" }).state;
      state = applyTaskMutation(state, "update", {
        id: 2,
        status: "in_progress",
        activeForm: "working",
      }).state;
      setActiveRenderSession("smoke");
      replaceState("smoke", state);
      const theme = { fg: (_name: string, text: string) => text, bold: (text: string) => text };
      let widget: any;
      let expanded = false;
      const overlay = new TodoOverlay();
      overlay.setUICtx({
        theme,
        getToolsExpanded: () => expanded,
        setWidget: (_key: string, factory: any) => {
          if (factory) widget = factory({ requestRender() {} }, theme);
        },
      } as any);
      overlay.update();
      const rows = widget.render(50);
      assert.match(rows[0], /^╭─ † RITUALS  1\/2/);
      assert.ok(rows.some((line: string) => line.includes("✓ 1 completed · /todos · Ctrl+O")));
      assert.ok(!rows.some((line: string) => line.includes("First task")));
      expanded = true;
      assert.ok(widget.render(50).some((line: string) => line.includes("✓ First task")));
      expanded = false;
      assert.ok(rows.some((line: string) => line.includes("◐ Second task")));
      assert.ok(!rows.join("\n").includes("working"));
      assert.ok(rows.some((line: string) => line.startsWith("╰")));
      assert.ok(rows.every((line: string) => visibleWidth(line) <= 50));
      assert.ok(
        rows.findIndex((line: string) => line.includes("◐ Second task")) <
          rows.findIndex((line: string) => line.includes("✓ 1 completed")),
      );
      overlay.update();
      assert.match(widget.render(50)[0], /1\/2/);
      assert.ok(widget.render(50).some((line: string) => line.includes("✓ 1 completed")));
      assert.ok(widget.render(8).every((line: string) => visibleWidth(line) <= 8));
      const wrapped = widget.render(18);
      assert.ok(wrapped.every((line: string) => visibleWidth(line) <= 18));
      assert.ok(wrapped.join("\n").includes("Second task"));
      assert.ok(!wrapped.slice(1).some((line: string) => line.includes("…")));
      const many = {
        tasks: [
          ...Array.from({ length: 12 }, (_, index) => ({
            id: index + 1,
            subject: `Completed ${index + 1}`,
            status: "completed",
          })),
          {
            id: 13,
            subject: "A lengthy active task with meaningful details",
            status: "in_progress",
            activeForm: "performing work",
          },
        ],
        nextId: 14,
      } as any;
      replaceState("smoke", many);
      overlay.update();
      const busy = widget.render(30);
      assert.match(busy[0], /12\/13/);
      assert.ok(busy.some((line: string) => line.includes("◐ A lengthy")));
      assert.ok(busy.some((line: string) => line.includes("meaningful details")));
      assert.ok(busy.every((line: string) => visibleWidth(line) <= 30));
      overlay.toggleCollapse();
      assert.ok(widget.render(70).join("\n").includes("lengthy active task"));
      const commands = new Map<string, any>();
      let refreshed = false;
      registerTodosCommand(
        {
          registerCommand: (name: string, command: any) => commands.set(name, command),
          appendEntry: (customType: string, data: any) =>
            entries.push({ type: "custom", customType, data }),
        } as any,
        async () => {
          refreshed = true;
        },
      );
      const clearCtx = {
        hasUI: true,
        sessionManager: { getSessionId: () => "clear", getBranch: () => entries },
        ui: { confirm: async () => false, notify() {} },
      };
      replaceState("clear", {
        nextId: 4,
        tasks: [
          { id: 1, subject: "Needed", status: "completed" },
          { id: 2, subject: "Pending", status: "pending", blockedBy: [1] },
          { id: 3, subject: "Done", status: "completed" },
        ],
      });
      await commands.get("todos-clear-completed").handler("", clearCtx);
      assert.equal(getState("clear").tasks[2].status, "completed");
      clearCtx.ui.confirm = async () => true;
      await commands.get("todos-clear-completed").handler("", clearCtx);
      assert.equal(getState("clear").tasks[0].status, "completed");
      assert.equal(getState("clear").tasks[2].status, "deleted");
      assert.equal(replayFromBranch(clearCtx).tasks[2].status, "deleted");
      assert.ok(refreshed);
      console.log("doom-todo smoke passed");
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  });
}
