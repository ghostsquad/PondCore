function Assert-ScriptBlockParametersEqual {
    param (
        [ScriptBlock]$x,
        [ScriptBlock]$y,
        [Switch]$AssertNamesMatch,
        [Switch]$Strict
    )

    if($x -eq $null -or $y -eq $null) {
        throw (New-Object Aether.Core.ParametersNotEquivalentException('X or Y is Null'))
    }

    $xParams = @(?: {$x.Ast.ParamBlock -ne $null} {$x.Ast.ParamBlock.Parameters} {})
    $yParams = @(?: {$y.Ast.ParamBlock -ne $null} {$y.Ast.ParamBlock.Parameters} {})
    if($Strict -and $xParams.Count -ne $yParams.Count) {
        $msg = 'Param count mismatch. x: {0} y: {1}' -f $xParams.Count, $yParams.Count
        throw (New-Object Aether.Core.ParametersNotEquivalentException($msg))
    }

    [int]$max = ?: { $xParams.Count -le $yParams.Count } { $xParams.Count } { $yParams.Count }

    for($i = 0; $i -lt $max; $i++) {
        if($xParams[$i].StaticType -ne $yParams[$i].StaticType) {
            $msg = 'Param type mismatch. x: {0} y: {1}' -f $xParams[$i].StaticType, $yParams[$i].StaticType
            throw (New-Object Aether.Core.ParametersNotEquivalentException($msg))
        }

        if($AssertNamesMatch) {
            if($xParams[$i].Name.ToString() -ne $yParams[$i].Name.ToString()) {
                $msg = 'Param name mismatch. x: {0} y: {1}' -f $xParams[$i].Name, $yParams[$i].Name
                throw (New-Object Aether.Core.ParametersNotEquivalentException($msg))
            }
        }
    }
}