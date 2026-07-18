export function formatCredits(price: string, options?: { compact?: boolean }): string {
  const value = Number(price);
  const formatter = new Intl.NumberFormat("en-US", {
    notation: options?.compact ? "compact" : "standard",
    maximumFractionDigits: options?.compact ? 1 : 2,
    minimumFractionDigits: options?.compact ? 0 : 2,
  });
  return formatter.format(value);
}
