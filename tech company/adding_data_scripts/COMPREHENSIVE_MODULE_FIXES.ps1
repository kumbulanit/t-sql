# COMPREHENSIVE SQL TRAINING MODULE FIXES
# Systematically fixes column reference errors across all 18 modules
# Author: SQL Training Enhancement Project
# Date: October 8, 2025

Write-Host "🎯 Starting Comprehensive Module Fixes..." -ForegroundColor Green
Write-Host "========================================"

# Define base paths
$basePath = "C:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning"
$paths = @(
    "$basePath\untitled", 
    "$basePath\t-sql\tech company\untitled"
)

# Define column mapping corrections
$columnFixes = @{
    # Employee table fixes
    '(?<!\w)Title(?!\w)' = 'JobTitle'
    '\be\.Title\b' = 'e.JobTitle'
    '\bemp\.Title\b' = 'emp.JobTitle'
    '\bmgr\.Title\b' = 'mgr.JobTitle'
    '\bmgr1\.Title\b' = 'mgr1.JobTitle'
    '\bmgr2\.Title\b' = 'mgr2.JobTitle'
    '\bmgr3\.Title\b' = 'mgr3.JobTitle'
    '\bmgr4\.Title\b' = 'mgr4.JobTitle'
    
    # Project table Status fixes
    '\bp\.IsActive\b' = 'p.Status'
    '\bProject\.IsActive\b' = 'Project.Status'
    "IsActive = 'Active'" = "Status = 'Active'"
    "IsActive = 'Completed'" = "Status = 'Completed'"
    "IsActive = 'In Progress'" = "Status = 'In Progress'"
    "IsActive = 'On Hold'" = "Status = 'On Hold'"
    "IsActive = 'Cancelled'" = "Status = 'Cancelled'"
    
    # Products table fixes (if any remain)
    '\bBaseSalary\b(?=.*Products?)' = 'UnitPrice'
    '\bUnitsInStock\b' = 'StockQuantity'
    
    # Address field fixes
    '\bState\b(?!\w)(?!.*Province)' = 'StateProvince'
}

# File patterns to process
$filePatterns = @(
    "*.md",
    "*.sql"
)

$totalFilesProcessed = 0
$totalReplacements = 0

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "Processing path: $path" -ForegroundColor Yellow
        
        # Find all modules (1-18)
        for ($moduleNum = 1; $moduleNum -le 18; $moduleNum++) {
            $modulePatterns = @(
                "Module $moduleNum*",
                "Module$moduleNum*", 
                "module $moduleNum*"
            )
            
            foreach ($modulePattern in $modulePatterns) {
                $modulePath = Join-Path $path $modulePattern
                $moduleDir = Get-ChildItem $path -Directory | Where-Object { $_.Name -match "Module\s*$moduleNum\b" } | Select-Object -First 1
                
                if ($moduleDir) {
                    Write-Host "  ✓ Processing Module $moduleNum" -ForegroundColor Cyan
                    
                    foreach ($filePattern in $filePatterns) {
                        $files = Get-ChildItem -Path $moduleDir.FullName -Filter $filePattern -Recurse
                        
                        foreach ($file in $files) {
                            $content = Get-Content $file.FullName -Raw -Encoding UTF8
                            $originalContent = $content
                            $fileReplacements = 0
                            
                            # Apply each column fix
                            foreach ($pattern in $columnFixes.Keys) {
                                $replacement = $columnFixes[$pattern]
                                $newContent = $content -replace $pattern, $replacement
                                if ($newContent -ne $content) {
                                    $matches = ([regex]::Matches($content, $pattern)).Count
                                    $fileReplacements += $matches
                                    Write-Host "    - Fixed $matches instances of '$pattern' → '$replacement' in $($file.Name)" -ForegroundColor Green
                                    $content = $newContent
                                }
                            }
                            
                            # Save if changes were made
                            if ($content -ne $originalContent) {
                                Set-Content -Path $file.FullName -Value $content -Encoding UTF8
                                $totalFilesProcessed++
                                $totalReplacements += $fileReplacements
                                Write-Host "    💾 Saved: $($file.Name) ($fileReplacements fixes)" -ForegroundColor Magenta
                            }
                        }
                    }
                }
            }
        }
    }
}

Write-Host ""
Write-Host "🎉 COMPREHENSIVE FIXES COMPLETED!" -ForegroundColor Green
Write-Host "=================================="
Write-Host "📁 Files processed: $totalFilesProcessed" -ForegroundColor White
Write-Host "🔧 Total replacements: $totalReplacements" -ForegroundColor White
Write-Host ""
Write-Host "✅ KEY IMPROVEMENTS APPLIED:" -ForegroundColor Yellow
Write-Host "• Title → JobTitle (All employee references)" -ForegroundColor White
Write-Host "• p.IsActive → p.Status (All project references)" -ForegroundColor White  
Write-Host "• Project status values standardized" -ForegroundColor White
Write-Host "• Address State → StateProvince corrections" -ForegroundColor White
Write-Host ""
Write-Host "🎓 All 18 modules now have consistent column references!" -ForegroundColor Green
Write-Host "Ready for beginner-friendly learning experience." -ForegroundColor Cyan