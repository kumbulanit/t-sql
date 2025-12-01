# Fix All Module Column References
# This script fixes common column reference errors across all training modules

Write-Host "=== Fixing Column References Across All Modules ===" -ForegroundColor Green
Write-Host ""

# Get all markdown files in module directories
$moduleFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object { 
    $_.DirectoryName -like "*Module*" -and
    ($_.Name -like "*Lab*" -or $_.Name -like "*Exercise*")
}

Write-Host "Found $($moduleFiles.Count) module files to fix..." -ForegroundColor Yellow

$totalFixes = 0

foreach ($file in $moduleFiles) {
    Write-Host "Checking: $($file.Name)" -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileFixes = 0
    
    # Fix 1: Title -> JobTitle (Employees table)
    if ($content -match 'e\.Title|emp\.Title') {
        $content = $content -replace 'e\.Title', 'e.JobTitle'
        $content = $content -replace 'emp\.Title', 'emp.JobTitle'
        $content = $content -replace 'mgr\.Title', 'mgr.JobTitle'
        $content = $content -replace 'SELECT DISTINCT Title', 'SELECT DISTINCT JobTitle'
        $content = $content -replace 'ORDER BY Title', 'ORDER BY JobTitle'
        $fileFixes++
        Write-Host "  ✓ Fixed Title -> JobTitle references" -ForegroundColor Green
    }
    
    # Fix 2: State -> StateProvince
    if ($content -match 'City, State|State IS NOT NULL|ORDER BY State') {
        $content = $content -replace 'City, State', 'City, StateProvince'
        $content = $content -replace 'State IS NOT NULL', 'StateProvince IS NOT NULL'
        $content = $content -replace 'ORDER BY State', 'ORDER BY StateProvince'
        $fileFixes++
        Write-Host "  ✓ Fixed State -> StateProvince references" -ForegroundColor Green
    }
    
    # Fix 3: p.IsActive -> p.Status (Projects table)
    if ($content -match 'p\.IsActive') {
        $content = $content -replace 'p\.IsActive AS ProjectIsActive', 'p.Status AS ProjectStatus'
        $content = $content -replace 'p\.IsActive = ''In Progress''', 'p.Status = ''Active'''
        $content = $content -replace 'p\.IsActive = 1', 'p.Status = ''Active'''
        $content = $content -replace 'p\.IsActive,', 'p.Status,'
        $content = $content -replace 'p\.IsActive\)', 'p.Status)'
        $fileFixes++
        Write-Host "  ✓ Fixed p.IsActive -> p.Status references" -ForegroundColor Green
    }
    
    # Fix 4: DepartmentIDID -> DepartmentID (typo)
    if ($content -match 'DepartmentIDID') {
        $content = $content -replace 'DepartmentIDID', 'DepartmentID'
        $fileFixes++
        Write-Host "  ✓ Fixed DepartmentIDID typo" -ForegroundColor Green
    }
    
    # Fix 5: Products BaseSalary -> UnitPrice (from Module 7 fixes, may appear in other modules)
    if ($content -match 'p\.BaseSalary' -and $content -match 'Products.*p') {
        $content = $content -replace 'p\.BaseSalary', 'p.UnitPrice'
        $fileFixes++
        Write-Host "  ✓ Fixed Products.BaseSalary -> UnitPrice references" -ForegroundColor Green
    }
    
    # Fix 6: UnitsInStock -> StockQuantity (Products table)
    if ($content -match 'UnitsInStock' -and $content -match 'Products') {
        $content = $content -replace 'UnitsInStock', 'StockQuantity'
        $fileFixes++
        Write-Host "  ✓ Fixed UnitsInStock -> StockQuantity references" -ForegroundColor Green
    }
    
    # Fix 7: Discontinued -> IsActive (with proper logic inversion)
    if ($content -match 'Discontinued = 1') {
        $content = $content -replace 'Discontinued = 1', 'IsActive = 0'
        $content = $content -replace 'Discontinued = 0', 'IsActive = 1'
        $fileFixes++
        Write-Host "  ✓ Fixed Discontinued -> IsActive references" -ForegroundColor Green
    }
    
    # Fix 8: Add beginner-friendly comments where missing
    if ($content -match 'SELECT.*FROM.*WHERE' -and -not ($content -match '--.*Step \d+')) {
        # This is complex, skip for now - will do manually for key files
    }
    
    # Save file if changes were made
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        $totalFixes += $fileFixes
        Write-Host "  💾 Saved $fileFixes fixes to $($file.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ No fixes needed" -ForegroundColor Gray
    }
    
    Write-Host ""
}

Write-Host "=== SUMMARY ===" -ForegroundColor Green
Write-Host "Total files processed: $($moduleFiles.Count)" -ForegroundColor White
Write-Host "Total fixes applied: $totalFixes" -ForegroundColor White
Write-Host ""
Write-Host "🎯 All column reference issues should now be resolved!" -ForegroundColor Green
Write-Host "✅ Training modules should execute without SQL column errors" -ForegroundColor Green