$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$map = @{
  'MASTER_BLUEPRINT.md' = @{ title = 'Master Blueprint'; parent = 'Developer'; order = 10 }
  'ARCHITECTURE.md'     = @{ title = 'Architecture'; parent = 'Developer'; order = 11 }
  'REPOSITORIES.md'     = @{ title = 'Repositories'; parent = 'Developer'; order = 12 }
  'SETUP.md'            = @{ title = 'Setup Guide'; parent = 'Developer'; order = 13 }
  'ROADMAP.md'          = @{ title = 'Roadmap'; parent = 'Developer'; order = 14 }
  'DATABASE.md'         = @{ title = 'Database'; parent = 'Developer'; order = 15 }
  'SERVICES.md'         = @{ title = 'Services'; parent = 'Developer'; order = 16 }
  'SCREENS.md'          = @{ title = 'Screens'; parent = 'Developer'; order = 17 }
  'PERMISSIONS.md'      = @{ title = 'Permissions'; parent = 'Developer'; order = 18 }
  'TESTING.md'          = @{ title = 'Testing'; parent = 'Developer'; order = 19 }
  'LOCAL_BUILD.md'      = @{ title = 'Local Build'; parent = 'Developer'; order = 20 }
  'DESIGN_SYSTEM.md'    = @{ title = 'Design System'; parent = 'Design'; order = 1 }
  'USER_FLOWS.md'       = @{ title = 'User Flows'; parent = 'Design'; order = 2 }
  'DIAGRAMS.md'         = @{ title = 'Diagrams'; parent = 'Design'; order = 3 }
  'ASSETS.md'           = @{ title = 'Assets'; parent = 'Design'; order = 4 }
  'SOUNDS.md'           = @{ title = 'Sounds'; parent = 'Design'; order = 5 }
  'L10N.md'             = @{ title = 'L10N'; parent = 'Design'; order = 6 }
  'WIDGETS.md'          = @{ title = 'Widgets'; parent = 'Design'; order = 7 }
  'CONSTANTS.md'        = @{ title = 'Constants'; parent = 'Reference'; order = 1 }
  'FEATURE_FLAGS.md'    = @{ title = 'Feature Flags'; parent = 'Reference'; order = 2 }
  'ERROR_HANDLING.md'   = @{ title = 'Error Handling'; parent = 'Reference'; order = 3 }
  'EVENTS.md'           = @{ title = 'Events'; parent = 'Reference'; order = 4 }
  'BATTERY.md'          = @{ title = 'Battery'; parent = 'Reference'; order = 5 }
  'API_INTEGRATION.md'  = @{ title = 'API Integration'; parent = 'Reference'; order = 6 }
  'PLAY_STORE.md'       = @{ title = 'Play Store'; parent = 'Release'; order = 1 }
  'RELEASE_QA_SIGNOFF.md' = @{ title = 'QA Sign-off'; parent = 'Release'; order = 2; exclude = $true }
  'GITHUB_RELEASE.md'   = @{ title = 'GitHub Release'; parent = 'Release'; order = 3 }
  'play-store/ASSETS_README.md' = @{ title = 'Store Assets'; parent = 'Release'; order = 4 }
  'play-store/FEATURE_GRAPHIC.md' = @{ title = 'Feature Graphic'; parent = 'Release'; order = 5 }
  'PRIVACY.md'          = @{ title = 'Privacy (repo)'; parent = 'Legal'; order = 99; exclude = $true }
}

Get-ChildItem -Recurse -Filter '*.md' | ForEach-Object {
  $rel = $_.FullName.Substring($root.Length + 1).Replace('\', '/')
  if ($rel -eq 'index.md') { return }
  if ($rel -match '^(privacy-policy|terms|data-safety|open-source)\.md$') { return }

  $key = if ($map.ContainsKey($rel)) { $rel } elseif ($map.ContainsKey($_.Name)) { $_.Name } else { return }
  $m = $map[$key]
  $content = Get-Content $_.FullName -Raw
  if ($content -match '^---') { return }

  $excludeLine = if ($m.exclude) { "`nnav_exclude: true" } else { '' }
  $permalink = '/' + ($rel -replace '\.md$', '/') 
  $fm = @"
---
layout: default
title: $($m.title)
parent: $($m.parent)
nav_order: $($m.order)$excludeLine
permalink: $permalink
---

"@
  Set-Content -Path $_.FullName -Value ($fm + $content) -NoNewline
  Write-Output "Updated $rel"
}
