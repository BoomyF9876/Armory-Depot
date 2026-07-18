import { useState } from "react";
import "./FilterSidebar.css";

// Hardcoded options for now — not wired to the listings query yet.
const CATEGORIES = ["Melee Weapons", "Ranged Weapons", "Armor", "Shields", "Miscellaneous"];
const STATUS_OPTIONS = ["active", "sold", "all"] as const;

export function FilterSidebar() {
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
  const [status, setStatus] = useState<(typeof STATUS_OPTIONS)[number]>("active");

  const toggleCategory = (category: string) => {
    setSelectedCategories((prev) =>
      prev.includes(category) ? prev.filter((c) => c !== category) : [...prev, category],
    );
  };

  return (
    <aside className="filter-sidebar">
      <h2 className="filter-sidebar-title">Filters</h2>

      <div className="filter-group">
        <label className="filter-label" htmlFor="filter-search">
          Search
        </label>
        <input
          id="filter-search"
          type="text"
          placeholder="Search listings..."
          className="filter-search"
        />
      </div>

      <div className="filter-group">
        <span className="filter-label">Category</span>
        {CATEGORIES.map((category) => (
          <label key={category} className="filter-option">
            <input
              type="checkbox"
              checked={selectedCategories.includes(category)}
              onChange={() => toggleCategory(category)}
            />
            {category}
          </label>
        ))}
      </div>

      <div className="filter-group">
        <span className="filter-label">Price Range</span>
        <div className="filter-price-inputs">
          <input type="number" placeholder="Min" className="filter-price-input" min={0} />
          <span className="filter-price-sep">–</span>
          <input type="number" placeholder="Max" className="filter-price-input" min={0} />
        </div>
      </div>

      <div className="filter-group">
        <span className="filter-label">Status</span>
        {STATUS_OPTIONS.map((option) => (
          <label key={option} className="filter-option">
            <input
              type="radio"
              name="status"
              value={option}
              checked={status === option}
              onChange={() => setStatus(option)}
            />
            {option.charAt(0).toUpperCase() + option.slice(1)}
          </label>
        ))}
      </div>

      <button type="button" className="filter-apply">
        Apply Filters
      </button>
    </aside>
  );
}
