SELECT
    SUBTAG.CliCod,
    CLIENT.CliApe,
    CLIENT.CliNom,
    SUBCTA.SumNro AS SubcuentaMorosa,
    SUBTAG.Sum6Tag AS TagNeutralizado,
    SUBTAG.Sum6VehDom AS Patente,
    OtraSubCTA.SumNro AS OtraSubcuenta,
    OtraSubTAG.Sum6Tag AS TagHabilitado,
    OtraSubSER.Sum2Sts AS EstadoServicioOtraSubcuenta
FROM SUBCTA
INNER JOIN SUBTAG
    ON SUBTAG.SucCod = SUBCTA.SucCod
    AND SUBTAG.CliCod = SUBCTA.CliCod
    AND SUBTAG.SumNro = SUBCTA.SumNro
INNER JOIN SUBSER
    ON SUBSER.SucCod = SUBTAG.SucCod
    AND SUBSER.CliCod = SUBTAG.CliCod
    AND SUBSER.SumNro = SUBTAG.SumNro
    AND SUBSER.SrvCod = SUBTAG.SrvCod
INNER JOIN SUBTAG AS OtraSubTAG
    ON OtraSubTAG.SucCod = SUBTAG.SucCod
    AND OtraSubTAG.CliCod = SUBTAG.CliCod
    AND OtraSubTAG.SumNro <> SUBTAG.SumNro
    AND OtraSubTAG.Sum6VehDom = SUBTAG.Sum6VehDom
INNER JOIN SUBCTA AS OtraSubCTA
    ON OtraSubCTA.SucCod = OtraSubTAG.SucCod
    AND OtraSubCTA.CliCod = OtraSubTAG.CliCod
    AND OtraSubCTA.SumNro = OtraSubTAG.SumNro
INNER JOIN SUBSER AS OtraSubSER
    ON OtraSubSER.SucCod = OtraSubCTA.SucCod
    AND OtraSubSER.CliCod = OtraSubCTA.CliCod
    AND OtraSubSER.SumNro = OtraSubCTA.SumNro
    AND OtraSubSER.SrvCod = OtraSubTAG.SrvCod
INNER JOIN CLIENT
    ON CLIENT.SucCod = SUBCTA.SucCod
    AND CLIENT.CliCod = SUBCTA.CliCod
WHERE SUBCTA.SumSts = 'M'
    AND SUBSER.Sum2Sts = 3
    AND SUBTAG.Sum6Sts = 'N'
    AND OtraSubCTA.SumSts = '0'
    AND OtraSubTAG.Sum6Sts = 'H'
    AND SUBTAG.Sum6VehDom <> '';


SELECT TOP 5
    SUBTAG.CliCod AS ClienteMoroso,
    SUBCTA.SumNro AS SubcuentaMorosa,
    SUBTAG.Sum6VehDom AS Patente,
    OtraSubTAG.CliCod AS OtroCliente,
    OtraSubCTA.SumNro AS OtraSubcuenta,
    OtraSubTAG.Sum6Tag AS TagHabilitado
FROM SUBCTA WITH (NOLOCK)
INNER JOIN SUBTAG WITH (NOLOCK)
    ON SUBTAG.SucCod = SUBCTA.SucCod
    AND SUBTAG.CliCod = SUBCTA.CliCod
    AND SUBTAG.SumNro = SUBCTA.SumNro
INNER JOIN SUBSER WITH (NOLOCK)
    ON SUBSER.SucCod = SUBTAG.SucCod
    AND SUBSER.CliCod = SUBTAG.CliCod
    AND SUBSER.SumNro = SUBTAG.SumNro
    AND SUBSER.SrvCod = SUBTAG.SrvCod
INNER JOIN SUBTAG AS OtraSubTAG WITH (NOLOCK)
    ON OtraSubTAG.SucCod = SUBTAG.SucCod
    AND OtraSubTAG.CliCod <> SUBTAG.CliCod
    AND OtraSubTAG.Sum6VehDom = SUBTAG.Sum6VehDom
    AND OtraSubTAG.Sum6Sts = 'H'
INNER JOIN SUBCTA AS OtraSubCTA WITH (NOLOCK)
    ON OtraSubCTA.SucCod = OtraSubTAG.SucCod
    AND OtraSubCTA.CliCod = OtraSubTAG.CliCod
    AND OtraSubCTA.SumNro = OtraSubTAG.SumNro
WHERE SUBCTA.SumSts = 'M'
    AND SUBSER.Sum2Sts = 3
    AND SubTag.Sum6FecBaj >= '20260801'
    AND SUBTAG.Sum6Sts = 'N'
    AND OtraSubCTA.SumSts = '0'
    AND OtraSubTAG.Sum6Sts = 'H'
    AND SUBTAG.Sum6VehDom <> ''


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
