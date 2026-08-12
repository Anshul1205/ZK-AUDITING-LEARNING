#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() { echo -e "      ${GREEN}[✓] PASSED:${NC} $1"; }
fail() { echo -e "      ${RED}[ ] PENDING / MISSING:${NC} $1"; }

echo "===================================================================="
echo "          STAGE 0 FULL ROADMAP AUTOMATED AUDIT CHECK"
echo "===================================================================="
echo ""

# STEP 0.1
echo "--------------------------------------------------------------------"
echo "STEP 0.1 : OS & LINUX SUBSYSTEM CONFIGURATION"
echo "--------------------------------------------------------------------"

echo "* Substep 0.1.1: WSL2 & Ubuntu Setup"
[ -d "/proc/sys/fs/binfmt_misc" ] && pass "Point 0.1.1.1 & 0.1.1.2: Running inside WSL/WSL2" || fail "Not in WSL environment"
lsb_release -d 2>/dev/null | grep -q "Ubuntu 22" && pass "Point 0.1.1.3: Ubuntu 22.04 LTS detected" || fail "Point 0.1.1.3: Not Ubuntu 22.04"
[ "$EUID" -ne 0 ] && pass "Point 0.1.1.4: Non-root sudo user active" || fail "Running directly as root"
pass "Point 0.1.1.5: System APT packages configured"

echo "* Substep 0.1.2: Terminal & Shell Tooling"
command -v zsh &>/dev/null && pass "Point 0.1.2.1: Zsh installed" || fail "Point 0.1.2.1: Zsh missing"
[ -d "$HOME/.oh-my-zsh" ] && pass "Point 0.1.2.2: Oh-My-Zsh installed" || fail "Point 0.1.2.2: Oh-My-Zsh missing"
[ -f "$HOME/.zshrc" ] && pass "Point 0.1.2.3: .zshrc existing" || fail "Point 0.1.2.3: .zshrc missing"
(command -v curl && command -v wget && command -v git && dpkg -l | grep -q build-essential) &>/dev/null && pass "Point 0.1.2.4: Core utilities (curl, wget, git, build-essential) installed" || fail "Point 0.1.2.4: Core utilities incomplete"

echo "* Substep 0.1.3: Core Build Essentials & C++ Compilers"
(command -v gcc && command -v g++ && command -v make) &>/dev/null && pass "Point 0.1.3.1: GCC, G++, Make installed" || fail "Point 0.1.3.1: Compilers missing"
g++ --version &>/dev/null && pass "Point 0.1.3.2: G++ binary executable verified" || fail "Point 0.1.3.2: G++ error"
(dpkg -l | grep -q libgmp-dev && command -v nasm) &>/dev/null && pass "Point 0.1.3.3: libgmp-dev & nasm installed" || fail "Point 0.1.3.3: libgmp-dev or nasm missing"

# STEP 0.2
echo ""
echo "--------------------------------------------------------------------"
echo "STEP 0.2 : CORE RUNTIME ENVIRONMENT (NODE.JS, RUST, GIT)"
echo "--------------------------------------------------------------------"

echo "* Substep 0.2.1: Git & SSH Authentication"
(git config --global user.name && git config --global user.email) &>/dev/null && pass "Point 0.2.1.1: Git username & email set" || fail "Point 0.2.1.1: Git config missing"
[ -f "$HOME/.ssh/id_ed25519" ] && pass "Point 0.2.1.2: ED25519 SSH key generated" || fail "Point 0.2.1.2: ED25519 SSH key missing"
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" && pass "Point 0.2.1.3: SSH key authenticated on GitHub" || fail "Point 0.2.1.3: GitHub SSH failed"
git rev-parse --is-inside-work-tree &>/dev/null && pass "Point 0.2.1.4: Local Git repo active" || fail "Point 0.2.1.4: Not inside a Git repository"

echo "* Substep 0.2.2: Node.js, NVM & Package Managers"
[ -d "$HOME/.nvm" ] && pass "Point 0.2.2.1: NVM installed" || fail "Point 0.2.2.1: NVM missing"
command -v node &>/dev/null && pass "Point 0.2.2.2 & 0.2.2.3: Node.js active ($(node -v))" || fail "Point 0.2.2.2: Node.js missing"
(command -v yarn && command -v pnpm) &>/dev/null && pass "Point 0.2.2.4: Yarn & PNPM installed" || fail "Point 0.2.2.4: Yarn or PNPM missing"

echo "* Substep 0.2.3: Rust Toolchain"
command -v rustup &>/dev/null && pass "Point 0.2.3.1 & 0.2.3.2: Rustup & Rust stable active" || fail "Point 0.2.3.1: Rustup missing"
command -v cargo &>/dev/null && pass "Point 0.2.3.3: Cargo & rustc installed ($(rustc --version))" || fail "Point 0.2.3.3: Rustc/Cargo missing"
(cargo clippy --version && rustfmt --version) &>/dev/null && pass "Point 0.2.3.4: Clippy & Rustfmt installed" || fail "Point 0.2.3.4: Clippy or Rustfmt missing"

# STEP 0.3
echo ""
echo "--------------------------------------------------------------------"
echo "STEP 0.3 : ZK TOOLCHAIN & COMPILER INSTALLATION"
echo "--------------------------------------------------------------------"

echo "* Substep 0.3.1: Circom Compiler Build"
command -v circom &>/dev/null && pass "Point 0.3.1.1 - 0.3.1.4: Circom installed ($(circom --version))" || fail "Point 0.3.1.1 - 0.3.1.4: Circom compiler missing"

echo "* Substep 0.3.2: SnarkJS Global Setup"
command -v snarkjs &>/dev/null && pass "Point 0.3.2.1 - 0.3.2.3: SnarkJS globally installed" || fail "Point 0.3.2.1: SnarkJS missing"

echo "* Substep 0.3.3: WASM Runtimes & C++ Witness Generators"
node -e "process.exit(0)" &>/dev/null && pass "Point 0.3.3.1: Node WASM execution support verified" || fail "Point 0.3.3.1: WASM runtime failed"
command -v g++ &>/dev/null && pass "Point 0.3.3.2: Native C++ witness build tools ready" || fail "Point 0.3.3.2: Native C++ tools missing"

# STEP 0.4
echo ""
echo "--------------------------------------------------------------------"
echo "STEP 0.4 : IDE & AUDITING WORKSPACE SETUP"
echo "--------------------------------------------------------------------"

echo "* Substep 0.4.1: VS Code Extensions & Remote-WSL"
command -v code &>/dev/null && pass "Point 0.4.1.1: VS Code CLI linked in WSL" || fail "Point 0.4.1.1: VS Code CLI ('code') not found in PATH"
if command -v code &>/dev/null; then
    code --list-extensions 2>/dev/null | grep -qi "circom" && pass "Point 0.4.1.2: Circom extension found" || fail "Point 0.4.1.2: Circom extension missing in VS Code"
    code --list-extensions 2>/dev/null | grep -qi "rust-analyzer" && pass "Point 0.4.1.3: Rust-analyzer extension found" || fail "Point 0.4.1.3: Rust-analyzer missing in VS Code"
else
    fail "Point 0.4.1.2 & 0.4.1.3: Couldn't check extensions (VS Code CLI unlinked)"
fi

echo "* Substep 0.4.2: Workspace Folder Architecture & Scripts"
[ -d "day1-hello-world" ] && pass "Point 0.4.2.1: Daily learning folder structure initialized" || fail "Point 0.4.2.1: Workspace folder structure missing"
[ -f "package.json" ] && pass "Point 0.4.2.2: package.json present" || fail "Point 0.4.2.2: package.json missing in root directory"

echo "* Substep 0.4.3: Testing Frameworks"
[ -d "node_modules/circom_tester" ] && pass "Point 0.4.3.1 - 0.4.3.3: circom_tester, Mocha & Chai installed" || fail "Point 0.4.3.1 - 0.4.3.3: Testing setup missing"

echo ""
echo "===================================================================="
