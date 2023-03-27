const CITIES = [
	"01	Arizona	15.63333	-87.31667	72	181",
	"01	Atenas de San Cristóbal	15.68333	-87.31667	21	181",
	"01	Corozal	15.8	-86.71667	-9999	181",
	"01	El Pino	15.7	-86.93333	32	181",
	"01	El Porvenir	15.75	-86.93333	10	181",
	"01	El Triunfo de la Cruz	15.76667	-87.43333	144	181",
	"01	Hicaque	15.71667	-87.36667	532	181",
	"01	Jutiapa	15.76667	-86.51667	12	181",
	"01	La Ceiba	15.75971	-86.78221	14	181",
	"01	La Colorada	15.61667	-86.81667	1410	181",
	"01	La Masica	15.61667	-87.11667	28	181",
	"01	La Unión	15.71667	-87	3	181",
	"01	Matarras	15.51667	-87.4	512	181",
	"01	Mezapa	15.55	-87.38333	109	181",
	"01	Mezapa	15.58333	-87.65	154	181",
	"01	Nueva Armenia	15.79556	-86.49845	9	181",
	"01	Piedras Amarillas	15.68333	-86.56667	373	181",
	"01	Sambo Creek	15.81667	-86.68333	-9999	181",
	"01	San Antonio	15.6	-87.15	98	181",
	"01	San Francisco	15.65	-87.05	27	181",
	"01	San Juan Pueblo	15.58333	-87.23333	171	181",
	"01	Santa Ana	15.65	-87.06667	25	181",
	"01	Tela	15.77425	-87.46731	9	181",
	"01	Tornabé	15.75	-87.55	6	181",
	"02	Agua Caliente de Linaca	13.43528	-87.23167	246	181",
	"02	Ciudad Choluteca	13.30028	-87.19083	53	181",
	"02	Concepción de María	13.21667	-87	281	181",
	"02	Corpus	13.28889	-87.03472	378	181",
	"02	Duyure	13.63333	-86.81667	753	181",
	"02	El Obraje	13.15417	-87.13083	51	181",
	"02	El Perico	13.13889	-87.03222	225	181",
	"02	El Puente	13.28333	-87.11667	243	181",
	"02	El Triunfo	13.11667	-87	89	181",
	"02	Los Llanitos	13.28694	-87.33444	25	181",
	"02	Marcovia	13.28806	-87.30972	23	181",
	"02	Monjarás	13.20056	-87.37417	14	181",
	"02	Morolica	13.56667	-86.9	189	181",
	"02	Namasigüe	13.20472	-87.13889	54	181",
	"02	Orocuina	13.48167	-87.105	121	181",
	"02	Pespire	13.59222	-87.36167	123	181",
	"02	San Agustín	13.2	-87.11667	96	181",
	"02	San Francisco	13.36667	-86.9	1142	181",
	"02	San Jerónimo	13.17667	-87.13639	39	181",
	"02	San José de Las Conchas	13.32528	-87.39556	18	181",
	"02	San Marcos de Colón	13.43333	-86.8	997	181",
	"02	Santa Ana de Yusguare	13.30056	-87.11389	69	181",
	"02	Santa Cruz	13.25806	-87.34833	21	181",
	"03	Bonito Oriental	15.74765	-85.73559	32	181",
	"03	Corocito	15.75	-85.78333	50	181",
	"03	Cusuna	15.85	-85.23333	68	181",
	"03	Elíxir	15.48333	-86.3	90	181",
	"03	Francia	15.85	-85.58333	4	181",
	"03	Jericó	15.95	-85.96667	-9999	181",
	"03	La Brea	15.8	-85.96667	45	181",
	"03	La Curva	15.8	-85.76667	13	181",
	"03	La Esperanza	15.63333	-85.76667	442	181",
	"03	Prieta	15.5806	-86.13664	55	181",
	"03	Puerto Castilla	16.01667	-85.96667	7	181",
	"03	Punta Piedra	15.9	-85.28333	-9999	181",
	"03	Quebrada de Arena	15.76667	-85.91667	31	181",
	"03	Río Esteban	15.83333	-86.3	-9999	181",
	"03	Sabá	15.46667	-86.25	390	181",
	"03	Salamá	15.75	-85.96667	25	181",
	"03	Santa Rosa de Aguán	15.95	-85.71667	3	181",
	"03	Taujica	15.7	-85.91667	36	181",
	"03	Tocoa	15.68333	-86	37	181",
	"03	Trujillo	15.91667	-85.95417	35	181",
	"03	Zamora	15.63333	-86.06667	43	181",
	"04	Aguas del Padre	14.58081	-87.87865	1189	181",
	"04	Ajuterique	14.38304	-87.70965	681	181",
	"04	Cerro Blanco	14.66321	-87.78535	1248	181",
	"04	Comayagua	14.45139	-87.6375	593	181",
	"04	Concepción de Guasistagua	14.60764	-87.65499	513	181",
	"04	El Agua Dulcita	14.7	-87.75	1067	181",
	"04	El Buen Pastor	14.86667	-87.78333	778	181",
	"04	El Porvenir	14.58775	-87.89253	1191	181",
	"04	El Rincón	14.578	-87.92815	1251	181",
	"04	El Rosario	14.8	-87.76667	460	181",
	"04	El Sauce	14.5285	-87.66571	595	181",
	"04	El Socorro	14.62708	-87.90527	1165	181",
	"04	Esquías	14.74392	-87.3712	669	181",
	"04	Flores	14.29442	-87.57142	639	181",
	"04	Jamalteca	14.69597	-87.57908	498	181",
	"04	Jardines	14.7	-87.98333	588	181",
	"04	La Libertad	14.75792	-87.60759	448	181",
	"04	Lamaní	14.19626	-87.62128	735	181",
	"04	Las Lajas	14.78333	-87.75	454	181",
	"04	Las Mercedes	14.28333	-87.56667	645	181",
	"04	La Trinidad	14.71667	-87.66667	548	181",
	"04	Lejamaní	14.36681	-87.7072	691	181",
	"04	Meámbar	14.78333	-87.76667	416	181",
	"04	Minas de Oro	14.79611	-87.34654	975	181",
	"04	Ojos de Agua	14.6	-87.93333	1122	181",
	"04	Palo Pintado	14.51667	-87.68333	549	181",
	"04	Potrerillos	14.55137	-87.8774	1344	181",
	"04	Rancho Grande	14.68852	-87.49525	981	181",
	"04	Río Bonito	14.76667	-87.88333	1522	181",
	"04	San Antonio de la Cuesta	14.63333	-87.6	452	181",
	"04	San Jerónimo	14.63333	-87.6	452	181",
	"04	San José de Comayagua	14.73333	-88.03333	716	181",
	"04	San José del Potrero	14.83999	-87.28405	618	181",
	"04	San José de Pane	14.48333	-87.83333	1567	181",
	"04	San Luis	14.74935	-87.40846	719	181",
	"04	San Nicolás	14.71667	-87.35	586	181",
	"04	San Sebastián	14.24582	-87.63981	653	181",
	"04	Siguatepeque	14.59691	-87.83102	1082	181",
	"04	Taulabé	14.69251	-87.96537	587	181",
	"04	Valle de Ángeles	14.49921	-87.63989	601	181",
	"04	Villa de San Antonio	14.32594	-87.61351	606	181",
	"05	Agua Caliente	14.88333	-88.81667	932	181",
	"05	Buenos Aires	15.03333	-88.96667	956	181",
	"05	Chalmeca	15.09579	-88.68036	510	181",
	"05	Concepción de la Barranca	15.16667	-88.71667	969	181",
	"05	Copán Ruinas	14.83936	-89.15583	612	181",
	"05	Corquín	14.56667	-88.86667	909	181",
	"05	Cucuyagua	14.64777	-88.87385	746	181",
	"05	Dolores	14.87459	-88.81637	1081	181",
	"05	Dulce Nombre	14.84802	-88.8316	1122	181",
	"05	El Corpús	14.69814	-88.90862	755	181",
	"05	El Derrumbo	14.75	-88.78333	1101	181",
	"05	El Ocotón	15.03333	-88.88333	701	181",
	"05	Florida	15.02692	-88.83567	504	181",
	"05	La Entrada	15.06381	-88.74627	508	181",
	"05	La Esperanza	15.05091	-89.09818	775	181",
	"05	La Jigua	15.03333	-88.8	628	181",
	"05	La Playona	15.11803	-88.98197	205	181",
	"05	La Ruidosa	15.23628	-88.75142	741	181",
	"05	La Zumbadora	15.01433	-88.90117	639	181",
	"05	Los Arroyos	14.65	-88.88333	761	181",
	"05	Los Tangos	15.14585	-88.67931	428	181",
	"05	Nueva Armenia	15.03333	-89.1	871	181",
	"05	Ojos de Agua	14.7057	-88.81617	898	181",
	"05	Ostumán	14.83333	-89.16667	578	181",
	"05	Pueblo Nuevo	15	-88.75	724	181",
	"05	Quezailica	14.87652	-88.72714	645	181",
	"05	Río Amarillo	14.96667	-89.13333	713	181",
	"05	San Agustín	14.81958	-88.93562	1211	181",
	"05	San Jerónimo	14.96667	-88.86667	793	181",
	"05	San Joaquín	15.06053	-88.91193	1438	181",
	"05	San José	14.90235	-88.72063	677	181",
	"05	San Juan de Opoa	14.779	-88.69641	803	181",
	"05	San Juan de Planes	14.93333	-88.78333	793	181",
	"05	San Nicolás	15.00341	-88.75167	699	181",
	"05	Santa Cruz	14.75	-88.98333	1048	181",
	"05	Santa Rita, Copan	14.86748	-89.1	724	181",
	"05	Santa Rosa de Copán	14.76667	-88.77917	1146	181",
	"05	Trinidad de Copán	14.94567	-88.7422	857	181",
	"05	Veracruz	14.91667	-88.78333	1128	181",
	"05	Vivistorio	14.9	-88.73333	667	181",
	"06	Agua Azul	14.91667	-87.96667	705	181",
	"06	Agua Azul Rancho	14.9	-87.95	648	181",
	"06	Armenta	15.5	-88.05	191	181",
	"06	Baja Mar	15.88851	-87.85547	8	181",
	"06	Baracoa	15.77581	-87.85255	28	181",
	"06	Bejuco	15.13333	-87.93333	47	181",
	"06	Buenos Aires	15.48333	-88.18333	784	181",
	"06	Cañaveral	14.98401	-88.02486	510	181",
	"06	Casa Quemada	15.11667	-88.08333	389	181",
	"06	Chivana	15.75	-87.98333	222	181",
	"06	Choloma	15.61444	-87.95302	41	181",
	"06	Chotepe	15.41667	-87.98333	37	181",
	"06	Cofradía	15.4	-88.15	111	181",
	"06	Corinto	15.58333	-88.36667	18	181",
	"06	Cuyamel	15.66505	-88.19478	17	181",
	"06	El Edén	14.95	-88.01667	676	181",
	"06	El Llano	15.17939	-87.87952	72	181",
	"06	El Marañón	15.39518	-88.05437	112	181",
	"06	El Milagro	15.4	-87.96667	38	181",
	"06	El Olivar	15.08333	-87.88333	244	181",
	"06	El Perico	15.08333	-88.1	900	181",
	"06	El Plan	15.32641	-87.94984	67	181",
	"06	El Porvenir	15.83333	-87.93333	5	181",
	"06	El Rancho	15.66667	-87.95	89	181",
	"06	El Tigre	14.93333	-87.98333	649	181",
	"06	El Zapotal del Norte	15.51667	-88.05	179	181",
	"06	El Zapote	15.01667	-87.85	410	181",
	"06	La Bueso	15.61689	-87.85688	16	181",
	"06	La Esperanza	15.41667	-88.18333	214	181",
	"06	La Guama	14.88647	-87.93703	673	181",
	"06	La Jutosa	15.64166	-87.99201	94	181",
	"06	La Lima	15.43333	-87.91667	33	181",
	"06	La Sabana	15.37351	-87.93176	87	181",
	"06	Los Caminos	14.95045	-87.97531	713	181",
	"06	Los Naranjos	14.94398	-88.03654	652	181",
	"06	Monterrey	15.58937	-87.88138	19	181",
	"06	Naco	15.39106	-88.18312	164	181",
	"06	Nueva Granada	15.11667	-88.1	466	181",
	"06	Nuevo Chamelecón	15.38333	-88.01667	361	181",
	"06	Omoa	15.77603	-88.03833	9	181",
	"06	Oropéndolas	15.01667	-87.93333	165	181",
	"06	Peña Blanca	15.53333	-88.05	256	181",
	"06	Pimienta Vieja	15.23333	-87.96667	92	181",
	"06	Potrerillos	15.23008	-87.96386	48	181",
	"06	Potrerillos	15.63333	-88.3	8	181",
	"06	Pueblo Nuevo	15.34655	-87.99041	109	181",
	"06	Puerto Alto	15.7	-87.86667	11	181",
	"06	Puerto Cortez	15.82562	-87.92968	10	181",
	"06	Quebrada Seca	15.66065	-87.9493	30	181",
	"06	Río Blanquito	15.72756	-87.90151	20	181",
	"06	Río Chiquito	15.63407	-88.24136	22	181",
	"06	Río Lindo	15.0462	-87.98632	93	181",
	"06	San Antonio de Cortés	15.11611	-88.04074	587	181",
	"06	San Buenaventura	15.0243	-87.99447	287	181",
	"06	San Francisco de Yojoa	15.01442	-87.9716	308	181",
	"06	San José del Boquerón	15.51856	-87.89786	37	181",
	"06	San Manuel	15.33143	-87.92115	48	181",
	"06	San Pedro Sula	15.50417	-88.025	92	181",
	"06	Santa Cruz de Yojoa	14.98086	-87.89091	477	181",
	"06	Santa Elena	15.38333	-88.13333	89	181",
	"06	Travesía	15.86267	-87.90471	9	181",
	"06	Villanueva	15.31476	-87.99383	85	181",
	"07	Araulí	13.95	-86.55	749	181",
	"07	Cuyalí	13.88333	-86.55	772	181",
	"07	Danlí	14.03333	-86.58333	763	181",
	"07	El Benque	14.03333	-86.46667	563	181",
	"07	El Chichicaste	14.06667	-86.3	413	181",
	"07	El Obraje	14	-86.43333	527	181",
	"07	El Paraíso	13.86667	-86.55	804	181",
	"07	El Pescadero	13.93333	-86.55	742	181",
	"07	El Rodeo	14.28333	-86.6	763	181",
	"07	Güinope	13.88333	-86.93333	1310	181",
	"07	Jacaleapa	14.01667	-86.66667	826	181",
	"07	Jutiapa	13.98333	-86.4	484	181",
	"07	Las Ánimas	14.25	-86.56667	545	181",
	"07	Las Trojes	14.06667	-85.98333	755	181",
	"07	Liure	13.53583	-87.09194	223	181",
	"07	Mandasta	13.73333	-86.91667	1251	181",
	"07	Morocelí	14.11667	-86.86667	625	181",
	"07	Ojo de Agua	14.01667	-86.35	528	181",
	"07	Oropolí	13.81667	-86.81667	472	181",
	"07	Quebrada Larga	14.1	-86.36667	474	181",
	"07	San Diego	14.05	-86.46667	585	181",
	"07	San Lucas	13.73333	-86.95	1290	181",
	"07	San Matías	13.98333	-86.63333	801	181",
	"07	Santa Cruz	13.86667	-86.63333	864	181",
	"07	Teupasenti	14.21667	-86.7	773	181",
	"07	Texíguat	13.64972	-87.0225	350	181",
	"07	Yuscarán	13.94389	-86.85278	958	181",
	"08	Agalteca	14.45	-87.26667	724	181",
	"08	Alubarén	13.79611	-87.46889	311	181",
	"08	Cedros	14.6	-87.11667	927	181",
	"08	Cerro Grande	13.81667	-87.25	1090	181",
	"08	Cofradía	14.21667	-87.18333	1131	181",
	"08	El Chimbo	14.13333	-87.11667	1213	181",
	"08	El Durazno	14.13333	-87.26667	1397	181",
	"08	El Escanito	14.66667	-87.1	609	181",
	"08	El Escaño de Tepale	14.75	-87.06667	757	181",
	"08	El Guante	14.55	-87.1	881	181",
	"08	El Guantillo	14.6	-87.3	938	181",
	"08	El Guapinol	13.76667	-87.46667	751	181",
	"08	El Lolo	14.11667	-87.26667	1551	181",
	"08	El Pedernal	14.7	-87.11667	673	181",
	"08	El Porvenir	13.76167	-87.34583	556	181",
	"08	El Suyatal	14.51667	-87.21667	806	181",
	"08	El Tablón	14.03333	-87.16667	1040	181",
	"08	El Terrero	14.06667	-87.06667	1168	181",
	"08	El Tizatillo	13.99944	-87.195	1258	181",
	"08	Guaimaca	14.53333	-86.81667	884	181",
	"08	La Ermita	14.46667	-87.06667	770	181",
	"08	Las Tapias	14.06667	-87.28333	1078	181",
	"08	Lepaterique	14.06667	-87.46667	1475	181",
	"08	Marale	14.88333	-87.15	758	181",
	"08	Mata de Plátano	14.6	-87.28333	1095	181",
	"08	Mateo	14.08333	-87.31667	1127	181",
	"08	Ojojona	13.93389	-87.29583	1377	181",
	"08	Orica	14.7	-86.95	856	181",
	"08	Pueblo Nuevo	14.38333	-87.28333	1053	181",
	"08	Quebradas	14.5	-87.35	736	181",
	"08	Reitoca	13.82583	-87.46528	304	181",
	"08	Río Abajo	14.16667	-87.21667	1027	181",
	"08	Sabanagrande	13.80778	-87.25917	965	181",
	"08	San Ignacio	14.65	-87.03333	700	181",
	"08	San Juancito	14.21667	-87.06667	1254	181",
	"08	San Juan de Flores	14.26667	-87.03333	742	181",
	"08	Santa Ana	13.93167	-87.27139	1455	181",
	"08	Santa Lucía	14.1	-87.11667	1550	181",
	"08	Talanga	14.4	-87.08333	810	181",
	"08	Támara	14.15	-87.33333	1304	181",
	"08	Tegucigalpa	14.0818	-87.20681	944	181",
	"08	Urrutia	14.75	-87.03333	744	181",
	"08	Vallecillo	14.51667	-87.4	1009	181",
	"08	Valle de Ángeles	14.15	-87.03333	1278	181",
	"08	Villa de San Francisco	14.16667	-86.96667	777	181",
	"08	Villa Nueva	14.03333	-87.13333	1358	181",
	"08	Yaguacire	14.01667	-87.21667	1030	181",
	"08	Zambrano	14.26667	-87.4	1358	181",
	"09	Auas	15.48333	-84.33333	25	181",
	"09	Auka	14.94087	-83.83229	44	181",
	"09	Barra Patuca	15.8	-84.28333	1	181",
	"09	Brus Laguna	15.75	-84.48333	3	181",
	"09	Iralaya	15	-83.23333	5	181",
	"09	Palkaka	15.31667	-83.86667	3	181",
	"09	Paptalaya	15.5	-84.31667	12	181",
	"09	Puerto Lempira	15.26667	-83.77222	10	181",
	"09	Tikiraya	15.01667	-83.63333	8	181",
	"09	Waksma	15.43333	-84.4	16	181",
	"09	Wawina	15.41667	-84.43333	17	181",
	"10	Azacualpa	14.26667	-88.38333	1136	181",
	"10	Camasca	13.99677	-88.37973	828	181",
	"10	Intibucá	14.31226	-88.17608	1688	181",
	"10	Jesús de Otoro	14.48775	-87.98181	620	181",
	"10	Jiquinlaca	14.00595	-88.35162	530	181",
	"10	La Esperanza	14.31111	-88.18056	1697	181",
	"10	Magdalena	13.86667	-88.3	195	181",
	"10	Yamaranguila	14.28333	-88.24199	1759	181",
	"11	Coxen Hole	16.31553	-86.53966	-9999	181",
	"11	French Harbor	16.35	-86.43333	-9999	181",
	"11	Guanaja	16.44795	-85.89431	58	181",
	"11	Sandy Bay	16.32923	-86.56446	47	181",
	"11	Savannah Bight	16.45	-85.85	-9999	181",
	"12	Cane	14.27933	-87.65794	652	181",
	"12	La Florida	14.06667	-87.98333	1721	181",
	"12	La Paz	14.31944	-87.67917	688	181",
	"12	Los Planes	14.05	-88.01667	1811	181",
	"12	Marcala	14.15661	-88.03466	1239	181",
	"12	San Antonio del Norte	13.88444	-87.70306	301	181",
	"12	San José	14.24809	-87.95951	1298	181",
	"12	San Pedro de Tutule	14.25145	-87.85414	1244	181",
	"12	Santiago de Puringla	14.35783	-87.9041	1060	181",
	"12	Tepanguare	14.33333	-87.75	1672	181",
	"12	Yarumela	14.33578	-87.64557	603	181",
	"13	Cololaca	14.3	-88.88333	766	181",
	"13	El Achiotal	14.08333	-88.75	537	181",
	"13	Erandique	14.23787	-88.46447	1252	181",
	"13	Gracias	14.59028	-88.58194	798	181",
	"13	Guatemalita	14.11667	-88.61667	532	181",
	"13	Lagunas	14.61667	-88.48333	1008	181",
	"13	La Laguna del Pedernal	14.81667	-88.56667	1077	181",
	"13	La Libertad	14.81132	-88.58715	980	181",
	"13	Las Tejeras	14.80442	-88.59508	920	181",
	"13	La Unión	14.81387	-88.40845	1012	181",
	"13	La Virtud	14.06137	-88.69482	291	181",
	"13	Lepaera	14.77876	-88.5902	959	181",
	"13	Taragual	14.75	-88.48333	1116	181",
	"14	Antigua Ocotepeque	14.40131	-89.19971	750	181",
	"14	Belén Gualcho	14.48333	-88.8	1783	181",
	"14	El Granzal	14.4	-88.86667	1346	181",
	"14	El Tránsito	14.38333	-88.91667	1098	181",
	"14	La Encarnación	14.66676	-89.08751	876	181",
	"14	La Labor	14.48625	-89.00272	1004	181",
	"14	Llano Largo	14.46667	-89.01667	1137	181",
	"14	Lucerna	14.55817	-88.9345	830	181",
	"14	Mercedes	14.43333	-89.15	1402	181",
	"14	Nueva Ocotepeque	14.43333	-89.18333	808	181",
	"14	San Antonio	14.51667	-88.96667	880	181",
	"14	San Fernando	14.68333	-89.11667	1207	181",
	"14	San Francisco de Cones	14.51667	-88.9	1218	181",
	"14	San Francisco del Valle	14.43542	-88.95608	926	181",
	"14	San Marcos	14.40788	-88.95525	956	181",
	"14	Santa Fe	14.51667	-89.23333	831	181",
	"14	Santa Lucía	14.41667	-89.2	738	181",
	"14	Santa Teresa	14.38333	-89	1184	181",
	"14	Sensenti	14.49379	-88.93761	872	181",
	"14	Sinuapa	14.44305	-89.18594	820	181",
	"14	Yaruchel	14.52794	-88.81579	1476	181",
	"15	Arimís	14.78333	-86	713	181",
	"15	Campamento	14.55	-86.65	713	181",
	"15	Concordia	14.61667	-86.65	712	181",
	"15	Dulce Nombre de Culmí	15.1	-85.53333	526	181",
	"15	El Guayabito	14.83333	-86.03333	747	181",
	"15	El Rosario	14.9	-86.68333	780	181",
	"15	El Rusio	14.46667	-86.36667	632	181",
	"15	Gualaco	15.02521	-86.07076	653	181",
	"15	Guarizama	14.91667	-86.33333	647	181",
	"15	Guayape	14.71667	-86.83333	925	181",
	"15	Juticalpa	14.66667	-86.21944	391	181",
	"15	Jutiquile	14.71667	-86.08333	363	181",
	"15	La Concepción	14.7	-86.23333	645	181",
	"15	La Empalizada	14.65	-86.13333	349	181",
	"15	La Estancia	15.05	-86.35	1132	181",
	"15	La Guata	15.08333	-86.38333	934	181",
	"15	Laguna Seca	14.7	-86.1	363	181",
	"15	Mangulile	15.06667	-86.8	1099	181",
	"15	Manto	14.91667	-86.38333	658	181",
	"15	Punuare	14.73333	-85.96667	323	181",
	"15	Sabana Abajo	14.6	-86.58333	644	181",
	"15	Salamá	14.83333	-86.58333	670	181",
	"15	San Esteban	15.21231	-85.76996	447	181",
	"15	San Francisco de Becerra	14.63333	-86.1	376	181",
	"15	San Francisco de la Paz	14.9	-86.2	667	181",
	"15	San José de Río Tinto	14.93333	-85.7	453	181",
	"15	San Nicolás	14.55	-86.25	408	181",
	"15	Santa María del Real	14.76667	-85.95	337	181",
	"15	Silca	14.83333	-86.53333	790	181",
	"15	Zopilotepe	14.6	-86.26667	394	181",
	"16	Agualote	15.33621	-88.55312	281	181",
	"16	Arada	14.84582	-88.30108	398	181",
	"16	Atima	14.93253	-88.48965	723	181",
	"16	Azacualpa	14.71218	-88.0901	370	181",
	"16	Azacualpa	15.34364	-88.55226	279	181",
	"16	Berlín	14.84281	-88.49452	919	181",
	"16	Callejones	15.16667	-88.65	455	181",
	"16	Camalote	15.33333	-88.33333	201	181",
	"16	Casa Quemada	15.26667	-88.55	259	181",
	"16	Ceguaca	14.80232	-88.20387	574	181",
	"16	Chiquila	15.23333	-88.58333	261	181",
	"16	Concepción del Norte	15.16667	-88.13333	204	181",
	"16	Concepción del Sur	14.8	-88.16667	659	181",
	"16	Correderos	15.41778	-88.4552	580	181",
	"16	El Ciruelo	15.29443	-88.5083	220	181",
	"16	El Corozal	15.06667	-88.61667	619	181",
	"16	El Ermitano	15.25	-88.68333	983	181",
	"16	El Mochito	14.86667	-88.08333	933	181",
	"16	El Níspero	14.76667	-88.33333	686	181",
	"16	Guacamaya	15.02044	-88.15025	654	181",
	"16	Gualjoco	14.9599	-88.23735	206	181",
	"16	Ilama	15.06809	-88.22311	128	181",
	"16	Joconal	15.35519	-88.63295	694	181",
	"16	La Flecha	15.29237	-88.48953	221	181",
	"16	Laguna Verde	15.2	-88.16667	848	181",
	"16	La Reina	15.11667	-88.63333	1256	181",
	"16	Las Vegas, Santa Barbara	14.87649	-88.07473	892	181",
	"16	La Unión	15.13333	-88.55	584	181",
	"16	Loma Alta	15.39818	-88.56251	499	181",
	"16	Macholoa	14.91667	-88.3	417	181",
	"16	Naranjito	14.95297	-88.68333	954	181",
	"16	Nueva Jalapa	14.91667	-88.33333	566	181",
	"16	Nuevo Celilac	14.98333	-88.33333	506	181",
	"16	Petoa	15.26939	-88.28878	255	181",
	"16	Pinalejo	15.38705	-88.39207	258	181",
	"16	Potrerillos	15.26667	-88.43333	261	181",
	"16	Protección	15.02764	-88.6469	970	181",
	"16	Quimistán	15.34752	-88.4052	194	181",
	"16	San Francisco de Ojuera	14.75	-88.18333	434	181",
	"16	San José de Colinas	15.04101	-88.30186	381	181",
	"16	San José de Oriente	15.03333	-88.11667	611	181",
	"16	San José de Tarros	15.3	-88.7	729	181",
	"16	San Luis	15.12692	-88.43931	734	181",
	"16	San Luis de Planes	14.97603	-88.1251	1331	181",
	"16	San Marcos	15.30248	-88.41605	223	181",
	"16	San Nicolás	14.9423	-88.32796	563	181",
	"16	San Pedro Zacapa	14.7565	-88.11373	320	181",
	"16	Santa Bárbara	14.91944	-88.23611	256	181",
	"16	Santa Cruz Minas	15.36667	-88.3	365	181",
	"16	Santa Rita	14.91667	-88.21667	334	181",
	"16	San Vicente Centenario	14.89045	-88.28534	360	181",
	"16	Sula	15.24765	-88.56047	266	181",
	"16	Tras Cerros	15.3	-88.66667	625	181",
	"16	Trinidad	15.14237	-88.23321	216	181",
	"17	Agua Fría	13.46889	-87.55111	15	181",
	"17	Amapala	13.29222	-87.65389	25	181",
	"17	Aramecina	13.74222	-87.71028	136	181",
	"17	El Cubolero	13.46667	-87.66667	5	181",
	"17	El Guayabo	13.48944	-87.44389	38	181",
	"17	El Tular	13.46639	-87.51528	18	181",
	"17	Goascorán	13.58333	-87.61667	103	181",
	"17	Jícaro Galán	13.53167	-87.43889	55	181",
	"17	La Alianza	13.51222	-87.72444	26	181",
	"17	La Criba	13.45361	-87.41333	51	181",
	"17	Langue	13.62083	-87.6525	151	181",
	"17	Nacaome	13.53611	-87.4875	36	181",
	"17	San Francisco de Coray	13.66139	-87.53278	164	181",
	"17	San Lorenzo	13.42417	-87.44722	16	181",
	"18	Agua Blanca Sur	15.25	-87.88333	49	181",
	"18	Arenal	15.35	-86.83333	642	181",
	"18	Armenia	15.46667	-86.36667	108	181",
	"18	Ayapa	15.11174	-87.17557	642	181",
	"18	Bálsamo Oriental	15.48333	-86.33333	88	181",
	"18	Buenos Aires	15.46667	-86.4	107	181",
	"18	Carbajales	15.51667	-86.35	378	181",
	"18	Chirinos	15.4	-86.58333	726	181",
	"18	Coyoles	15.46667	-86.68333	180	181",
	"18	Coyoles Central	15.4	-86.66667	199	181",
	"18	El Bálsamo	15.06667	-87.46667	828	181",
	"18	El Juncal	15.45	-86.43333	135	181",
	"18	El Negrito	15.31667	-87.7	231	181",
	"18	El Ocote	15.41667	-86.56667	581	181",
	"18	El Portillo de González	15.28333	-87.6	177	181",
	"18	El Progreso	15.4	-87.8	48	181",
	"18	Guaimitas	15.5	-87.71667	47	181",
	"18	Jocón	15.28333	-86.96667	973	181",
	"18	La Estancia	15.28333	-87.55	778	181",
	"18	La Guacamaya	15.25	-87.8	1356	181",
	"18	La Mina	15.31667	-87.83333	69	181",
	"18	La Rosa	15.35	-87.06667	866	181",
	"18	La Sarrosa	15.23333	-87.83333	666	181",
	"18	Las Vegas	15.01667	-87.45	512	181",
	"18	La Trinidad	15.1	-87.2	625	181",
	"18	Lomitas	15.1	-87.21667	613	181",
	"18	Mojimán	15.26667	-87.6	206	181",
	"18	Morazán	15.31667	-87.6	211	181",
	"18	Nombre de Jesús	15.35	-86.68333	473	181",
	"18	Nueva Esperanza	15.26667	-87.6	206	181",
	"18	Nueva Florida	15.46667	-87.5	964	181",
	"18	Ocote Paulino	15.41667	-87.6	683	181",
	"18	Olanchito	15.48131	-86.57415	158	181",
	"18	Paujiles	15.1	-87.35	1324	181",
	"18	Punta Ocote	15.2	-87.28333	692	181",
	"18	Quebrada de Yoro	15.43333	-87.78333	54	181",
	"18	San Antonio	15.33333	-87.15	577	181",
	"18	San José	15.31667	-87.16667	584	181",
	"18	Santa Rita	15.16667	-87.28333	885	181",
	"18	Subirana	15.2	-87.45	837	181",
	"18	Sulaco	14.91667	-87.26667	419	181",
	"18	Teguajinal	15.36667	-86.6	904	181",
	"18	Tepusteca	15.41667	-86.31667	456	181",
	"18	Toyós	15.55	-87.65	61	181",
	"18	Trojas	15.35	-86.7	321	181",
	"18	Victoria	15.50381	-87.82625	23	181",
	"18	Yorito	15.06667	-87.28333	787	181",
	"18	Yoro	15.1375	-87.12778	648	181",
];
