import axios from "axios";

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:3000/api/v1";
const API_ORIGIN = new URL(API_BASE_URL).origin;

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// Server returns image paths (e.g. "/api/v1/listings/1/image"); resolve them against the
// backend origin since the frontend is served from a different origin in dev.
export function resolveImageUrl(path: string): string {
  return `${API_ORIGIN}${path}`;
}
