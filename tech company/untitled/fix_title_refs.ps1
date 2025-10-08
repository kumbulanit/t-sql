# Fix Title to JobTitle references
$files = @(
    "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\untitled\Module 4\Lesson1_Understanding_Joins.md",
    "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\untitled\Module 4\Lesson2_Querying_with_Inner_Joins.md",
    "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\untitled\Module 4\Lesson3_Querying_with_Outer_Joins.md",
    "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\untitled\Module 4\Module4_Exercise_Answers.md",
    "c:\Users\kumbulani.tshuma\OneDrive - Investec\Documents\ccmlogs\sql trainning\untitled\Module 4\Lab_Querying_Multiple_Tables_Answers.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $content = $content -replace "e\.Title", "e.JobTitle"
        $content = $content -replace "emp\.Title", "emp.JobTitle" 
        $content = $content -replace "\bTitle\b(?=\s*,|\s*$|\s*FROM|\s*ORDER)", "JobTitle"
        Set-Content $file $content -NoNewLine
        Write-Host "Fixed: $file"
    }
}
