import { Outlet } from 'react-router-dom';
import { PlaceholderPage } from './components/PlaceholderPage';

export const routes = [
  { path: '/', element: <PlaceholderPage title="Sign In / Welcome" description="Public entry with login/activation flows." /> },
  {
    path: '/dashboard',
    element: <PlaceholderPage title="Dashboard" description="Authenticated overview and quick links." />,
  },
  {
    path: '/clients',
    element: <Outlet />,
    children: [
      { path: '', element: <PlaceholderPage title="Clients" description="List and search client records." /> },
      { path: ':id', element: <PlaceholderPage title="Client Detail" description="Profile with casenotes timeline." /> },
    ],
  },
  {
    path: '/admin',
    element: <Outlet />,
    children: [
      { path: '', element: <PlaceholderPage title="Admin Overview" description="Role/resource management and settings." /> },
      { path: 'users', element: <PlaceholderPage title="Users" description="Manage user states and roles." /> },
      { path: 'roles', element: <PlaceholderPage title="Roles & Resources" description="Attach resources to roles." /> },
      { path: 'settings', element: <PlaceholderPage title="Settings" description="Configure site-wide options." /> },
      { path: 'content', element: <PlaceholderPage title="Content" description="Pages and announcements CMS." /> },
    ],
  },
  {
    path: '/password/reset',
    element: <PlaceholderPage title="Reset Password" description="Enter reset token and new password." />,
  },
  {
    path: '/activate',
    element: <PlaceholderPage title="Account Activation" description="Validate activation token." />,
  },
];
