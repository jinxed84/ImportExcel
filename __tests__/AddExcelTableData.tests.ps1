if (-not (Get-command Import-Excel -ErrorAction SilentlyContinue)) {
    Import-Module $PSScriptRoot\..\ImportExcel.psd1
}

Describe "Test Add Excel Table Data" -Tag 'Add-ExcelTableData' {
    BeforeEach {
        
        $script:data = ConvertFrom-Csv @"
    Region,State,Units,Price
    East,Illinois,424,141.07
    South,Mississippi,976,175.07
    North,Illinois,523,768.78
    West,Idaho,754,045.42
    East,Nevada,935,851.40
    South,Alabama,937,771.05
    North,Idaho,866,709.83
    South,Nebraska,697,464.95
"@

        $script:newData = ConvertFrom-Csv @"
Region,State,Units,Price
East,NYC1,4,1
East,NYC2,4,1
South,NYC2,4,1
West,NYC2,4,1
"@        
    }
    
    It 'Should update a table' {
        $xlfile = "TestDrive:\testdata.xlsx"
        $data | Export-Excel -Path $xlfile -TableName salesData

        $actual = Get-ExcelTable $xlfile
 
        $actual[0].WorksheetName | Should -BeExactly 'Sheet1'
        $actual[0].TableName | Should -BeExactly 'salesData'
 
        $actual[0].Address | Should -BeExactly 'A1:D9'
        $actual[0].Columns[0].Name | Should -BeExactly 'Region'
        $actual[0].Columns[1].Name | Should -BeExactly 'State'
        $actual[0].Columns[2].Name | Should -BeExactly 'Units'
        $actual[0].Columns[3].Name | Should -BeExactly 'Price'

        # Do the add
        Add-ExcelTableData -Path $xlfile -WorksheetName Sheet1 -TableName salesData -Data $newData

        $actual = Get-ExcelTable $xlfile
 
        $actual[0].WorksheetName | Should -BeExactly 'Sheet1'
        $actual[0].TableName | Should -BeExactly 'salesData'
 
        $actual[0].Address | Should -BeExactly 'A1:D13'
        $actual[0].Columns[0].Name | Should -BeExactly 'Region'
        $actual[0].Columns[1].Name | Should -BeExactly 'State'
        $actual[0].Columns[2].Name | Should -BeExactly 'Units'
        $actual[0].Columns[3].Name | Should -BeExactly 'Price'
    }
}