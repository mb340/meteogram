const CITIES = [
	"SE	Aleksandrovac	43.45861	21.0525	352	306",
	"SE	Aleksinac	43.54167	21.70778	169	306",
	"SE	Aranđelovac	44.30694	20.56	251	306",
	"SE	Arilje	43.75306	20.09556	334	306",
	"SE	Bace	43.21963	21.34463	315	306",
	"SE	Badovinci	44.78534	19.37146	90	306",
	"SE	Bajina Bašta	43.97083	19.5675	242	306",
	"SE	Banovo Polje	44.9104	19.44916	81	306",
	"SE	Barajevo	44.57889	20.41583	142	306",
	"SE	Barič	44.6507	20.25941	82	306",
	"SE	Batočina	44.15361	21.08167	109	306",
	"SE	Bečmen	44.77983	20.20577	76	306",
	"SE	Bela Palanka	43.21833	22.31111	292	306",
	"SE	Belgrade	44.80401	20.46513	120	306",
	"SE	Beloljin	43.23846	21.39673	297	306",
	"SE	Belotić	44.58099	19.71932	164	306",
	"SE	Belotić	44.81782	19.54801	83	306",
	"SE	Biljača	42.35518	21.74781	461	306",
	"SE	Blace	43.29528	21.28583	396	306",
	"SE	Bogatić	44.8375	19.48056	84	306",
	"SE	Bogosavac	44.71799	19.59533	86	306",
	"SE	Bojnik	43.01224	21.721	259	306",
	"SE	Boljevac	43.83028	21.95306	279	306",
	"SE	Boljevci	44.72355	20.22348	75	306",
	"SE	Bor	44.07488	22.09591	405	306",
	"SE	Bosilegrad	42.5011	22.47238	739	306",
	"SE	Brdarica	44.55376	19.7715	179	306",
	"SE	Brezovica	42.95229	22.17869	648	306",
	"SE	Brezovica	43.74669	20.41436	648	306",
	"SE	Bujanovac	42.45917	21.76667	401	306",
	"SE	Bukor	44.49523	19.57116	252	306",
	"SE	Buštranje	42.33152	21.75407	479	306",
	"SE	Čačak	43.89139	20.34972	241	306",
	"SE	Čajetina	43.74977	19.71273	857	306",
	"SE	Ćićevac	43.71882	21.44085	144	306",
	"SE	Čokešina	44.65319	19.39016	148	306",
	"SE	Crna Bara	44.87374	19.3948	83	306",
	"SE	Crna Trava	42.80988	22.29881	966	306",
	"SE	Čukarica	44.7825	20.42028	116	306",
	"SE	Culjković	44.66595	19.54562	150	306",
	"SE	Ćuprija	43.9275	21.37	124	306",
	"SE	Despotovac	44.0925	21.44694	199	306",
	"SE	Dimitrovgrad	43.01417	22.77556	461	306",
	"SE	Dobanovci	44.82631	20.22487	78	306",
	"SE	Dobrić	44.70224	19.57931	91	306",
	"SE	Dolac naselje	43.29511	22.20626	272	306",
	"SE	Doljevac	43.19817	21.83258	199	306",
	"SE	Donja Badanja	44.50556	19.47543	255	306",
	"SE	Donja Gorevnica	43.87701	20.50004	249	306",
	"SE	Donja Konjuša	43.22293	21.41421	284	306",
	"SE	Donji Dobrić	44.61183	19.33109	140	306",
	"SE	Donji Milanovac	44.46593	22.1517	73	306",
	"SE	Draginje	44.53302	19.7625	234	306",
	"SE	Drenovac	44.86649	19.70943	76	306",
	"SE	Dublje	44.80117	19.50902	84	306",
	"SE	Duboka	44.52223	21.7603	229	306",
	"SE	Ðurići	43.84678	19.40935	807	306",
	"SE	Gadžin Han	43.22278	22.03194	271	306",
	"SE	Glogovac	44.04213	21.3134	118	306",
	"SE	Glogovac	44.86341	19.41532	83	306",
	"SE	Glušci	44.89021	19.54913	80	306",
	"SE	Golubac	44.65296	21.63199	73	306",
	"SE	Gornja Bukovica	44.34233	19.78647	337	306",
	"SE	Gornje Nedeljice	44.51645	19.33915	180	306",
	"SE	Gornji Dobrić	44.58286	19.30858	141	306",
	"SE	Gornji Milanovac	44.02603	20.46152	326	306",
	"SE	Grabovac	44.60049	20.08539	112	306",
	"SE	Grnčara	44.53516	19.29971	178	306",
	"SE	Grocka	44.67152	20.71648	76	306",
	"SE	Ivanjica	43.58028	20.23111	466	306",
	"SE	Jadranska Lešnica	44.58625	19.34701	128	306",
	"SE	Jagodina	43.97713	21.26121	120	306",
	"SE	Jarebice	44.53995	19.42418	179	306",
	"SE	Jelenča	44.727	19.735	83	306",
	"SE	Jevremovac	44.72172	19.66364	100	306",
	"SE	Joševa	44.58772	19.40967	155	306",
	"SE	Kamenica	44.343	19.72333	346	306",
	"SE	Kladovo	44.61147	22.60955	44	306",
	"SE	Klenje	44.80794	19.43508	86	306",
	"SE	Knić	43.92694	20.71889	320	306",
	"SE	Knjazevac	43.56634	22.25701	232	306",
	"SE	Koceljeva	44.47361	19.81167	129	306",
	"SE	Kosjerić	43.99611	19.90694	423	306",
	"SE	Kozjak	44.58727	19.28412	112	306",
	"SE	Kragujevac	44.01667	20.91667	182	306",
	"SE	Kraljevo	43.72583	20.68944	207	306",
	"SE	Kriva Feja	42.55909	22.17487	1267	306",
	"SE	Krivaja	44.55021	19.59153	207	306",
	"SE	Krupanj	44.36556	19.36194	282	306",
	"SE	Kruševac	43.58	21.33389	162	306",
	"SE	Kučevo	44.4775	21.67	163	306",
	"SE	Kuršumlija	43.13826	21.27339	367	306",
	"SE	Lagja e Korbajve	42.38674	21.7434	470	306",
	"SE	Lagja e Poshtme	42.38853	21.72971	449	306",
	"SE	Lagja e Shimshirve	42.38025	21.74045	461	306",
	"SE	Lagja e Ternovcalive	42.38999	21.74365	472	306",
	"SE	Lajkovac	44.36944	20.16528	111	306",
	"SE	Lapovo	44.18424	21.09727	110	306",
	"SE	Lazarevac	44.38534	20.2557	117	306",
	"SE	Lebane	42.92389	21.7375	290	306",
	"SE	Leskovac	42.99806	21.94611	230	306",
	"SE	Lešnica	44.6525	19.31	108	306",
	"SE	Lipnički Šor	44.58058	19.26572	113	306",
	"SE	Lipolist	44.69783	19.50101	91	306",
	"SE	Ljig	44.23007	20.23819	154	306",
	"SE	Ljubovija	44.18944	19.37667	178	306",
	"SE	Lučani	43.86083	20.13806	310	306",
	"SE	Lugavčina	44.52314	21.07083	82	306",
	"SE	Majdanpek	44.42771	21.94596	504	306",
	"SE	Majur	44.77105	19.65512	78	306",
	"SE	Mala Moštanica	44.63834	20.306	113	306",
	"SE	Mali Zvornik	44.37344	19.10651	166	306",
	"SE	Malo Crniće	44.55611	21.28556	85	306",
	"SE	Medveđa	42.84306	21.58333	367	306",
	"SE	Merošina	43.28358	21.7204	244	306",
	"SE	Metković	44.85617	19.54654	79	306",
	"SE	Mionica	44.25194	20.08167	179	306",
	"SE	Miratovac	42.25846	21.66456	481	306",
	"SE	Mladenovac	44.43861	20.69917	169	306",
	"SE	Mokra Gora	43.78853	19.50033	544	306",
	"SE	Mrovska	44.54278	19.675	201	306",
	"SE	Nakučani	44.6014	19.66718	119	306",
	"SE	Negotin	44.22639	22.53083	49	306",
	"SE	Niš	43.32472	21.90333	194	306",
	"SE	Niška Banja	43.29507	22.0057	234	306",
	"SE	Nova Varoš	43.46056	19.81139	987	306",
	"SE	Novi Beograd	44.80556	20.42417	71	306",
	"SE	Novi Pazar	43.13667	20.51222	511	306",
	"SE	Novo Selo	44.67041	19.34495	101	306",
	"SE	Obrenovac	44.65486	20.20017	78	306",
	"SE	Osečina	44.37306	19.60139	202	306",
	"SE	Osječenik	43.14528	19.85889	1421	306",
	"SE	Ostružnica	44.72769	20.31845	77	306",
	"SE	Ovča	44.88349	20.53336	71	306",
	"SE	Palilula	44.81167	20.51611	120	306",
	"SE	Paraćin	43.86083	21.40778	130	306",
	"SE	Petkovica	44.66627	19.43923	129	306",
	"SE	Petrovac	44.37694	21.41917	126	306",
	"SE	Pirot	43.15306	22.58611	371	306",
	"SE	Pocerski Pričinović	44.72222	19.70722	91	306",
	"SE	Požarevac	44.62133	21.18782	80	306",
	"SE	Požega	43.84889	20.03632	321	306",
	"SE	Preševo	42.30917	21.64917	510	306",
	"SE	Priboj	43.58306	19.52519	398	306",
	"SE	Prijepolje	43.38996	19.6487	452	306",
	"SE	Prislonica	43.95223	20.43521	377	306",
	"SE	Prnjavor	44.70061	19.38695	95	306",
	"SE	Prokuplje	43.23417	21.58806	259	306",
	"SE	Rača	44.22712	20.97754	138	306",
	"SE	Radenka	44.58345	21.76469	364	306",
	"SE	Radovnica	42.43364	22.22861	1282	306",
	"SE	Rajince	42.3787	21.69591	447	306",
	"SE	Rakovica	44.74194	20.44139	98	306",
	"SE	Raška	43.28722	20.61528	414	306",
	"SE	Ražanj	43.67222	21.54944	262	306",
	"SE	Rekovac	43.863	21.09345	241	306",
	"SE	Ribari	44.70961	19.42472	93	306",
	"SE	Ripanj	44.63864	20.52136	239	306",
	"SE	Rumska	44.57261	19.58988	168	306",
	"SE	Rušanj	44.68477	20.44993	201	306",
	"SE	Šabac	44.74667	19.69	79	306",
	"SE	Salaš Crnobarski	44.82843	19.39437	86	306",
	"SE	Samoljica	42.38445	21.73708	443	306",
	"SE	Savski Venac	44.77917	20.45389	148	306",
	"SE	Ševarice	44.86704	19.66006	78	306",
	"SE	Ševica	44.50883	21.72296	209	306",
	"SE	Sinošević	44.61503	19.63601	174	306",
	"SE	Sjenica	43.27306	19.99944	1011	306",
	"SE	Smederevo	44.66436	20.92763	80	306",
	"SE	Smederevska Palanka	44.36548	20.95885	122	306",
	"SE	Soko Banja	43.64333	21.87111	310	306",
	"SE	Sokolovica	43.21528	20.31556	1000	306",
	"SE	Sokolovo Brdo	43.13694	19.80556	1252	306",
	"SE	Sopot	44.51972	20.57361	188	306",
	"SE	Spančevac	42.36263	21.85619	587	306",
	"SE	Sremčica	44.67653	20.39232	225	306",
	"SE	Stari Grad	44.81789	20.46186	118	306",
	"SE	Stepojevac	44.51278	20.295	132	306",
	"SE	Štitar	44.79415	19.59529	79	306",
	"SE	Stubline	44.57476	20.13477	108	306",
	"SE	Sumulicë	42.38682	21.734	440	306",
	"SE	Surčin	44.79306	20.28028	87	306",
	"SE	Surdulica	42.69056	22.17083	483	306",
	"SE	Suvi Do	43.25829	21.33269	378	306",
	"SE	Svilajnac	44.2337	21.1967	104	306",
	"SE	Svrljig	43.41333	22.12111	376	306",
	"SE	Tabanović	44.82018	19.64128	78	306",
	"SE	Tekeriš	44.55726	19.5297	294	306",
	"SE	Topola	44.25417	20.6825	276	306",
	"SE	Trgovište	42.36417	22.0825	623	306",
	"SE	Tršić	44.49502	19.2649	230	306",
	"SE	Trstenik	43.61694	21.0025	170	306",
	"SE	Tulare	43.228	21.37961	321	306",
	"SE	Turija	44.52273	21.63945	137	306",
	"SE	Tutin	42.99028	20.33139	869	306",
	"SE	Ub	44.45611	20.07389	98	306",
	"SE	Ugrinovci	44.87635	20.18763	75	306",
	"SE	Umka	44.67806	20.30472	82	306",
	"SE	Užice	43.85861	19.84878	438	306",
	"SE	Uzveće	44.87861	19.60356	79	306",
	"SE	Valjevo	44.27513	19.89821	180	306",
	"SE	Varna	44.67914	19.6515	113	306",
	"SE	Varvarin	43.72397	21.3624	142	306",
	"SE	Velika Moštanica	44.66486	20.35395	200	306",
	"SE	Velika Plana	44.33389	21.07676	114	306",
	"SE	Veliko Gradište	44.76329	21.51646	75	306",
	"SE	Vladičin Han	42.70778	22.06333	331	306",
	"SE	Vladimirci	44.61472	19.78528	108	306",
	"SE	Vlasotince	42.96697	22.13402	262	306",
	"SE	Voždovac	44.77833	20.47583	146	306",
	"SE	Vračar	44.79256	20.47491	110	306",
	"SE	Vranić	44.60237	20.32872	209	306",
	"SE	Vranje	42.55139	21.90028	468	306",
	"SE	Vranjska Banja	42.555	21.99222	395	306",
	"SE	Vrnjačka Banja	43.62725	20.89634	211	306",
	"SE	Žabari	44.35611	21.215	105	306",
	"SE	Žagubica	44.19685	21.78838	316	306",
	"SE	Zaječar	43.90358	22.26405	130	306",
	"SE	Zemun	44.8458	20.40116	100	306",
	"SE	Žitni Potok	43.09021	21.57476	513	306",
	"SE	Žitorađa	43.19	21.71306	216	306",
	"SE	Zlatibor	43.729	19.70029	980	306",
	"SE	Zminjak	44.75711	19.4707	87	306",
	"SE	Žujince	42.31568	21.70212	444	306",
	"SE	Zvečka	44.64025	20.16432	76	306",
	"SE	Zvezdara	44.77465	20.53207	221	306",
	"VO	Ada	45.8025	20.12583	79	306",
	"VO	Adorjan	46.00333	20.04007	80	306",
	"VO	Aleksandrovo	45.63755	20.59288	76	306",
	"VO	Alibunar	45.08083	20.96583	84	306",
	"VO	Apatin	45.6726	18.978	85	306",
	"VO	Aradac	45.38346	20.30137	76	306",
	"VO	Bač	45.39194	19.23667	81	306",
	"VO	Bačka Palanka	45.24966	19.39664	81	306",
	"VO	Bačka Topola	45.81516	19.6318	94	306",
	"VO	Bački Breg	45.92034	18.92944	88	306",
	"VO	Bački Petrovac	45.36056	19.59167	83	306",
	"VO	Bačko Gradište	45.53271	20.03082	78	306",
	"VO	Bačko Petrovo Selo	45.70681	20.07928	79	306",
	"VO	Banatska Dubica	45.27146	20.82833	75	306",
	"VO	Banatska Topola	45.67248	20.4653	76	306",
	"VO	Banatski Despotovac	45.36606	20.66407	75	306",
	"VO	Banatski Dvor	45.51866	20.51146	76	306",
	"VO	Banatski Karlovac	45.04987	21.018	97	306",
	"VO	Banatsko Karađorđevo	45.58693	20.56421	74	306",
	"VO	Banatsko Veliko Selo	45.81961	20.60772	77	306",
	"VO	Baranda	45.08459	20.44264	75	306",
	"VO	Barice	45.18189	21.08279	77	306",
	"VO	Bašaid	45.64102	20.41434	79	306",
	"VO	Bečej	45.61632	20.03331	77	306",
	"VO	Bela Crkva	44.8975	21.41722	82	306",
	"VO	Belegiš	45.0192	20.33323	97	306",
	"VO	Belo Blato	45.27278	20.375	71	306",
	"VO	Beočin	45.20829	19.72063	87	306",
	"VO	Beška	45.13092	20.06698	120	306",
	"VO	Bočar	45.76994	20.2839	77	306",
	"VO	Bogojevo	45.53015	19.13022	84	306",
	"VO	Boka	45.3554	20.82987	75	306",
	"VO	Bosut	44.92977	19.36086	79	306",
	"VO	Botoš	45.30837	20.63514	80	306",
	"VO	Buđanovci	44.89388	19.86344	78	306",
	"VO	Čelarevo	45.26999	19.52484	79	306",
	"VO	Čenta	45.10814	20.38947	73	306",
	"VO	Čestereg	45.56361	20.53194	77	306",
	"VO	Čoka	45.9425	20.14333	79	306",
	"VO	Čortanovci	45.1546	20.01851	156	306",
	"VO	Crepaja	45.00984	20.63702	78	306",
	"VO	Crna Bara	45.97326	20.27614	76	306",
	"VO	Čurug	45.47221	20.06861	79	306",
	"VO	Debeljača	45.0707	20.60153	78	306",
	"VO	Despotovo	45.45983	19.52653	82	306",
	"VO	Dobrica	45.21339	20.84995	80	306",
	"VO	Doroslovo	45.60699	19.18868	85	306",
	"VO	Ðurđevo	45.32591	20.06532	80	306",
	"VO	Ečka	45.32328	20.44294	77	306",
	"VO	Elemir	45.44263	20.30003	81	306",
	"VO	Farkaždin	45.19172	20.47239	75	306",
	"VO	Gakovo	45.90078	19.06138	88	306",
	"VO	Gardinovci	45.20359	20.13558	77	306",
	"VO	Gložan	45.27954	19.56838	79	306",
	"VO	Golubinci	44.98533	20.06339	88	306",
	"VO	Gornji Breg	45.91995	20.01766	94	306",
	"VO	Grabovci	44.76496	19.84489	78	306",
	"VO	Gudurica	45.16816	21.44264	115	306",
	"VO	Hajdučica	45.2501	20.96016	74	306",
	"VO	Hetin	45.66202	20.79138	75	306",
	"VO	Hrtkovci	44.88155	19.76374	79	306",
	"VO	Iđoš	45.82648	20.31791	77	306",
	"VO	Idvor	45.18895	20.51442	76	306",
	"VO	Ilandža	45.16897	20.92008	84	306",
	"VO	Inđija	45.04816	20.08165	114	306",
	"VO	Irig	45.0523	19.84448	139	306",
	"VO	Irig	45.10111	19.85833	185	306",
	"VO	Izbište	45.02253	21.18388	95	306",
	"VO	Jablanka	45.07524	21.39067	123	306",
	"VO	Jankov Most	45.47498	20.43835	77	306",
	"VO	Janošik	45.17141	21.00658	75	306",
	"VO	Jarak	44.91843	19.75477	80	306",
	"VO	Jarkovac	45.26985	20.76078	76	306",
	"VO	Jaša Tomić	45.44725	20.85546	75	306",
	"VO	Jazovo	45.89876	20.2213	76	306",
	"VO	Jermenovci	45.18635	21.0455	78	306",
	"VO	Kanjiža	46.06667	20.05	79	306",
	"VO	Kikinda	45.82972	20.46528	84	306",
	"VO	Kisač	45.35421	19.72975	81	306",
	"VO	Klek	45.42254	20.48049	77	306",
	"VO	Klenak	44.78846	19.71004	77	306",
	"VO	Knićanin	45.18675	20.319	72	306",
	"VO	Kolut	45.89292	18.9276	87	306",
	"VO	Konak	45.31575	20.91468	74	306",
	"VO	Kovačica	45.11167	20.62139	78	306",
	"VO	Kovilj	45.23422	20.02327	78	306",
	"VO	Kovin	44.7475	20.97611	78	306",
	"VO	Kozjak	45.18264	20.86381	87	306",
	"VO	Krajišnik	45.45283	20.72976	79	306",
	"VO	Krčedin	45.13871	20.13308	108	306",
	"VO	Kula	45.60889	19.52639	80	306",
	"VO	Kulpin	45.4024	19.58814	81	306",
	"VO	Kumane	45.53946	20.22902	77	306",
	"VO	Kupinik	45.29254	21.13702	77	306",
	"VO	Kupinovo	44.70708	20.04959	74	306",
	"VO	Kupusina	45.73759	19.01082	83	306",
	"VO	Kuštilj	45.03487	21.37989	88	306",
	"VO	Lazarevo	45.38893	20.53999	76	306",
	"VO	Ljukovo	45.02604	20.02737	105	306",
	"VO	Lok	45.21583	20.21222	74	306",
	"VO	Lokve	45.15198	21.03073	77	306",
	"VO	Lukićevo	45.33815	20.49895	80	306",
	"VO	Lukino Selo	45.30244	20.42632	73	306",
	"VO	Mačvanska Mitrovica	44.96739	19.59314	76	306",
	"VO	Maglić	45.36248	19.53211	83	306",
	"VO	Mali Iđoš	45.70833	19.66528	87	306",
	"VO	Mali Žam	45.20979	21.33729	89	306",
	"VO	Margita	45.21598	21.17527	79	306",
	"VO	Markovac	45.14964	21.47242	129	306",
	"VO	Međa	45.53815	20.80677	77	306",
	"VO	Melenci	45.5168	20.31961	78	306",
	"VO	Mihajlovo	45.47085	20.41508	77	306",
	"VO	Miletićevo	45.30508	21.06404	76	306",
	"VO	Mokrin	45.93362	20.41215	77	306",
	"VO	Mol	45.76457	20.13286	81	306",
	"VO	Mošorin	45.30196	20.16919	75	306",
	"VO	Nakovo	45.87503	20.56709	81	306",
	"VO	Neuzina	45.3446	20.71418	74	306",
	"VO	Nikinci	44.85017	19.82321	78	306",
	"VO	Nikolinci	45.05245	21.06695	87	306",
	"VO	Nova Crnja	45.66833	20.605	81	306",
	"VO	Nova Pazova	44.94366	20.21931	76	306",
	"VO	Novi Banovci	44.95691	20.28076	91	306",
	"VO	Novi Bečej	45.59861	20.13556	76	306",
	"VO	Novi Itebej	45.55918	20.7003	75	306",
	"VO	Novi Karlovci	45.07636	20.17948	100	306",
	"VO	Novi Kneževac	46.05	20.1	76	306",
	"VO	Novi Kozarci	45.78241	20.62289	78	306",
	"VO	Novi Sad	45.25167	19.83694	79	306",
	"VO	Novi Slankamen	45.12554	20.23914	127	306",
	"VO	Novo Miloševo	45.71916	20.30364	78	306",
	"VO	Obrovac	45.32106	19.35048	82	306",
	"VO	Odžaci	45.50667	19.26111	89	306",
	"VO	Opovo	45.05222	20.43028	73	306",
	"VO	Orlovat	45.24171	20.58089	76	306",
	"VO	Ostojićevo	45.88863	20.16642	80	306",
	"VO	Padej	45.82756	20.16279	76	306",
	"VO	Padina	45.11988	20.7286	110	306",
	"VO	Pančevo	44.87177	20.64167	83	306",
	"VO	Pavliš	45.10569	21.23952	89	306",
	"VO	Pećinci	44.90889	19.96639	83	306",
	"VO	Perlez	45.20813	20.38197	78	306",
	"VO	Petrovaradin	45.24667	19.87944	78	306",
	"VO	Plandište	45.22722	21.12167	78	306",
	"VO	Platičevo	44.82213	19.79487	78	306",
	"VO	Prigrevica	45.67636	19.08809	85	306",
	"VO	Putinci	44.99259	19.97102	110	306",
	"VO	Radenković	44.92191	19.49543	81	306",
	"VO	Radojevo	45.74617	20.78917	78	306",
	"VO	Ravni Topolovac	45.46082	20.56939	75	306",
	"VO	Ravnje	44.94326	19.4228	80	306",
	"VO	Ravno Selo	45.44967	19.62097	79	306",
	"VO	Riđica	45.99088	19.10635	94	306",
	"VO	Ritiševo	45.06454	21.2281	79	306",
	"VO	Ruma	45.00806	19.82222	114	306",
	"VO	Rumenka	45.294	19.74306	82	306",
	"VO	Rusko Selo	45.76291	20.57117	76	306",
	"VO	Sajan	45.84227	20.27815	75	306",
	"VO	Šajkaš	45.27315	20.09051	78	306",
	"VO	Sakule	45.14667	20.48619	78	306",
	"VO	Salaš Noćajski	44.94722	19.58611	77	306",
	"VO	Samoš	45.20255	20.77392	96	306",
	"VO	Sanad	45.97596	20.10816	77	306",
	"VO	Šašinci	44.96514	19.74151	88	306",
	"VO	Sečanj	45.36667	20.77222	77	306",
	"VO	Sefkerin	45.00501	20.48256	72	306",
	"VO	Seleuš	45.1277	20.91461	80	306",
	"VO	Senta	45.9275	20.07722	81	306",
	"VO	Šid	45.12833	19.22639	104	306",
	"VO	Šimanovci	44.87393	20.09175	76	306",
	"VO	Sombor	45.77417	19.11222	89	306",
	"VO	Sonta	45.59427	19.09719	83	306",
	"VO	Srbobran	45.55389	19.80278	77	306",
	"VO	Sremska Mitrovica	44.97639	19.61222	84	306",
	"VO	Sremska Rača	44.92077	19.28577	80	306",
	"VO	Sremski Karlovci	45.20285	19.93373	88	306",
	"VO	Srpska Crnja	45.72538	20.69008	76	306",
	"VO	Srpski Itebej	45.56715	20.7135	78	306",
	"VO	Stajićevo	45.29489	20.45845	78	306",
	"VO	Stanišić	45.93895	19.16709	95	306",
	"VO	Stara Pazova	44.985	20.16083	81	306",
	"VO	Stari Banovci	44.9842	20.28382	77	306",
	"VO	Stari Lec	45.28401	20.96433	73	306",
	"VO	Stari Slankamen	45.14249	20.25765	82	306",
	"VO	Stepanovićevo	45.41369	19.7	80	306",
	"VO	Subotica	46.1	19.66667	115	306",
	"VO	Surduk	45.07118	20.3251	105	306",
	"VO	Sutjeska	45.38312	20.6962	75	306",
	"VO	Taraš	45.46737	20.19867	77	306",
	"VO	Temerin	45.40861	19.88917	81	306",
	"VO	Titel	45.20611	20.29444	90	306",
	"VO	Toba	45.68943	20.55714	77	306",
	"VO	Tomaševac	45.26855	20.62272	75	306",
	"VO	Torak	45.50928	20.609	78	306",
	"VO	Torda	45.58423	20.459	78	306",
	"VO	Uljma	45.04213	21.15393	87	306",
	"VO	Uzdin	45.20512	20.62342	77	306",
	"VO	Velika Greda	45.24376	21.03498	76	306",
	"VO	Veliki Gaj	45.28849	21.17057	81	306",
	"VO	Veliko Središte	45.17919	21.40353	103	306",
	"VO	Veternik	45.25446	19.7588	79	306",
	"VO	Vilovo	45.24859	20.15521	74	306",
	"VO	Višnjićevo	44.96731	19.28993	80	306",
	"VO	Vladimirovac	45.03122	20.86566	137	306",
	"VO	Vlajkovac	45.07207	21.19945	80	306",
	"VO	Vojka	44.93713	20.15236	76	306",
	"VO	Vojvoda Stepa	45.68537	20.65536	76	306",
	"VO	Vojvodinci	45.01557	21.34793	112	306",
	"VO	Vrbas	45.57139	19.64083	85	306",
	"VO	Vrbica	46.00584	20.31325	75	306",
	"VO	Vrdnik	45.12174	19.79227	197	306",
	"VO	Vršac	45.11667	21.30361	96	306",
	"VO	Žabalj	45.37222	20.06389	84	306",
	"VO	Zasavica Prva	44.95448	19.48938	76	306",
	"VO	Žitište	45.485	20.54972	78	306",
	"VO	Zmajevo	45.45408	19.6905	78	306",
	"VO	Zrenjanin	45.38361	20.38194	81	306",
];