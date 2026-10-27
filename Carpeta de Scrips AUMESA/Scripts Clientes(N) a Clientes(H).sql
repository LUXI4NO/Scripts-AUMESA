SELECT
    t.Sum6VehDom,
    t.Sum6Sts AS StsHabilitado,
    scH.SumNom AS NombreHabilitado,
    scH.CliCod AS CodigoClienteHabilitado,
    scH.SumTar AS MedioDePagoClienteHabilitado,
    b.Sum6Sts AS StsBaja,
    b.Sum6FecBaj AS FechaBaja,
    scB.SumNom AS NombreBaja,
    scB.CliCod AS CodigoClienteBaja,
    scB.SumTar AS MedioDePagoClienteBaja
FROM SubTag AS t
INNER JOIN SubTag AS b
    ON b.Sum6VehDom = t.Sum6VehDom
    AND b.Sum6Sts = 'N'
    AND b.Sum6FecBaj >= '20260601'
INNER JOIN SubCta AS scH
    ON scH.CliCod = t.CliCod
    AND scH.SumNro = t.SumNro
    AND scH.SucCod = t.SucCod
INNER JOIN SubCta AS scB
    ON scB.CliCod = b.CliCod
    AND scB.SumNro = b.SumNro
    AND scB.SucCod = b.SucCod
WHERE t.Sum6Sts = 'H';