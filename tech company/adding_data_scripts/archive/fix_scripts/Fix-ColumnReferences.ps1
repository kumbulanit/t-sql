# Fix HoursWorked and IsActive Column Reference Errors in SQL Training Files
# This script systematically fixes common column reference issues

Write-Host "=== TechCorp SQL Training Column Reference Fix ===" -ForegroundColor Green
Write-Host ""

# Get all markdown files that might contain SQL queries
$sqlTrainingFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object { 
    $_.FullName -like "*Module*" -or 
    $_.FullName -like "*Lab*" -or 
    $_.FullName -like "*Lesson*" -or
    $_.FullName -like "*Exercise*"
}

Write-Host "Found $($sqlTrainingFiles.Count) training files to check..." -ForegroundColor Yellow

$totalFixes = 0

foreach ($file in $sqlTrainingFiles) {
    Write-Host "Checking: $($file.Name)" -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileFixes = 0
    
    # Fix 1: HoursWorked without proper table reference (direct from Employees)
    # Pattern: SELECT ... HoursWorked ... FROM Employees (without JOIN to EmployeeProjects)
    if ($content -match "SELECT.*HoursWorked.*FROM\s+Employees(?!\s+e\s+.*JOIN.*EmployeeProjects)") {
        Write-Host "  ⚠️  Found HoursWorked query from Employees without EmployeeProjects JOIN" -ForegroundColor Red
        
        # This is complex to auto-fix, so we'll flag it
        $content = $content -replace "(SELECT[^F]*)(HoursWorked)", "`$1-- TODO: Fix HoursWorked reference - use ep.HoursWorked from EmployeeProjects table`n    `$2"
        $fileFixes++
    }
    
    # Fix 2: Ambiguous IsActive references (WHERE IsActive = 1 without table alias)
    # Pattern: WHERE IsActive = 1 (without table prefix)
    $ambiguousIsActivePattern = "WHERE\s+IsActive\s*=\s*1(?!\s*--)"
    if ($content -match $ambiguousIsActivePattern) {
        Write-Host "  ⚠️  Found ambiguous IsActive reference" -ForegroundColor Red
        
        # Try to determine the main table from context
        if ($content -match "FROM\s+Employees\s+e") {
            $content = $content -replace "WHERE\s+IsActive\s*=\s*1", "WHERE e.IsActive = 1"
            Write-Host "    ✅ Fixed: Changed to e.IsActive = 1" -ForegroundColor Green
        } elseif ($content -match "FROM\s+Departments\s+d") {
            $content = $content -replace "WHERE\s+IsActive\s*=\s*1", "WHERE d.IsActive = 1"
            Write-Host "    ✅ Fixed: Changed to d.IsActive = 1" -ForegroundColor Green
        } elseif ($content -match "FROM\s+Companies\s+c") {
            $content = $content -replace "WHERE\s+IsActive\s*=\s*1", "WHERE c.IsActive = 1"
            Write-Host "    ✅ Fixed: Changed to c.IsActive = 1" -ForegroundColor Green
        } elseif ($content -match "FROM\s+Projects\s+p") {
            $content = $content -replace "WHERE\s+IsActive\s*=\s*1", "WHERE p.IsActive = 1"
            Write-Host "    ✅ Fixed: Changed to p.IsActive = 1" -ForegroundColor Green
        }
        $fileFixes++
    }
    
    # Fix 3: IsActive in complex joins without proper disambiguation
    $joinWithIsActivePattern = "FROM\s+\w+\s+\w+.*JOIN.*WHERE.*IsActive\s*=\s*1"
    if ($content -match $joinWithIsActivePattern -and $content -notmatch "WHERE\s+\w+\.IsActive\s*=\s*1") {
        Write-Host "  ⚠️  Found JOIN query with ambiguous IsActive" -ForegroundColor Red
        
        # Add comment for manual review
        $content = $content -replace "(WHERE.*)(IsActive\s*=\s*1)", "`$1-- TODO: Specify table alias for IsActive (e.g., e.IsActive, d.IsActive)`n  `$2"
        $fileFixes++
    }
    
    # Fix 4: Missing table aliases for common patterns
    # Pattern: SELECT HoursWorked FROM ... without ep. prefix
    if ($content -match "SELECT.*(?<!ep\.)HoursWorked" -and $content -match "EmployeeProjects") {
        $content = $content -replace "(?<!ep\.)HoursWorked(?!\s*--)", "ep.HoursWorked"
        Write-Host "    ✅ Fixed: Added ep. prefix to HoursWorked" -ForegroundColor Green
        $fileFixes++
    }
    
    # Fix 5: Common IsActive patterns in specific contexts
    # Pattern: Employees queries
    if ($content -match "FROM\s+Employees(?!\s+\w+)" -and $content -match "WHERE.*IsActive") {
        $content = $content -replace "FROM\s+Employees\s+", "FROM Employees e "
        $content = $content -replace "WHERE\s+IsActive", "WHERE e.IsActive"
        Write-Host "    ✅ Fixed: Added Employees table alias" -ForegroundColor Green
        $fileFixes++
    }
    
    # Fix 6: Projects Status vs IsActive confusion
    # Some queries might use Status when they mean IsActive
    if ($content -match "WHERE.*Status\s*=\s*'Active'" -and $content -match "Projects") {
        Write-Host "  ℹ️  Found Status = 'Active' in Projects query (verify if should be IsActive = 1)" -ForegroundColor Yellow
        $content = $content -replace "(WHERE.*Status\s*=\s*'Active')", "`$1 -- Note: Consider if this should be p.IsActive = 1 instead"
    }
    
    # Save the file if changes were made
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "  ✅ Updated $($file.Name) with $fileFixes fixes" -ForegroundColor Green
        $totalFixes += $fileFixes
    } else {
        Write-Host "  ✅ No issues found in $($file.Name)" -ForegroundColor DarkGreen
    }
}

Write-Host ""
Write-Host "=== Fix Summary ===" -ForegroundColor Green
Write-Host "Total files processed: $($sqlTrainingFiles.Count)" -ForegroundColor White
Write-Host "Total fixes applied: $totalFixes" -ForegroundColor White

if ($totalFixes -gt 0) {
    Write-Host ""
    Write-Host "⚠️  MANUAL REVIEW REQUIRED:" -ForegroundColor Yellow
    Write-Host "Some fixes may require manual verification. Look for TODO comments in the files." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Common patterns to verify:" -ForegroundColor Cyan
    Write-Host "1. HoursWorked should come from EmployeeProjects (ep.HoursWorked) or TimeTracking (tt.HoursWorked)" -ForegroundColor White
    Write-Host "2. IsActive should have table alias (e.IsActive, d.IsActive, etc.)" -ForegroundColor White
    Write-Host "3. Projects.Status vs Projects.IsActive usage" -ForegroundColor White
    Write-Host "4. Ensure proper JOINs when accessing related table columns" -ForegroundColor White
} else {
    Write-Host "🎉 All files look good! No column reference issues found." -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Quick Reference ===" -ForegroundColor Cyan
Write-Host "✅ Correct HoursWorked patterns:" -ForegroundColor Green
Write-Host "   - ep.HoursWorked (from EmployeeProjects)" -ForegroundColor White
Write-Host "   - tt.HoursWorked (from TimeTracking)" -ForegroundColor White
Write-Host ""
Write-Host "✅ Correct IsActive patterns:" -ForegroundColor Green
Write-Host "   - e.IsActive (Employees)" -ForegroundColor White
Write-Host "   - d.IsActive (Departments)" -ForegroundColor White
Write-Host "   - p.IsActive (Projects)" -ForegroundColor White
Write-Host "   - c.IsActive (Companies)" -ForegroundColor White
Write-Host ""
Write-Host "❌ Avoid these patterns:" -ForegroundColor Red
Write-Host "   - SELECT HoursWorked FROM Employees (Employees table has no HoursWorked column)" -ForegroundColor White
Write-Host "   - WHERE IsActive = 1 (ambiguous when multiple tables have IsActive)" -ForegroundColor White