CREATE VIEW GR_Empresas_RFC AS
select
    MAX(Cli.Cli_Consecutivo) AS id,
    MAX(Cli.Cli_Corto) AS nm_corto,
    MAX(Cli.Cli_Razon) as nm,
    ISNULL(IIF(MAX(CCP.ClP_Valor) = '', CAST(MAX(Cli.Cli_Consecutivo) AS VARCHAR), MAX(CCP.ClP_Valor)), MAX(Cli.Cli_Consecutivo)) AS gen_RFC

from Ca_Cliente Cli
left join Ca_ClientePermiso CCP on Cli.Cli_Consecutivo = CCP.Cli_Consecutivo AND CCP.ReP_Clave IN ('RFC', 'IRS')
GROUP BY CCP.Cli_Consecutivo;