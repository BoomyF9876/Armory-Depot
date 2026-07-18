import "./App.css";
import { Header } from "./components/Header";
import { FilterSidebar } from "./components/FilterSidebar";
import { ListingsPage } from "./pages/ListingsPage";

function App() {
  return (
    <div className="app-shell">
      <Header />
      <div className="app-body">
        <FilterSidebar />
        <main className="app-main">
          <ListingsPage />
        </main>
      </div>
    </div>
  );
}

export default App;
