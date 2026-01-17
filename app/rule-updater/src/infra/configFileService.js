import { promises as fs } from "node:fs";
import { dirname, join } from "node:path";
import { CONFIG_FILE, BACKUP_FILE, CONFIG_DIR } from "./paths.js";

async function ensureConfigDir() {
    await fs.mkdir(CONFIG_DIR, { recursive: true });
}

export async function ensureBackupExists() {
    await ensureConfigDir();
    try {
        await fs.access(BACKUP_FILE);
    } catch {
        // If backup doesn't exist, initialize it from the main config (if any).
        try {
            await fs.copyFile(CONFIG_FILE, BACKUP_FILE);
        } catch {
            // If CONFIG_FILE doesn't exist either, create empty files.
            await fs.writeFile(BACKUP_FILE, "", "utf-8");
            await fs.writeFile(CONFIG_FILE, "", "utf-8");
        }
    }
}

export async function readBackupText() {
    await ensureBackupExists();
    return fs.readFile(BACKUP_FILE, "utf-8");
}

/**
 * Write backup via temp file + rename (safer)
 */
export async function writeBackupText(text) {
    await ensureConfigDir();
    const tmp = join(dirname(BACKUP_FILE), "shadowrocket.conf.bak.tmp");
    await fs.writeFile(tmp, text, "utf-8");
    await fs.rename(tmp, BACKUP_FILE);
}

/**
 * Sync backup → main config (also via temp file)
 */
export async function syncBackupToConfig() {
    await ensureConfigDir();
    const tmp = join(dirname(CONFIG_FILE), "shadowrocket.conf.tmp");
    await fs.copyFile(BACKUP_FILE, tmp);
    await fs.rename(tmp, CONFIG_FILE);
}
