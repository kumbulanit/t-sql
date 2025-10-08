# Column Reference Fix Script for All Modules
# This script systematically fixes column reference errors across all training modules

param(
    [string]$RootPath = "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\t-sql\tech company\untitled"
)

Write-Host "=== COMPREHENSIVE COLUMN REFERENCE FIXES ===" -ForegroundColor Green
Write-Host "Fixing column reference errors across all training modules..." -ForegroundColor Yellow
Write-Host ""

# Define column mappings
$fixes = @{
    # Employees table fixes
    'e\.Title(?!\w)' = 'e.JobTitle'
    'emp\.Title(?!\w)' = 'emp.JobTitle'  
    'mgr\.Title(?!\w)' = 'mgr.JobTitle'
    '\.State(?!\w)' = '.StateProvince'
    'e\.State(?!\w)' = 'e.StateProvince'
    'emp\.State(?!\w)' = 'emp.StateProvince'
    'e\.Phone(?!\w)' = 'e.WorkPhone'
    'emp\.Phone(?!\w)' = 'emp.WorkPhone'
    
    # Projects table fixes - Status vs IsActive
    "p\.IsActive\s*=\s*'Active'" = "p.Status = 'Active'"
    "p\.IsActive\s*=\s*'In Progress'" = "p.Status = 'In Progress'" 
    "p\.IsActive\s*=\s*'Completed'" = "p.Status = 'Completed'"
    "p\.IsActive\s*=\s*'On Hold'" = "p.Status = 'On Hold'"
    "p\.IsActive\s*=\s*'Cancelled'" = "p.Status = 'Cancelled'"
    
    # Fix reference to incorrect column name patterns
    'DepartmentIDID' = 'DepartmentID'
    'EmployeeIDID' = 'EmployeeID'
    
    # Fix common column name errors in SELECT clauses
    'SELECT\s+.*Title(?!\w)' = 'JobTitle'
    ',\s*Title(?!\w)' = ', JobTitle'
    'ORDER BY.*Title(?!\w)' = 'ORDER BY JobTitle'
    'GROUP BY.*Title(?!\w)' = 'GROUP BY JobTitle'
}

$totalFixes = 0
$filesProcessed = 0

# Get all markdown files in modules
$moduleFiles = Get-ChildItem -Path $RootPath -Filter "*.md" -Recurse | Where-Object { 
    $_.FullName -match "Module \d+" -and 
    ($_.Name -like "*Lab*" -or $_.Name -like "*Exercise*" -or $_.Name -like "*Lesson*")
}

Write-Host "Found $($moduleFiles.Count) module files to process..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $moduleFiles) {
    $relativePath = $file.FullName.Replace($RootPath, "").TrimStart('\')
    Write-Host "Processing: $relativePath" -ForegroundColor White
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    $fileFixes = 0
    
    # Apply each fix
    foreach ($pattern in $fixes.Keys) {
        $replacement = $fixes[$pattern]
        $matches = [regex]::Matches($content, $pattern)
        
        if ($matches.Count -gt 0) {
            $content = [regex]::Replace($content, $pattern, $replacement)
            $fileFixes += $matches.Count
            Write-Host "  ✓ Fixed $($matches.Count) instances of '$pattern' → '$replacement'" -ForegroundColor Green
        }
    }
    
    # Additional specific fixes for common patterns
    
    # Fix title references in column lists and aliases  
    $titlePatterns = @(
        '(\s+)Title(\s+AS\s+\[)'
        '(\s+)Title(\s*,)'  
        '(\s+)Title(\s*$)'
        '(\s+)Title(\s+\w+)'
    )
    
    foreach ($pattern in $titlePatterns) {
        $matches = [regex]::Matches($content, $pattern)
        if ($matches.Count -gt 0) {
            $content = [regex]::Replace($content, $pattern, '${1}JobTitle${2}')
            $fileFixes += $matches.Count
        }
    }
    
    # Save file if changes were made
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "  📁 File updated with $fileFixes fixes" -ForegroundColor Yellow
        $totalFixes += $fileFixes
        $filesProcessed++
    } else {
        Write-Host "  ℹ️  No issues found" -ForegroundColor Gray
    }
    
    Write-Host ""
}

Write-Host "=== SUMMARY ===" -ForegroundColor Green
Write-Host "Files processed: $filesProcessed" -ForegroundColor White
Write-Host "Total fixes applied: $totalFixes" -ForegroundColor White
Write-Host ""

if ($totalFixes -gt 0) {
    Write-Host "✅ Column reference fixes completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Key fixes applied:" -ForegroundColor Yellow
    Write-Host "• Title → JobTitle (in Employees table)" -ForegroundColor White  
    Write-Host "• State → StateProvince (in Employees table)" -ForegroundColor White
    Write-Host "• Phone → WorkPhone (in Employees table)" -ForegroundColor White
    Write-Host "• p.IsActive = 'status' → p.Status = 'status' (in Projects table)" -ForegroundColor White
    Write-Host "• Fixed duplicate ID patterns (DepartmentIDID → DepartmentID)" -ForegroundColor White
} else {
    Write-Host "ℹ️ No column reference issues found." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test SQL queries in SSMS to verify fixes work correctly" -ForegroundColor White
Write-Host "2. Review any remaining complex queries that may need manual attention" -ForegroundColor White
Write-Host "3. Ensure all exercises are beginner-friendly with step-by-step explanations" -ForegroundColor White