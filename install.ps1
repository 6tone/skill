<#
.SYNOPSIS
  Install the shared AI skill pack into a project for Claude Code and Antigravity.

.DESCRIPTION
  - Pack-owned: skills/* is copied to <Target>/.claude/skills and <Target>/.agents/skills.
    Skills with the same name are replaced, so re-run this script to upgrade.
  - Project-owned: AGENTS.md, CLAUDE.md, docs/glossary.md and .claude/settings.json are
    copied from templates/ only when they do not exist yet. They are never overwritten.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File C:\path\to\skill-pack\install.ps1 -Target C:\path\to\project
#>
param(
  [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$Pack = $PSScriptRoot
$Target = (Resolve-Path -LiteralPath $Target).Path

if ($Target -eq $Pack) {
  throw "Target is the skill pack itself. Run from the project root or pass -Target <project root>."
}

# Pack-owned skills: replace on every install
$skills = Get-ChildItem -LiteralPath (Join-Path $Pack 'skills') -Directory
$skillRoots = @(
  (Join-Path $Target '.claude\skills'),
  (Join-Path $Target '.agents\skills')
)

foreach ($root in $skillRoots) {
  New-Item -ItemType Directory -Force -Path $root | Out-Null
  foreach ($skill in $skills) {
    $dest = Join-Path $root $skill.Name
    if (Test-Path -LiteralPath $dest) {
      Remove-Item -LiteralPath $dest -Recurse -Force
    }
    Copy-Item -LiteralPath $skill.FullName -Destination $dest -Recurse
  }
  Write-Host "skills  -> $root ($($skills.Count) skills)"
}

# Project-owned files: copy only when missing
$templates = @(
  @{ From = 'AGENTS.md';            To = 'AGENTS.md' },
  @{ From = 'CLAUDE.md';            To = 'CLAUDE.md' },
  @{ From = 'glossary.md';          To = 'docs\glossary.md' },
  @{ From = 'claude-settings.json'; To = '.claude\settings.json' }
)

foreach ($t in $templates) {
  $dest = Join-Path $Target $t.To
  if (Test-Path -LiteralPath $dest) {
    Write-Host "skip    $($t.To) (already exists)"
    continue
  }
  New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
  Copy-Item -LiteralPath (Join-Path $Pack "templates\$($t.From)") -Destination $dest
  Write-Host "added   $($t.To)"
}

# Claude Code reads CLAUDE.md instead of AGENTS.md when a CLAUDE.md exists
$claudeMd = Join-Path $Target 'CLAUDE.md'
if (-not (Select-String -LiteralPath $claudeMd -Pattern '^@AGENTS\.md' -Quiet)) {
  Write-Warning "CLAUDE.md does not import AGENTS.md. Add a line '@AGENTS.md' or Claude Code will not load the shared rules."
}

Write-Host ''
Write-Host 'Next: fill in the [placeholders] in AGENTS.md and docs/glossary.md.'
