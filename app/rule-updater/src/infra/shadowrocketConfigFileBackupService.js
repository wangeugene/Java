import { promises as fs } from "node:fs";
import { dirname, join } from "node:path";
import { SHADOWROCKET_CONFIG_BACKUP_FILE, CONFIG_DIR, SHADOWROCKET_CONFIG_FILE } from "./paths.js";

async function ensureConfigDir() {
    await fs.mkdir(CONFIG_DIR, { recursive: true });
}

export async function ensureBackupExists() {
    await ensureConfigDir();
    try {
        await fs.access(SHADOWROCKET_CONFIG_BACKUP_FILE);
    } catch {
        try {
            await fs.copyFile(SHADOWROCKET_CONFIG_FILE, SHADOWROCKET_CONFIG_BACKUP_FILE);
        } catch {
            // If CONFIG_FILE doesn't exist either, create empty files.
            await fs.writeFile(SHADOWROCKET_CONFIG_BACKUP_FILE, "", "utf-8");
            await fs.writeFile(SHADOWROCKET_CONFIG_FILE, "", "utf-8");
        }
    }
}

export async function readBackupText() {
    await ensureBackupExists();
    return fs.readFile(SHADOWROCKET_CONFIG_BACKUP_FILE, "utf-8");
}

/**
 * Write backup via temp file + rename (safer)
 */
export async function writeBackupText(text) {
    await ensureConfigDir();
    const tmp = join(dirname(SHADOWROCKET_CONFIG_BACKUP_FILE), "shadowrocket.conf.bak.tmp");
    await fs.writeFile(tmp, text, "utf-8");
    await fs.rename(tmp, SHADOWROCKET_CONFIG_BACKUP_FILE);
}

/**
 * Sync backup → main config (also via temp file)
 */
export async function syncBackupToConfig() {
    await ensureConfigDir();
    const tmp = join(dirname(SHADOWROCKET_CONFIG_FILE), "shadowrocket.conf.tmp");
    await fs.copyFile(SHADOWROCKET_CONFIG_BACKUP_FILE, tmp);
    await fs.rename(tmp, SHADOWROCKET_CONFIG_FILE);
}
