/**
 * todo-overlay.ts — Persistent widget showing todo list above the editor.
 *
 * Lifecycle controller for Pi's `setWidget` contract: factory-form
 * registration in widgetContainerAbove, register-once + requestRender()
 * refresh, configurable task-row budget (default 8 via getMaxWidgetLines()),
 * width-aware wrapping, Pi tool-output expansion awareness, auto-hide when
 * empty, and off when getMaxWidgetLines() is 0.
 *
 * Reads live state via `getRenderState()` (the ctx-less foreground slot) at render
 * time — NEVER `replayFromBranch` from `tool_execution_end` (branch is stale;
 * `message_end` runs after).
 */

import type { ExtensionUIContext, Theme } from "@earendil-works/pi-coding-agent";
import type { TuiMouseEvent, TuiMouseEventResult } from "@earendil-works/pi-tui";
import { type TUI, truncateToWidth, visibleWidth, wrapTextWithAnsi } from "@earendil-works/pi-tui";
import { COLLAPSE_KEY_OFF, getMaxWidgetLines, resolveCollapseKey } from "./config.ts";
import { formatStatusLabel, t } from "./state/i18n-bridge.ts";
import {
  selectHasActive,
  selectOverlayLayout,
  selectShowTaskIds,
  selectTodoCounts,
} from "./state/selectors.ts";
import { getRenderState } from "./state/store.ts";
import { formatOverlayTaskLine } from "./view/format.ts";

const WIDGET_KEY = "rpiv-todos";

/** Local row index of the heading inside the rendered widget. */
const HEADING_ROW = 0;

// English fallbacks for localized overlay chrome strings.
const OVERLAY_HEADING = "Rituals";
const OVERLAY_MORE = "more";
const OVERLAY_EXPAND_HINT = "{key} to expand";
const OVERLAY_COLLAPSED = "collapsed";

export class TodoOverlay {
  private uiCtx: ExtensionUIContext | undefined;
  private widgetRegistered = false;
  private tui: TUI | undefined;
  private collapsed = false;

  setUICtx(ctx: ExtensionUIContext): void {
    // Identity-compare so repeat session_start handlers are idempotent;
    // on identity change (/reload) invalidate so update() re-registers.
    if (ctx !== this.uiCtx) {
      this.uiCtx = ctx;
      this.widgetRegistered = false;
      this.tui = undefined;
    }
  }

  update(): void {
    if (!this.uiCtx) return;
    const snapshot = this.getSnapshot();
    const visible = this.selectOverlayTasks(snapshot);

    if (visible.length === 0) {
      if (this.widgetRegistered) {
        this.uiCtx.setWidget(WIDGET_KEY, undefined);
        this.widgetRegistered = false;
        this.tui = undefined;
      }
      return;
    }

    if (!this.widgetRegistered) {
      this.uiCtx.setWidget(
        WIDGET_KEY,
        (tui, factoryTheme) => {
          this.tui = tui;
          return {
            render: (width: number) => this.renderWidget(this.uiCtx?.theme ?? factoryTheme, width),
            invalidate: () => {
              // No rendered strings are cached. Pi invalidates on theme changes;
              // the next render reads uiCtx.theme.
            },
            handleMouse: (event: TuiMouseEvent) => this.handleHeadingClick(event),
          };
        },
        { placement: "aboveEditor" },
      );
      this.widgetRegistered = true;
    } else {
      this.tui?.requestRender();
    }
  }

  /** Toggle the panel from a click on the heading row.
   *
   * Only an unmodified left click counts: task rows keep their own meaning (and
   * there is no per-task action yet), while modified clicks, drags, wheels and
   * press/release events stay available to the transcript's selection, scrolling
   * and app-level bindings. The heading renders in both states, so the same row
   * collapses and expands. Hosts without mouse dispatch never call this and keep
   * the keyboard-only behavior. */
  private handleHeadingClick(event: TuiMouseEvent): TuiMouseEventResult | undefined {
    if (event.type !== "click" || event.button !== "left") return undefined;
    if (event.shift || event.alt || event.ctrl) return undefined;
    if (event.y !== HEADING_ROW) return undefined;
    this.toggleCollapse();
    return { handled: true };
  }

  toggleCollapse(): void {
    this.collapsed = !this.collapsed;
    // Forced full redraw on the collapsed↔expanded height step, mirroring the
    // lane-dock's requestRender(shapeChanged); distinct from the non-forced
    // requestRender() refresh paths in update().
    this.tui?.requestRender(true);
  }

  isRegistered(): boolean {
    return this.widgetRegistered;
  }

  private getSnapshot() {
    const state = getRenderState();
    return { tasks: [...state.tasks], nextId: state.nextId };
  }

  private selectOverlayTasks(snapshot: ReturnType<TodoOverlay["getSnapshot"]>) {
    return snapshot.tasks.filter((task) => task.status !== "deleted");
  }

  private renderWidget(theme: Theme, width: number): string[] {
    // maxWidgetLines 0 turns the overlay off.
    const maxWidgetLines = getMaxWidgetLines();
    if (maxWidgetLines === 0) return [];

    const snapshot = this.getSnapshot();
    const overlayTasks = this.selectOverlayTasks(snapshot);
    if (overlayTasks.length === 0) return [];

    const overlayState = { tasks: overlayTasks, nextId: snapshot.nextId };
    const truncate = (line: string): string => truncateToWidth(line, width, "…");
    const counts = selectTodoCounts(overlayState);
    const hasActive = selectHasActive(overlayState);
    const showIds = selectShowTaskIds(overlayState);

    const panelWidth = Math.max(0, width);
    const framed = panelWidth >= 8;
    const border = (text: string) => theme.fg("border", text);
    const row = (text: string): string[] => {
      const contentWidth = framed ? panelWidth - 4 : Math.max(1, panelWidth);
      return wrapTextWithAnsi(text, contentWidth).map((content) =>
        framed
          ? `${border("│")} ${content}${" ".repeat(Math.max(0, contentWidth - visibleWidth(content)))} ${border("│")}`
          : truncate(content),
      );
    };
    const headingColor = hasActive ? "accent" : "muted";
    const titleText = `† ${t("overlay.heading", OVERLAY_HEADING).toUpperCase()}  ${counts.completed}/${counts.total}`;
    const title = framed ? truncateToWidth(titleText, panelWidth - 5, "…") : titleText;
    const heading = framed
      ? `${border("╭─ ")}${theme.fg(headingColor, title)} ${border("─".repeat(Math.max(0, panelWidth - visibleWidth(title) - 5)) + "╮")}`
      : truncate(theme.fg(headingColor, title));
    const finish = (lines: string[]) =>
      this.withTrailingSpacer(
        framed ? [...lines, border(`╰${"─".repeat(panelWidth - 2)}╯`)] : lines,
      );

    // Collapsed view: just the heading and an expand hint. The hint splices
    // the resolved key into the {key} placeholder (per-render, like the row
    // budget); a config edit needs /reload to re-bind the actual shortcut. The
    // "off" sentinel is reachable here mid-session (config edited after the
    // shortcut was bound and the overlay collapsed) — render a static collapsed
    // label instead of splicing the sentinel into the placeholder.
    if (this.collapsed) {
      const key = resolveCollapseKey();
      const hint =
        key === COLLAPSE_KEY_OFF
          ? t("overlay.collapsed", OVERLAY_COLLAPSED)
          : t("overlay.expandHint", OVERLAY_EXPAND_HINT).replace("{key}", key);
      const active = overlayTasks.find((task) => task.status === "in_progress");
      return finish([
        heading,
        ...(active ? row(formatOverlayTaskLine(active, theme, showIds)) : []),
        ...row(theme.fg("muted", hint)),
      ]);
    }

    const lines: string[] = [heading];
    // Budget for content rows (heading + tasks/summary). The rendered widget is
    // one line taller — withTrailingSpacer() appends a blank row below the panel.
    // Pi's global tool-output expansion mode is read on every render so its
    // expand/collapse shortcut also expands this live widget. Optional chaining
    // preserves compatibility with hosts predating getToolsExpanded().
    const expanded = this.uiCtx?.getToolsExpanded?.() === true;
    const displayedTasks = expanded
      ? overlayTasks
      : overlayTasks.filter((task) => task.status !== "completed");
    const bodyBudget = expanded
      ? displayedTasks.length
      : maxWidgetLines - 1 - (counts.completed > 0 ? 1 : 0);
    const layout = selectOverlayLayout(
      { tasks: displayedTasks, nextId: snapshot.nextId },
      bodyBudget,
    );
    for (const task of layout.visible) {
      lines.push(...row(formatOverlayTaskLine(task, theme, showIds)));
    }

    if (!expanded && counts.completed > 0) {
      lines.push(...row(theme.fg("success", `✓ ${counts.completed} completed · /todos · Ctrl+O`)));
    }
    if (layout.hiddenCompleted === 0 && layout.truncatedTail === 0) {
      return finish(lines);
    }

    const totalHidden = layout.hiddenCompleted + layout.truncatedTail;
    const overflowParts: string[] = [];
    if (layout.hiddenCompleted > 0)
      overflowParts.push(`${layout.hiddenCompleted} ${formatStatusLabel("completed")}`);
    if (layout.truncatedTail > 0)
      overflowParts.push(`${layout.truncatedTail} ${formatStatusLabel("pending")}`);
    const more = t("overlay.more", OVERLAY_MORE);
    const summary =
      overflowParts.length > 0
        ? `+${totalHidden} ${more} (${overflowParts.join(", ")})`
        : `+${totalHidden} ${more}`;
    lines.push(...row(theme.fg("muted", summary)));
    return finish(lines);
  }

  /**
   * Append a trailing blank line so the overlay isn't flush against the
   * editor box. Pi's host adds a leading spacer above the widget but none
   * below, which leaves the last "└─" row (or the "+N more" summary) glued
   * to the input box. The empty string gives the "Todos" panel a little
   * breathing room.
   */
  private withTrailingSpacer(lines: string[]): string[] {
    if (lines.length === 0) return lines;
    lines.push("");
    return lines;
  }

  dispose(): void {
    if (this.uiCtx) this.uiCtx.setWidget(WIDGET_KEY, undefined);
    this.widgetRegistered = false;
    this.tui = undefined;
    this.uiCtx = undefined;
    this.collapsed = false;
  }
}
