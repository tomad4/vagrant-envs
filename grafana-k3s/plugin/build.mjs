import { execFileSync } from 'node:child_process';
import { copyFile, mkdir } from 'node:fs/promises';
import { join } from 'node:path';

const output = process.argv[2] ?? 'dist';
execFileSync(process.execPath, ['--check', 'module.js'], { stdio: 'inherit' });
await mkdir(output, { recursive: true });
for (const file of ['module.js', 'plugin.json', 'logo.svg']) {
  await copyFile(file, join(output, file));
}
