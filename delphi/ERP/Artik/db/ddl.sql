/* Access SQL export data follows. Auto-generated. */

/* Tables */
DROP TABLE [ARTICOLI] /**WEAK**/;
CREATE TABLE [ARTICOLI] (
[CodAlf] TEXT(3),
[CodNum] INTEGER,
[Desc] TEXT(30),
[Attv] BIT NOT NULL,
[CodIVA] INTEGER,
[CodMis] INTEGER,
[Qta] FLOAT,
[QtaInv] FLOAT,
[QtaDelta] FLOAT,
[QtaAcq] FLOAT,
[QtaOrd] FLOAT,
[QtaVen] FLOAT,
[QtaPre] FLOAT,
[QtaSco] FLOAT,
[PrzLis] MONEY,
[PrzNor] MONEY,
[PrzSpe] MONEY,
[RicNor] INTEGER,
[RicSpe] INTEGER,
[PrePriAcq] MONEY,
[PreUltAcq] MONEY,
[DatPriAcq] DATETIME,
[DatUltAcq] DATETIME,
[CumuloAcq] FLOAT,
[CumuloOrd] FLOAT
);

DROP TABLE [FATFORLS] /**WEAK**/;
CREATE TABLE [FATFORLS] (
[CodFatFor] INTEGER,
[CodFor] INTEGER,
[NumFatt] TEXT(15),
[DataFatt] DATETIME,
[TotaleImp] MONEY,
[TotaleIVA] MONEY,
[Preventivo] BIT NOT NULL
);

DROP TABLE [FATFORMV] /**WEAK**/;
CREATE TABLE [FATFORMV] (
[CodMov] INTEGER,
[CodFatFor] INTEGER,
[CodAlf] TEXT(3),
[CodNum] INTEGER,
[Qta] FLOAT,
[Imp] MONEY,
[Elab] BIT NOT NULL
);

DROP TABLE [FATFORSP] /**WEAK**/;
CREATE TABLE [FATFORSP] (
[CodSpe] INTEGER,
[CodFatFor] INTEGER,
[Imp] MONEY,
[IVA] MONEY
);

DROP TABLE [FORNISCE] /**WEAK**/;
CREATE TABLE [FORNISCE] (
[CodAlf] TEXT(3),
[CodNum] INTEGER,
[CodFor] INTEGER
);

DROP TABLE [FORNIT] /**WEAK**/;
CREATE TABLE [FORNIT] (
[CodFor] INTEGER,
[Nome] TEXT(30),
[Potenziale] BIT NOT NULL
);

DROP TABLE [SETTORI] /**WEAK**/;
CREATE TABLE [SETTORI] (
[CodAlf] TEXT(3),
[SetMer] TEXT(13),
[PreDes] TEXT(10),
[RicMin] FLOAT,
[RicMax] FLOAT
);

DROP TABLE [TBCODIVA] /**WEAK**/;
CREATE TABLE [TBCODIVA] (
[CodIVA] INTEGER,
[Alq] FLOAT,
[Desc] TEXT(40)
);

DROP TABLE [TBCODMIS] /**WEAK**/;
CREATE TABLE [TBCODMIS] (
[CodMis] INTEGER,
[Desc] TEXT(10)
);

/* Relations */
/* Views */
/* Procedures */
/* Table data */
/* Data for table ARTICOLI */
INSERT INTO [ARTICOLI] ([CodAlf],[CodNum],[Desc],[Attv],[CodIVA],[CodMis],[Qta],[QtaInv],[QtaDelta],[QtaAcq],[QtaOrd],[QtaVen],[QtaPre],[QtaSco],[PrzLis],[PrzNor],[PrzSpe],[RicNor],[RicSpe],[PrePriAcq],[PreUltAcq],[DatPriAcq],[DatUltAcq],[CumuloAcq],[CumuloOrd]) VALUES ('ACA',1,'Prova4',True,100,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,0,0);
INSERT INTO [ARTICOLI] ([CodAlf],[CodNum],[Desc],[Attv],[CodIVA],[CodMis],[Qta],[QtaInv],[QtaDelta],[QtaAcq],[QtaOrd],[QtaVen],[QtaPre],[QtaSco],[PrzLis],[PrzNor],[PrzSpe],[RicNor],[RicSpe],[PrePriAcq],[PreUltAcq],[DatPriAcq],[DatUltAcq],[CumuloAcq],[CumuloOrd]) VALUES ('BBA',1,'Prova',True,210,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,0,0);
INSERT INTO [ARTICOLI] ([CodAlf],[CodNum],[Desc],[Attv],[CodIVA],[CodMis],[Qta],[QtaInv],[QtaDelta],[QtaAcq],[QtaOrd],[QtaVen],[QtaPre],[QtaSco],[PrzLis],[PrzNor],[PrzSpe],[RicNor],[RicSpe],[PrePriAcq],[PreUltAcq],[DatPriAcq],[DatUltAcq],[CumuloAcq],[CumuloOrd]) VALUES ('BBA',2,'Prova3',True,100,30,0,0,0,0,0,0,0,0,1200,1000,900,0,0,0,0,NULL,NULL,0,0);
INSERT INTO [ARTICOLI] ([CodAlf],[CodNum],[Desc],[Attv],[CodIVA],[CodMis],[Qta],[QtaInv],[QtaDelta],[QtaAcq],[QtaOrd],[QtaVen],[QtaPre],[QtaSco],[PrzLis],[PrzNor],[PrzSpe],[RicNor],[RicSpe],[PrePriAcq],[PreUltAcq],[DatPriAcq],[DatUltAcq],[CumuloAcq],[CumuloOrd]) VALUES ('BBB',1,'Prova2',True,220,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,0,0);

/* Data for table FATFORLS */
INSERT INTO [FATFORLS] ([CodFatFor],[CodFor],[NumFatt],[DataFatt],[TotaleImp],[TotaleIVA],[Preventivo]) VALUES (1,2,NULL,#08-01-1998#,6000,520,True);
INSERT INTO [FATFORLS] ([CodFatFor],[CodFor],[NumFatt],[DataFatt],[TotaleImp],[TotaleIVA],[Preventivo]) VALUES (2,1,NULL,#08-03-1998#,10000,2000,False);

/* Data for table FATFORMV */
INSERT INTO [FATFORMV] ([CodMov],[CodFatFor],[CodAlf],[CodNum],[Qta],[Imp],[Elab]) VALUES (2,1,'BBA',1,10,1000,True);
INSERT INTO [FATFORMV] ([CodMov],[CodFatFor],[CodAlf],[CodNum],[Qta],[Imp],[Elab]) VALUES (3,1,'BBA',1,20,2000,False);
INSERT INTO [FATFORMV] ([CodMov],[CodFatFor],[CodAlf],[CodNum],[Qta],[Imp],[Elab]) VALUES (4,2,'BBB',1,5,8000,False);

/* Data for table FATFORSP */
INSERT INTO [FATFORSP] ([CodSpe],[CodFatFor],[Imp],[IVA]) VALUES (3,1,1000,100);
INSERT INTO [FATFORSP] ([CodSpe],[CodFatFor],[Imp],[IVA]) VALUES (4,1,3000,200);
INSERT INTO [FATFORSP] ([CodSpe],[CodFatFor],[Imp],[IVA]) VALUES (5,1,1000,200);
INSERT INTO [FATFORSP] ([CodSpe],[CodFatFor],[Imp],[IVA]) VALUES (6,2,2000,400);

/* Data for table FORNISCE */

/* Data for table FORNIT */
INSERT INTO [FORNIT] ([CodFor],[Nome],[Potenziale]) VALUES (1,'Fornitore 1',False);
INSERT INTO [FORNIT] ([CodFor],[Nome],[Potenziale]) VALUES (2,'Fornitore 2',False);
INSERT INTO [FORNIT] ([CodFor],[Nome],[Potenziale]) VALUES (3,'Fornitore 3',True);

/* Data for table SETTORI */
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('A','Ferramenta','Pippo',10,20);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('AC','Accessori','Pippo',10,20);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('ACA','Trapano','Pippo',10,20);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('B','Merceria','B',5,25);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('BB','Bottoni','B',5,25);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('BBA','Automatici','BBA',0,0);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('BBB','Normali','BB',0,0);
INSERT INTO [SETTORI] ([CodAlf],[SetMer],[PreDes],[RicMin],[RicMax]) VALUES ('BBZ','Settore BBZ','B',5,25);

/* Data for table TBCODIVA */
INSERT INTO [TBCODIVA] ([CodIVA],[Alq],[Desc]) VALUES (100,0,'Esente');
INSERT INTO [TBCODIVA] ([CodIVA],[Alq],[Desc]) VALUES (110,0,'Indetraibile');
INSERT INTO [TBCODIVA] ([CodIVA],[Alq],[Desc]) VALUES (210,10,NULL);
INSERT INTO [TBCODIVA] ([CodIVA],[Alq],[Desc]) VALUES (220,20,NULL);

/* Data for table TBCODMIS */
INSERT INTO [TBCODMIS] ([CodMis],[Desc]) VALUES (10,'Pz.');
INSERT INTO [TBCODMIS] ([CodMis],[Desc]) VALUES (20,'m');
INSERT INTO [TBCODMIS] ([CodMis],[Desc]) VALUES (30,'Kg');

/* Access SQL export data end. */
