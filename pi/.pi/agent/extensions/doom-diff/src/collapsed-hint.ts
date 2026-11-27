export const COLLAPSED_EXPAND_LABEL = "ctrl+o to expand";

export function collapsedSummaryLine(countLabel: string): string {
	return `${countLabel} — ${COLLAPSED_EXPAND_LABEL}`;
}
