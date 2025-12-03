import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

const resources = [
  'clients:list',
  'clients:detail',
  'clients:create',
  'casenotes:list',
  'casenotes:create',
  'pages:list',
  'pages:detail',
  'pages:create',
  'pages:update',
  'pages:delete',
  'announcements:list',
  'announcements:create',
  'announcements:update',
  'announcements:delete',
  'settings:list',
  'settings:create',
  'settings:update',
  'settings:delete',
  'users:list',
  'users:detail',
  'users:create',
  'users:update-state',
  'users:assign-role',
  'access-control:roles:list',
  'access-control:resources:list',
  'access-control:roles:create',
  'access-control:resources:create',
  'access-control:roles:attach',
];

const roles = {
  admin: resources,
  user: ['clients:list', 'clients:detail', 'casenotes:create', 'pages:detail', 'announcements:list'],
};

async function upsertResources() {
  for (const identifier of resources) {
    await prisma.resource.upsert({
      where: { identifier },
      update: {},
      create: { identifier },
    });
  }
}

async function upsertRoles() {
  for (const [name, resourceIdentifiers] of Object.entries(roles)) {
    const role = await prisma.role.upsert({
      where: { name },
      update: {},
      create: { name },
    });

    const resourcesToConnect = await prisma.resource.findMany({
      where: { identifier: { in: resourceIdentifiers } },
    });

    for (const resource of resourcesToConnect) {
      await prisma.roleResource.upsert({
        where: { roleId_resourceId: { roleId: role.id, resourceId: resource.id } },
        update: {},
        create: { roleId: role.id, resourceId: resource.id },
      });
    }
  }
}

async function ensureAdminUser() {
  const email = process.env.ADMIN_EMAIL || 'admin@example.com';
  const password = process.env.ADMIN_PASSWORD || 'ChangeMe123!';

  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) return existing;

  const passwordHash = await bcrypt.hash(password, 12);
  const adminRole = await prisma.role.findUnique({ where: { name: 'admin' } });

  if (!adminRole) {
    throw new Error('Admin role must exist before creating admin user');
  }

  const user = await prisma.user.create({
    data: {
      email,
      passwordHash,
      state: 'active',
      roles: { create: [{ roleId: adminRole.id }] },
    },
  });

  return user;
}

async function main() {
  await upsertResources();
  await upsertRoles();
  await ensureAdminUser();
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
