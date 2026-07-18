import "./Header.css";

// Hardcoded for now — no auth/session wiring yet.
const CURRENT_USER = {
  display_name: "Alice",
  email: "alice@example.com",
  fake_currency_balance: "845.00",
};

export function Header() {
  return (
    <header className="app-header">
      <div className="app-header-brand">Armory-Depot</div>

      <div className="app-header-user">
        <div className="app-header-user-info">
          <span className="app-header-user-name">{CURRENT_USER.display_name}</span>
          <span className="app-header-user-balance">
            {CURRENT_USER.fake_currency_balance} credits
          </span>
        </div>
        <div className="app-header-avatar" aria-hidden="true">
          {CURRENT_USER.display_name.charAt(0)}
        </div>
      </div>
    </header>
  );
}
