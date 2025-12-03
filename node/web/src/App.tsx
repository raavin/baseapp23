import { NavLink, Route, Routes } from 'react-router-dom';
import { Suspense } from 'react';
import { PlaceholderPage } from './components/PlaceholderPage';
import { routes } from './routes';

export default function App() {
  return (
    <div className="app-shell">
      <header className="app-header">
        <h1>Legacy Rewrite</h1>
        <nav>
          <NavLink to="/" end>
            Home
          </NavLink>
          <NavLink to="/dashboard">Dashboard</NavLink>
          <NavLink to="/admin">Admin</NavLink>
          <NavLink to="/clients">Clients</NavLink>
        </nav>
      </header>
      <main>
        <Suspense fallback={<PlaceholderPage title="Loading" />}>  
          <Routes>
            {routes.map((route) => (
              <Route key={route.path} path={route.path} element={route.element}>
                {route.children?.map((child) => (
                  <Route key={child.path} path={child.path} element={child.element} />
                ))}
              </Route>
            ))}
            <Route path="*" element={<PlaceholderPage title="Not Found" />} />
          </Routes>
        </Suspense>
      </main>
    </div>
  );
}
