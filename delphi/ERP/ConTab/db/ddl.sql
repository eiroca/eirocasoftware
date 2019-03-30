/* Access SQL export data follows. Auto-generated. */

/* Tables */
DROP TABLE [AdmUtenti] /**WEAK**/;
CREATE TABLE [AdmUtenti] (
[CodUsr] COUNTER NOT NULL /**COMMENT* Codice Utente (Interno ed immodificabile) */,
[UserName] TEXT(12) NOT NULL /**COMMENT* Nome dell'utente */,
[Password] TEXT(12) /**COMMENT* Password */,
[SuperUser] BIT NOT NULL DEFAULT False /**COMMENT* Flag di superuser */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [AdmUtenti] ([CodUsr] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [ConBilanci] /**WEAK**/;
CREATE TABLE [ConBilanci] (
[CodBil] COUNTER NOT NULL /**COMMENT* Codice Bilancio (Interno ed immodificabile) */,
[CodSch] INTEGER NOT NULL /**COMMENT* Codice Schema di Bilancio */,
[Alias] TEXT(12) NOT NULL /**COMMENT* Abbreviazione - nome bilancio */,
[Desc] TEXT(30) NOT NULL /**COMMENT* Descrizione estesa del bilancio */,
[Data] DATETIME NOT NULL DEFAULT Date() /**COMMENT* Data creazione bilancio */,
[Note] LONGTEXT /**COMMENT* Annotazioni libere */,
[Ufficiale] BIT NOT NULL DEFAULT False /**COMMENT* Bilancio Ufficale */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConBilanci] ([CodBil] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Alias] ON [ConBilanci] ([Alias] ASC);

DROP TABLE [ConBilanciDett] /**WEAK**/;
CREATE TABLE [ConBilanciDett] (
[CodBil] INTEGER NOT NULL /**COMMENT* Codice Bilancio */,
[CodCon] INTEGER NOT NULL /**COMMENT* Codice Conto */,
[Saldo] MONEY NOT NULL DEFAULT 0 /**COMMENT* Saldo a bilancio */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConBilanciDett] (
[CodBil] ASC,
[CodCon] ASC
) WITH PRIMARY DISALLOW NULL;

DROP TABLE [ConConti] /**WEAK**/;
CREATE TABLE [ConConti] (
[CodCon] COUNTER NOT NULL /**COMMENT* Codice Conto (Interno ed immodificabile) */,
[Alias] TEXT(12) NOT NULL /**COMMENT* Abbreviazione - nome conto */,
[Desc] TEXT(30) NOT NULL /**COMMENT* Descrizione estesa conto */,
[Gruppo] BIT NOT NULL DEFAULT False /**COMMENT* Il conto è un aggregazione di conti? (true -> non è movimentabile) */,
[TipiMovi] SMALLINT NOT NULL DEFAULT 0 /**COMMENT* Tipi di movimenti accettabili (-1 = solo AVERE, 1 = solo DARE, 0 = entrambi) */,
[LivDett] SMALLINT NOT NULL DEFAULT 0 /**COMMENT* Livello dettaglio conto (0 = Contabilità Generale, 1 = Conto d'ordine, 2 = Contabilità Analitica, 3 = Conti d'appoggio) */,
[Note] LONGTEXT /**COMMENT* Annotazioni libere */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConConti] ([CodCon] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Alias] ON [ConConti] ([Alias] ASC);
CREATE INDEX [Desc] ON [ConConti] ([Desc] ASC);

DROP TABLE [ConGiornale] /**WEAK**/;
CREATE TABLE [ConGiornale] (
[CodScr] COUNTER NOT NULL /**COMMENT* Codice Scrittura (Interno ed immodificabile) */,
[DataScr] DATETIME NOT NULL /**COMMENT* Data scrittura */,
[DataOpe] DATETIME NOT NULL DEFAULT =Date() /**COMMENT* Data operazione */,
[Desc] TEXT(40) NOT NULL /**COMMENT* Descrizione scrittura */,
[TipoScr] SMALLINT DEFAULT 0 /**COMMENT* Tipo scrittura (0 = normale, 1 = da cont. IVA, ...) */,
[Ufficiale] BIT NOT NULL DEFAULT False /**COMMENT* Scrittura immodibicabile */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConGiornale] ([CodScr] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [DataOperazione] ON [ConGiornale] (
[DataOpe] ASC,
[DataScr] ASC
);
CREATE INDEX [DataScrittura] ON [ConGiornale] (
[DataScr] ASC,
[DataOpe] ASC
);

DROP TABLE [ConGiornaleDett] /**WEAK**/;
CREATE TABLE [ConGiornaleDett] (
[CodScr] INTEGER NOT NULL /**COMMENT* Codice Scrittura a cui il movimento appartiene */,
[CodCon] INTEGER NOT NULL /**COMMENT* Codice Conto movimentato */,
[Importo] MONEY NOT NULL DEFAULT 0 /**COMMENT* Importo movimento (>0 DARE, <0 AVERE) */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConGiornaleDett] (
[CodScr] ASC,
[CodCon] ASC
) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [CodCon] ON [ConGiornaleDett] (
[CodCon] ASC,
[CodScr] ASC
);

DROP TABLE [ConSchemiBilancio] /**WEAK**/;
CREATE TABLE [ConSchemiBilancio] (
[CodSch] COUNTER NOT NULL /**COMMENT* Codice Schema di Bilancio (Interno ed immodificabile) */,
[Alias] TEXT(12) NOT NULL /**COMMENT* Abbreviazione - nome schema */,
[Desc] TEXT(30) NOT NULL /**COMMENT* Descrizione estesa dello schema */,
[Note] LONGTEXT /**COMMENT* Annotazioni libere */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConSchemiBilancio] ([CodSch] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Desc] ON [ConSchemiBilancio] ([Desc] ASC);
CREATE INDEX [Name] ON [ConSchemiBilancio] ([Alias] ASC);

DROP TABLE [ConSchemiBilancioDett] /**WEAK**/;
CREATE TABLE [ConSchemiBilancioDett] (
[CodSch] INTEGER NOT NULL /**COMMENT* Codice Schema di Bilancio */,
[CodCon] INTEGER NOT NULL /**COMMENT* Codice Conto */,
[Parent] INTEGER /**COMMENT* Codice Conto a cui aggregarsi, null se a nessuno */,
[Order] INTEGER DEFAULT 0 /**COMMENT* Valore per ordinamento */,
[Posizione] SMALLINT DEFAULT 0 /**COMMENT* Posizione preferita (1 = DARE, -1 = AVERE, 0 = in base al saldo) */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [ConSchemiBilancioDett] (
[CodSch] ASC,
[CodCon] ASC
) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Order] ON [ConSchemiBilancioDett] ([Order] ASC);
CREATE INDEX [Parent] ON [ConSchemiBilancioDett] (
[Parent] ASC,
[Order] ASC
);

DROP TABLE [IVA2Con_Trasf] /**WEAK**/;
CREATE TABLE [IVA2Con_Trasf] (
[CodOpe] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Codice Operazione */,
[CodScr] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Codice Scrittura */,
[DataTra] DATETIME NOT NULL DEFAULT =Date() /**COMMENT* Data Trasferimento in contabilità */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVA2Con_Trasf] (
[CodOpe] ASC,
[CodScr] ASC
) WITH PRIMARY DISALLOW NULL;

DROP TABLE [IVAAliquote] /**WEAK**/;
CREATE TABLE [IVAAliquote] (
[CodIVA] COUNTER NOT NULL /**COMMENT* Codice IVA (Interno ed immodificabile) */,
[Alias] TEXT(12) /**COMMENT* Abbreviazione - nome aliquota */,
[Desc] TEXT(30) /**COMMENT* Descrizione aliquota */,
[Aliquota] REAL DEFAULT 0 /**COMMENT* Importo aliquota % */,
[TipoAliq] SMALLINT DEFAULT 0 /**COMMENT* Tipo di aliquota */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVAAliquote] ([CodIVA] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Alias] ON [IVAAliquote] ([Alias] ASC);

DROP TABLE [IVAChiusure] /**WEAK**/;
CREATE TABLE [IVAChiusure] (
[CodChi] COUNTER NOT NULL /**COMMENT* Codice Chiusura (Interno ed immodificabile) */,
[DataChi] DATETIME NOT NULL DEFAULT =Date() /**COMMENT* Data della chiusura */,
[Alias] TEXT(12) NOT NULL /**COMMENT* Alias - nome chiusura */,
[DataPag] DATETIME NOT NULL DEFAULT =Date() /**COMMENT* Data del pagamento */,
[CreditoPrecedente] MONEY NOT NULL DEFAULT 0 /**COMMENT* Credito\/Debito liquidazione precedente */,
[SaldoAttuale] MONEY DEFAULT 0 /**COMMENT* Saldo da liquidare */,
[Versamento] MONEY NOT NULL DEFAULT 0 /**COMMENT* Importo versato */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVAChiusure] ([CodChi] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [IVAChiusureDett] /**WEAK**/;
CREATE TABLE [IVAChiusureDett] (
[CodChi] INTEGER NOT NULL /**COMMENT* Codice Chiusura */,
[CodReg] INTEGER NOT NULL /**COMMENT* Codice Registro IVA */,
[CodIVA] INTEGER NOT NULL /**COMMENT* Codice Aliquota IVA */,
[TotImponibile] MONEY NOT NULL DEFAULT 0 /**COMMENT* Totale imponibile */,
[TotIVA] MONEY NOT NULL DEFAULT 0 /**COMMENT* Totale IVA */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVAChiusureDett] (
[CodChi] ASC,
[CodReg] ASC,
[CodIVA] ASC
) WITH PRIMARY DISALLOW NULL;

DROP TABLE [IVAOperazioni] /**WEAK**/;
CREATE TABLE [IVAOperazioni] (
[CodOpe] COUNTER NOT NULL /**COMMENT* Codice Operazione (Interno ed immodificabile) */,
[CodReg] INTEGER NOT NULL /**COMMENT* Codice Registro IVA dell'operazione */,
[NumLib] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Numero di libro */,
[NumPro] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Numero progressivo registrazione */,
[DataReg] DATETIME NOT NULL DEFAULT =Date() /**COMMENT* Data Registrazione */,
[DataDoc] DATETIME /**COMMENT* Data documento */,
[DescDoc] TEXT(50) /**COMMENT* Descrizione documento */,
[CodConOpe] INTEGER NOT NULL /**COMMENT* Codice conto in cui memorizzare l'importo dell'operazione */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVAOperazioni] ([CodOpe] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Ordinato] ON [IVAOperazioni] (
[CodReg] ASC,
[NumLib] ASC,
[NumPro] ASC
);

DROP TABLE [IVAOperazioniDett] /**WEAK**/;
CREATE TABLE [IVAOperazioniDett] (
[CodOpe] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Codice Operazione */,
[CodIVA] INTEGER NOT NULL /**COMMENT* Codice IVA */,
[Imponibile] MONEY NOT NULL DEFAULT 0 /**COMMENT* Imponibile operazione */,
[IVA] MONEY NOT NULL DEFAULT 0 /**COMMENT* IVA operazione */,
[CodConImp] INTEGER NOT NULL /**COMMENT* Codice conto in cui registrare l'imponibile */,
[CodConIVA] INTEGER NOT NULL /**COMMENT* Codice conto in cui registrare l'importo dell'IVA */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVAOperazioniDett] (
[CodOpe] ASC,
[CodIVA] ASC
) WITH PRIMARY DISALLOW NULL;

DROP TABLE [IVARegistri] /**WEAK**/;
CREATE TABLE [IVARegistri] (
[CodReg] COUNTER NOT NULL /**COMMENT* Codice Registro (Interno ed immodificabile) */,
[Alias] TEXT(12) NOT NULL /**COMMENT* Abbreviazione - nome registro */,
[Desc] TEXT(30) NOT NULL /**COMMENT* Descrizione registro */,
[Segno] SMALLINT NOT NULL DEFAULT 1 /**COMMENT* Segno registro (1, -1) */,
[TipoReg] SMALLINT NOT NULL DEFAULT 0 /**COMMENT* Tipo di registro */,
[DataUltTra] DATETIME DEFAULT =Date() /**COMMENT* Data Ultimo trasferimento in contabilità */,
[CodGrpIVA] INTEGER /**COMMENT* Codice gruppo IVA */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVARegistri] ([CodReg] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Alias] ON [IVARegistri] ([Alias] ASC);

DROP TABLE [IVARegistriGruppi] /**WEAK**/;
CREATE TABLE [IVARegistriGruppi] (
[CodGrpIVA] COUNTER NOT NULL /**COMMENT* Codice Gruppo IVA */,
[Alias] TEXT(30) NOT NULL /**COMMENT* Alias - nome gruppo IVA */,
[Desc] TEXT(30) /**COMMENT* Descrizione estesa gruppo IVA */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [IVARegistriGruppi] ([CodGrpIVA] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [Alias] ON [IVARegistriGruppi] ([Alias] ASC);

DROP TABLE [Sys_Counter] /**WEAK**/;
CREATE TABLE [Sys_Counter] (
[Name] TEXT(32) NOT NULL /**COMMENT* Nome contatore */,
[Value] INTEGER NOT NULL DEFAULT 0 /**COMMENT* Valore contatore */,
[Valid] BIT NOT NULL DEFAULT True /**COMMENT* Valido? */,
[ResetDate] DATETIME DEFAULT =Date() /**COMMENT* Data ultimo azzeramento */,
[ModifyDate] DATETIME DEFAULT =Date() /**COMMENT* Data ultima modifica */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [Sys_Counter] ([Name] ASC) WITH PRIMARY DISALLOW NULL;
CREATE INDEX [ID] ON [Sys_Counter] ([Name] ASC);

DROP TABLE [Sys_Param] /**WEAK**/;
CREATE TABLE [Sys_Param] (
[Name] TEXT(32) NOT NULL /**COMMENT* Nome parametro */,
[Value] TEXT(64) /**COMMENT* Valore parametro */,
[Date] DATETIME DEFAULT =Date() /**COMMENT* Data immissione */,
[Tag] INTEGER /**COMMENT* Dato extra */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [Sys_Param] ([Name] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysCon_LivDett] /**WEAK**/;
CREATE TABLE [SysCon_LivDett] (
[LivDett] SMALLINT DEFAULT 0 /**COMMENT* Contabilità - Livello dettaglio */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione Livello di dettaglio */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysCon_LivDett] ([LivDett] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysCon_Posizione] /**WEAK**/;
CREATE TABLE [SysCon_Posizione] (
[Posizione] SMALLINT DEFAULT 0 /**COMMENT* Contabilità - Posizione in uno schema di bilancio */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione Posizione */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysCon_Posizione] ([Posizione] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysCon_TipiMovi] /**WEAK**/;
CREATE TABLE [SysCon_TipiMovi] (
[TipiMovi] SMALLINT DEFAULT 0 /**COMMENT* Contabilità - Tipi Movimenti */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione Tipo Movimento */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysCon_TipiMovi] ([TipiMovi] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysCon_TipoScr] /**WEAK**/;
CREATE TABLE [SysCon_TipoScr] (
[TipoScr] SMALLINT DEFAULT 0 /**COMMENT* Contabilità - Tipi Scrittura */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione tipo scrittura */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysCon_TipoScr] ([TipoScr] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysIVA_TipoAliq] /**WEAK**/;
CREATE TABLE [SysIVA_TipoAliq] (
[TipoAliq] SMALLINT DEFAULT 0 /**COMMENT* IVA - Tipi di aliquota */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione aliquta */,
[DetraibileAl] REAL NOT NULL DEFAULT 0 /**COMMENT* Percentuale detraibilità */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysIVA_TipoAliq] ([TipoAliq] ASC) WITH PRIMARY DISALLOW NULL;

DROP TABLE [SysIVA_TipoReg] /**WEAK**/;
CREATE TABLE [SysIVA_TipoReg] (
[TipoReg] SMALLINT DEFAULT 0 /**COMMENT* IVA - Tipo Registro IVA */,
[Descrizione] TEXT(30) NOT NULL /**COMMENT* Descrizione Tipo Movimento */,
[ModoInput] SMALLINT NOT NULL DEFAULT 0 /**COMMENT* Modo inserimento (0=Imponibile+Aliq, 1=Totale+Aliq) */
);
CREATE UNIQUE INDEX [PrimaryKey] ON [SysIVA_TipoReg] ([TipoReg] ASC) WITH PRIMARY DISALLOW NULL;

/* Relations */
/* Foreign keys for ConBilanci */
ALTER TABLE [ConBilanci] ADD CONSTRAINT [ConBilanciSchemaConBilanci] FOREIGN KEY (CodSch) REFERENCES [ConSchemiBilancio] (CodSch) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for ConBilanciDett */
ALTER TABLE [ConBilanciDett] ADD CONSTRAINT [ConBilanciConBilanciDett] FOREIGN KEY (CodBil) REFERENCES [ConBilanci] (CodBil) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [ConBilanciDett] ADD CONSTRAINT [ConContiConBilanciDett] FOREIGN KEY (CodCon) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for ConConti */
ALTER TABLE [ConConti] ADD CONSTRAINT [SysCon_LivDettConConti] FOREIGN KEY (LivDett) REFERENCES [SysCon_LivDett] (LivDett) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [ConConti] ADD CONSTRAINT [SysCon_TipiMoviConConti] FOREIGN KEY (TipiMovi) REFERENCES [SysCon_TipiMovi] (TipiMovi) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for ConGiornale */
ALTER TABLE [ConGiornale] ADD CONSTRAINT [SysCon_TipoScrConGiornale] FOREIGN KEY (TipoScr) REFERENCES [SysCon_TipoScr] (TipoScr) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for ConGiornaleDett */
ALTER TABLE [ConGiornaleDett] ADD CONSTRAINT [ConContiConGiornaleDett] FOREIGN KEY (CodCon) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [ConGiornaleDett] ADD CONSTRAINT [ConGiornaleConGiornaleDett] FOREIGN KEY (CodScr) REFERENCES [ConGiornale] (CodScr) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for ConSchemiBilancioDett */
ALTER TABLE [ConSchemiBilancioDett] ADD CONSTRAINT [ConBilanciSchemaConBilanciSchemaDett] FOREIGN KEY (CodSch) REFERENCES [ConSchemiBilancio] (CodSch) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [ConSchemiBilancioDett] ADD CONSTRAINT [ConContiConBilanciSchemaDett] FOREIGN KEY (CodCon) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [ConSchemiBilancioDett] ADD CONSTRAINT [SysCon_PosizioneConSchemiBilancioDett] FOREIGN KEY (Posizione) REFERENCES [SysCon_Posizione] (Posizione) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVA2Con_Trasf */
ALTER TABLE [IVA2Con_Trasf] ADD CONSTRAINT [ConGiornaleIVA2Con_Trasf] FOREIGN KEY (CodScr) REFERENCES [ConGiornale] (CodScr) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVA2Con_Trasf] ADD CONSTRAINT [IVAOperazioniIVA2Con_Trasf] FOREIGN KEY (CodOpe) REFERENCES [IVAOperazioni] (CodOpe) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVAAliquote */
ALTER TABLE [IVAAliquote] ADD CONSTRAINT [SysIVA_TipoAliqIVAAliquote] FOREIGN KEY (TipoAliq) REFERENCES [SysIVA_TipoAliq] (TipoAliq) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVAChiusureDett */
ALTER TABLE [IVAChiusureDett] ADD CONSTRAINT [IVAAliquiteIVAChiusureDett] FOREIGN KEY (CodIVA) REFERENCES [IVAAliquote] (CodIVA) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAChiusureDett] ADD CONSTRAINT [IVAChiusureIVAChiusureDett] FOREIGN KEY (CodChi) REFERENCES [IVAChiusure] (CodChi) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAChiusureDett] ADD CONSTRAINT [IVARegistriIVAChiusureDett] FOREIGN KEY (CodReg) REFERENCES [IVARegistri] (CodReg) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVAOperazioni */
ALTER TABLE [IVAOperazioni] ADD CONSTRAINT [ConContiIVAOperazioni] FOREIGN KEY (CodConOpe) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAOperazioni] ADD CONSTRAINT [IVARegistriIVAOperazioni] FOREIGN KEY (CodReg) REFERENCES [IVARegistri] (CodReg) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVAOperazioniDett */
ALTER TABLE [IVAOperazioniDett] ADD CONSTRAINT [ConContiIVAOperazioniDett] FOREIGN KEY (CodConImp) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAOperazioniDett] ADD CONSTRAINT [ConContiIVAOperazioniDett1] FOREIGN KEY (CodConIVA) REFERENCES [ConConti] (CodCon) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAOperazioniDett] ADD CONSTRAINT [IVAAliquiteIVAOperazioniDett] FOREIGN KEY (CodIVA) REFERENCES [IVAAliquote] (CodIVA) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVAOperazioniDett] ADD CONSTRAINT [IVAOperazioniIVAOperazioniDett] FOREIGN KEY (CodOpe) REFERENCES [IVAOperazioni] (CodOpe) ON UPDATE CASCADE ON DELETE CASCADE;

/* Foreign keys for IVARegistri */
ALTER TABLE [IVARegistri] ADD CONSTRAINT [IVARegistriGruppiIVARegistri] FOREIGN KEY (CodGrpIVA) REFERENCES [IVARegistriGruppi] (CodGrpIVA) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE [IVARegistri] ADD CONSTRAINT [SysIVA_TipoRegIVARegistri] FOREIGN KEY (TipoReg) REFERENCES [SysIVA_TipoReg] (TipoReg) ON UPDATE CASCADE ON DELETE CASCADE;

/* Views */
/* Procedures */
/* Table data */
/* Data for table AdmUtenti */

/* Data for table ConBilanci */

/* Data for table ConBilanciDett */

/* Data for table ConConti */

/* Data for table ConGiornale */

/* Data for table ConGiornaleDett */

/* Data for table ConSchemiBilancio */

/* Data for table ConSchemiBilancioDett */

/* Data for table IVA2Con_Trasf */

/* Data for table IVAAliquote */

/* Data for table IVAChiusure */

/* Data for table IVAChiusureDett */

/* Data for table IVAOperazioni */

/* Data for table IVAOperazioniDett */

/* Data for table IVARegistri */

/* Data for table IVARegistriGruppi */

/* Data for table Sys_Counter */

/* Data for table Sys_Param */

/* Data for table SysCon_LivDett */
INSERT INTO [SysCon_LivDett] ([LivDett],[Descrizione]) VALUES (0,'Contabilità generale');
INSERT INTO [SysCon_LivDett] ([LivDett],[Descrizione]) VALUES (1,'Conto d''ordine');
INSERT INTO [SysCon_LivDett] ([LivDett],[Descrizione]) VALUES (2,'Contabilità analitica');
INSERT INTO [SysCon_LivDett] ([LivDett],[Descrizione]) VALUES (3,'Conto d''appoggio');

/* Data for table SysCon_Posizione */
INSERT INTO [SysCon_Posizione] ([Posizione],[Descrizione]) VALUES (-1,'Avere');
INSERT INTO [SysCon_Posizione] ([Posizione],[Descrizione]) VALUES (0,'In base a saldo');
INSERT INTO [SysCon_Posizione] ([Posizione],[Descrizione]) VALUES (1,'Dare');

/* Data for table SysCon_TipiMovi */
INSERT INTO [SysCon_TipiMovi] ([TipiMovi],[Descrizione]) VALUES (-1,'Avere');
INSERT INTO [SysCon_TipiMovi] ([TipiMovi],[Descrizione]) VALUES (0,'Dare/Avere');
INSERT INTO [SysCon_TipiMovi] ([TipiMovi],[Descrizione]) VALUES (1,'Dare');

/* Data for table SysCon_TipoScr */
INSERT INTO [SysCon_TipoScr] ([TipoScr],[Descrizione]) VALUES (0,'Cont. generale');
INSERT INTO [SysCon_TipoScr] ([TipoScr],[Descrizione]) VALUES (1,'Cont. IVA');

/* Data for table SysIVA_TipoAliq */
INSERT INTO [SysIVA_TipoAliq] ([TipoAliq],[Descrizione],[DetraibileAl]) VALUES (0,'Detraibile',1);
INSERT INTO [SysIVA_TipoAliq] ([TipoAliq],[Descrizione],[DetraibileAl]) VALUES (1,'Non detraibile',0);

/* Data for table SysIVA_TipoReg */
INSERT INTO [SysIVA_TipoReg] ([TipoReg],[Descrizione],[ModoInput]) VALUES (0,'Imponibile+Aliquota',0);
INSERT INTO [SysIVA_TipoReg] ([TipoReg],[Descrizione],[ModoInput]) VALUES (1,'Totale+Aliquota',1);

/* Access SQL export data end. */
