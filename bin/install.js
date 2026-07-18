#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

// Detect which agent skills directory to install to
const HOME = process.env.HOME || require("os").homedir();

const AGENT_DIRS = [
  { name: "Claude Code", path: path.join(HOME, ".claude", "skills") },
  { name: "OpenCode/MiMo", path: path.join(HOME, ".opencode", "skills") },
  { name: "Codex", path: path.join(HOME, ".codex", "skills") },
  { name: "Cursor", path: path.join(HOME, ".cursor", "skills") },
];

// Find the first existing agent skills directory
let targetDir = null;
let agentName = null;

for (const agent of AGENT_DIRS) {
  if (fs.existsSync(agent.path)) {
    targetDir = agent.path;
    agentName = agent.name;
    break;
  }
}

// If no existing directory found, ask or default
if (!targetDir) {
  // Create all of them
  console.log("No existing agent skills directory found. Installing to all agents...\n");
  for (const agent of AGENT_DIRS) {
    fs.mkdirSync(agent.path, { recursive: true });
    installSkill(agent.path, agent.name);
  }
  console.log("\nDone! Skills installed to all agent directories.");
} else {
  installSkill(targetDir, agentName);
}

function installSkill(skillsDir, agentName) {
  const skillName = "job-application";
  const dest = path.join(skillsDir, skillName);
  const source = path.join(__dirname, "..");

  console.log(`Installing to ${agentName}: ${dest}`);

  // Remove existing installation
  if (fs.existsSync(dest)) {
    fs.rmSync(dest, { recursive: true, force: true });
  }

  // Copy skill files
  copyDir(source, dest, [
    "node_modules",
    ".git",
    "package.json",
    "package-lock.json",
    "bin",
    "README.md",
  ]);

  console.log(`  ✓ Installed ${skillName}`);

  // Try to install Python dependencies
  console.log("\n  Installing Python dependencies...");
  try {
    execSync(
      "pip3 install rendercv reportlab pdf2image pillow pypdf 2>/dev/null",
      { stdio: "pipe" }
    );
    console.log("  ✓ Python packages installed");
  } catch {
    console.log("  ⚠ Python packages may need manual installation:");
    console.log("    pip3 install rendercv reportlab pdf2image pillow pypdf");
  }

  // Check for LaTeX
  try {
    execSync("which xelatex 2>/dev/null || which pdflatex 2>/dev/null", {
      stdio: "pipe",
    });
    console.log("  ✓ LaTeX found");
  } catch {
    console.log("  ⚠ LaTeX not found (needed by rendercv):");
    console.log("    Linux: sudo apt install texlive-xetex texlive-fonts-recommended");
    console.log("    macOS: brew install --cask mactex");
  }

  console.log(`\n✓ ${skillName} installed successfully!`);
  console.log(`\nUsage:`);
  console.log(`  First time: say "set up job application" in your agent`);
  console.log(`  Then: share a job description and say "apply for this job"`);
}

function copyDir(src, dest, exclude = []) {
  fs.mkdirSync(dest, { recursive: true });

  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    if (exclude.includes(entry.name)) continue;

    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDir(srcPath, destPath, exclude);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}
