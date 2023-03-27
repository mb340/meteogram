const CITIES = [
	"01	Isla Ratón	5.06862	-67.81295	87	412",
	"01	La Esmeralda	3.17453	-65.54517	113	412",
	"01	Maroa	2.7188	-67.56046	94	412",
	"01	Puerto Ayacucho	5.66049	-67.58343	84	412",
	"01	San Carlos de Río Negro	1.92027	-67.06089	92	412",
	"01	San Fernando de Atabapo	4.04564	-67.69934	93	412",
	"01	San Juan de Manapiare	5.32665	-66.05402	126	412",
	"02	Anaco	9.42958	-64.46428	225	412",
	"02	Aragua de Barcelona	9.45588	-64.82928	110	412",
	"02	Barcelona	10.13625	-64.68618	8	412",
	"02	Boca de Uchire	10.13191	-65.42236	3	412",
	"02	Cantaura	9.30571	-64.35841	263	412",
	"02	Clarines	9.93991	-65.16517	29	412",
	"02	El Chaparro	9.15204	-65.01732	97	412",
	"02	El Tigre	8.88902	-64.2527	297	412",
	"02	Guanta	10.23453	-64.59708	19	412",
	"02	Lecherías	10.19167	-64.69207	7	412",
	"02	Mapire	7.74085	-64.71047	65	412",
	"02	Onoto	9.59714	-65.1935	28	412",
	"02	Pariaguán	8.84357	-64.71053	276	412",
	"02	Píritu	10.0395	-65.03037	84	412",
	"02	Puerto La Cruz	10.21382	-64.6328	13	412",
	"02	Puerto Píritu	10.05896	-65.03698	36	412",
	"02	San José de Guanipa	8.88724	-64.16512	261	412",
	"02	San Mateo	9.74004	-64.54937	137	412",
	"02	Santa Ana	9.3056	-64.65478	176	412",
	"02	Soledad	8.16206	-63.5654	31	412",
	"02	Valle de Guanape	9.90999	-65.67405	281	412",
	"03	Achaguas	7.77917	-68.22373	62	412",
	"03	Biruaca	7.84483	-67.51679	51	412",
	"03	Bruzual	8.05052	-69.33257	85	412",
	"03	Elorza	7.06088	-69.49765	94	412",
	"03	Guasdualito	7.24241	-70.73235	130	412",
	"03	San Fernando de Apure	7.88782	-67.47236	51	412",
	"03	San Juan de Payara	7.64636	-67.6072	53	412",
	"04	Barbacoas	9.47855	-66.97458	171	412",
	"04	Cagua	10.18634	-67.45935	465	412",
	"04	Camatagua	9.78762	-66.90619	250	412",
	"04	El Consejo	10.23777	-67.27008	551	412",
	"04	El Limón	10.30589	-67.63212	492	412",
	"04	Las Tejerías	10.25416	-67.17333	506	412",
	"04	La Victoria	10.22677	-67.33122	562	412",
	"04	Maracay	10.23535	-67.59113	443	412",
	"04	Ocumare de la Costa	10.46127	-67.76872	15	412",
	"04	Palo Negro	10.17389	-67.54194	437	412",
	"04	San Casimiro	10.00169	-67.01464	490	412",
	"04	San Mateo	10.21302	-67.42365	497	412",
	"04	San Sebastián	9.94108	-67.17183	359	412",
	"04	Santa Cruz	10.18	-67.51184	450	412",
	"04	Santa Rita	10.2054	-67.55948	435	412",
	"04	Turmero	10.22856	-67.47421	475	412",
	"04	Villa de Cura	10.03863	-67.48938	523	412",
	"05	Altamira	8.82359	-70.50244	816	412",
	"05	Alto Barinas	8.5931	-70.2261	194	412",
	"05	Arauquita	8.70833	-69.65722	124	412",
	"05	Arismendi	8.47974	-68.36996	68	412",
	"05	Barinas	8.62261	-70.20749	187	412",
	"05	Barinitas	8.76171	-70.41199	544	412",
	"05	Barrancas	8.76962	-70.11086	201	412",
	"05	Bum Bum	8.27664	-70.76664	209	412",
	"05	Calderas	8.91426	-70.44745	908	412",
	"05	Capitanejo	8.01171	-71.00458	244	412",
	"05	Caramuca	8.59708	-70.32056	227	412",
	"05	Chameta	8.10023	-70.90671	213	412",
	"05	Ciudad Bolivia	8.35304	-70.57121	175	412",
	"05	Ciudad De Nutrias	8.09535	-69.30798	84	412",
	"05	Curbatí	8.45443	-70.55441	208	412",
	"05	Dolores	8.28623	-69.56633	100	412",
	"05	El Cantón	7.47801	-71.29693	158	412",
	"05	El Corozo	8.5675	-70.35778	213	412",
	"05	El Real	8.43525	-69.99633	132	412",
	"05	El Regalo	8.43455	-69.1767	86	412",
	"05	Guadarrama	8.53508	-68.04923	63	412",
	"05	La Luz	8.39419	-69.82358	119	412",
	"05	La Mula	8.57084	-70.37524	222	412",
	"05	Las Casitas del Vegon de Nutrias	8.23704	-69.4183	90	412",
	"05	La Unión	8.21573	-67.76653	59	412",
	"05	La Yuca	8.73109	-70.18072	224	412",
	"05	Libertad	8.32709	-69.63093	103	412",
	"05	Los Guasimitos	8.66435	-70.23216	206	412",
	"05	Maporal	7.645	-70.41985	115	412",
	"05	Masparrito	9.00194	-70.30139	1062	412",
	"05	Obispos	8.60701	-70.10489	159	412",
	"05	Pedraza La Vieja	7.9168	-71.05934	205	412",
	"05	Puerto de Nutrias	8.07281	-69.30246	83	412",
	"05	Puerto Vivas	7.50005	-71.84446	208	412",
	"05	Punta de Piedra	7.61759	-71.49164	179	412",
	"05	Quebrada Seca	8.70015	-70.31941	308	412",
	"05	Sabaneta	8.75234	-69.93351	146	412",
	"05	San Antonio	7.96378	-68.43384	70	412",
	"05	San Rafael de Canaguá	8.02667	-70.00861	109	412",
	"05	San Silvestre	8.27585	-70.11027	128	412",
	"05	Santa Bárbara	7.81348	-71.17788	187	412",
	"05	Santa Catalina	7.92408	-68.91745	72	412",
	"05	Santa Cruz de Guacas	7.44329	-71.30139	155	412",
	"05	Santa Inés	8.26241	-69.89795	115	412",
	"05	Santa Lucía	8.10155	-69.77752	102	412",
	"05	Santa Rosa	8.44033	-69.70105	113	412",
	"05	Socopó	8.23062	-70.82198	240	412",
	"05	Torunos	8.50015	-70.08056	142	412",
	"05	Veguitas	8.82391	-69.99581	164	412",
	"06	Caicara del Orinoco	7.63501	-66.16815	53	412",
	"06	Ciudad Bolívar	8.12923	-63.54086	45	412",
	"06	Ciudad Guayana	8.35122	-62.64102	103	412",
	"06	Ciudad Piar	7.45209	-63.31992	305	412",
	"06	El Callao	7.34706	-61.82684	171	412",
	"06	El Dorado	6.71581	-61.63738	95	412",
	"06	El Palmar	8.01082	-61.90713	326	412",
	"06	El Palmer	8.03333	-61.88333	307	412",
	"06	Guasipati	7.47702	-61.89666	198	412",
	"06	Kanavayén	5.63333	-61.8	1140	412",
	"06	La Paragua	6.83333	-63.33333	281	412",
	"06	Maripa	7.41584	-65.19034	43	412",
	"06	Santa Elena de Uairén	4.60226	-61.11025	868	412",
	"06	Tumeremo	7.29861	-61.50497	175	412",
	"06	Upata	8.0162	-62.40561	364	412",
	"07	Bejuma	10.17383	-68.25892	675	412",
	"07	Guacara	10.22609	-67.877	442	412",
	"07	Güigüe	10.08344	-67.77799	445	412",
	"07	Los Guayos	10.18932	-67.93828	444	412",
	"07	Mariara	10.29532	-67.7177	459	412",
	"07	Miranda	10.15077	-68.39325	629	412",
	"07	Montalbán	10.21313	-68.32669	669	412",
	"07	Morón	10.48715	-68.20078	15	412",
	"07	Naguanagua	10.25604	-68.01649	500	412",
	"07	Puerto Cabello	10.47306	-68.0125	10	412",
	"07	San Diego	10.26057	-67.95363	471	412",
	"07	San Joaquín	10.26061	-67.79348	443	412",
	"07	Tacarigua	10.08621	-67.91982	427	412",
	"07	Tocuyito	10.11347	-68.06783	463	412",
	"07	Valencia	10.16202	-68.00765	457	412",
	"08	Cojedes	9.62232	-68.91805	147	412",
	"08	El Baúl	8.96225	-68.29511	70	412",
	"08	El Pao	9.63926	-68.12917	144	412",
	"08	Las Vegas	9.53724	-68.63022	120	412",
	"08	Libertad	9.35654	-68.69221	95	412",
	"08	Macapo	9.82533	-68.43866	310	412",
	"08	San Carlos	9.66124	-68.58268	156	412",
	"08	Tinaco	9.69894	-68.43273	159	412",
	"08	Tinaquillo	9.91861	-68.30472	429	412",
	"09	Curiapo	8.58057	-60.99778	6	412",
	"09	Pedernales	9.971	-62.252	13	412",
	"09	Sierra Imataca	8.39352	-62.45439	76	412",
	"09	Tucupita	9.05806	-62.05	9	412",
	"11	Boca de Aroa	10.68229	-68.29829	4	412",
	"11	Cabure	11.1453	-69.61191	619	412",
	"11	Canape Capatárida	11.1755	-70.62072	32	412",
	"11	Chichiriviche	10.92872	-68.27283	4	412",
	"11	Churuguara	10.81231	-69.53734	944	412",
	"11	Coro	11.4045	-69.67344	27	412",
	"11	Dabajuro	11.02273	-70.67769	93	412",
	"11	Jacura	11.07446	-68.85583	285	412",
	"11	Judibana	11.75908	-70.18418	16	412",
	"11	La Cruz de Taratara	11.06302	-69.71287	297	412",
	"11	La Vela de Coro	11.46077	-69.5657	13	412",
	"11	Mene de Mauroa	10.68091	-71.03609	110	412",
	"11	Mirimire	11.1602	-68.72604	166	412",
	"11	Palmasola	10.59363	-68.54422	38	412",
	"11	Pedregal	11.02142	-70.12106	157	412",
	"11	Píritu	11.36648	-69.13807	216	412",
	"11	Pueblo Nuevo	11.94788	-69.92306	85	412",
	"11	Puerto Cumarebo	11.48614	-69.35319	29	412",
	"11	Punta Cardón	11.65806	-70.215	34	412",
	"11	Punto Fijo	11.69152	-70.19918	24	412",
	"11	San Juan de los Cayos	11.17203	-68.4128	6	412",
	"11	San Luis	11.12034	-69.68397	744	412",
	"11	Santa Cruz de Bucaral	10.81919	-69.27679	844	412",
	"11	Santa Cruz de los Taques	11.8235	-70.25637	10	412",
	"11	Tocópero	11.49946	-69.259	166	412",
	"11	Tocuyo de La Costa	11.0357	-68.37448	6	412",
	"11	Tucacas	10.79006	-68.32564	4	412",
	"11	Urumaco	11.19996	-70.25543	100	412",
	"11	Yaracal	10.96985	-68.54648	36	412",
	"12	Altagracia de Orituco	9.86005	-66.38139	352	412",
	"12	Calabozo	8.92416	-67.42929	103	412",
	"12	Camaguán	8.10732	-67.60738	57	412",
	"12	Chaguaramas	9.33754	-66.25282	184	412",
	"12	El Socorro	8.99352	-65.74247	118	412",
	"12	El Sombrero	9.3863	-67.05818	163	412",
	"12	Guayabal	8.00077	-67.39732	56	412",
	"12	Las Mercedes	9.11037	-66.39607	162	412",
	"12	Ortiz	9.62168	-67.29047	188	412",
	"12	Palmasola	9.23333	-66.71667	142	412",
	"12	San José de Guaribe	9.86025	-65.81306	227	412",
	"12	San Juan de los Morros	9.91152	-67.35381	433	412",
	"12	Santa María de Ipire	8.81556	-65.3225	129	412",
	"12	Tucupido	9.27304	-65.77153	134	412",
	"12	Valle de La Pascua	9.21554	-66.00734	189	412",
	"12	Zaraza	9.35029	-65.32452	80	412",
	"13	Barquisimeto	10.0647	-69.35703	606	412",
	"13	Cabudare	10.02658	-69.26203	476	412",
	"13	Carora	10.17283	-70.081	420	412",
	"13	Duaca	10.28554	-69.16244	733	412",
	"13	El Tocuyo	9.78709	-69.79294	616	412",
	"13	Los Rastrojos	10.02588	-69.24166	446	412",
	"13	Quíbor	9.92866	-69.6201	695	412",
	"13	Sanare	9.75209	-69.6524	1335	412",
	"13	Sarare	9.78129	-69.1633	269	412",
	"13	Siquisique	10.57112	-69.70172	272	412",
	"14	Arapuey	9.25934	-70.95248	54	412",
	"14	Aricagua	8.22432	-71.13721	975	412",
	"14	Bailadores	8.25347	-71.82818	1707	412",
	"14	Canaguá	8.12489	-71.46041	1467	412",
	"14	Ejido	8.54665	-71.24087	1143	412",
	"14	El Vigía	8.6135	-71.65702	106	412",
	"14	Guaraque	8.15405	-71.73562	1584	412",
	"14	La Azulita	8.71364	-71.44421	1110	412",
	"14	Lagunillas	8.50457	-71.3894	1056	412",
	"14	Mérida	8.58972	-71.15611	1544	412",
	"14	Mucuchíes	8.74921	-70.91978	2960	412",
	"14	Nueva Bolivia	9.14007	-71.09143	75	412",
	"14	Pueblo Llano	8.9152	-70.65919	2161	412",
	"14	Santa Cruz de Mora	8.39925	-71.64082	600	412",
	"14	Santa Elena de Arenales	8.82062	-71.46572	59	412",
	"14	Santa María de Caparo	7.71412	-71.46466	206	412",
	"14	Santo Domingo	8.86052	-70.6948	2151	412",
	"14	Tabay	8.6317	-71.07833	1696	412",
	"14	Timotes	8.98224	-70.73926	2001	412",
	"14	Torondoy	9.03457	-71.01412	1123	412",
	"14	Tovar	8.33015	-71.75277	934	412",
	"14	Tucaní	8.97003	-71.27277	169	412",
	"14	Zea	8.37706	-71.78398	889	412",
	"15	Baruta	10.43424	-66.87558	999	412",
	"15	Carrizal	10.34985	-66.98632	1341	412",
	"15	Caucagua	10.2831	-66.37591	68	412",
	"15	Caucagüito	10.48666	-66.73799	707	412",
	"15	Chacao	10.49581	-66.85367	887	412",
	"15	Charallave	10.24247	-66.85723	311	412",
	"15	Cúa	10.16245	-66.88248	251	412",
	"15	Cúpira	10.16128	-65.70013	21	412",
	"15	El Cafetal	10.46541	-66.82951	915	412",
	"15	El Hatillo	10.42411	-66.82581	1154	412",
	"15	Guarenas	10.47027	-66.61934	361	412",
	"15	Guatire	10.474	-66.54241	331	412",
	"15	Higuerote	10.48287	-66.10096	4	412",
	"15	La Dolorita	10.4883	-66.78608	1034	412",
	"15	Los Dos Caminos	10.49389	-66.82863	876	412",
	"15	Los Teques	10.34447	-67.04325	1185	412",
	"15	Mamporal	10.36556	-66.13391	35	412",
	"15	Ocumare del Tuy	10.1182	-66.77513	201	412",
	"15	Petare	10.47679	-66.80786	846	412",
	"15	Río Chico	10.31899	-65.97751	8	412",
	"15	San Antonio de Los Altos	10.38853	-66.95179	1396	412",
	"15	San Francisco de Yare	10.17793	-66.74649	170	412",
	"15	San José de Barlovento	10.30125	-65.99053	6	412",
	"15	Santa Lucía	10.30494	-66.65998	175	412",
	"15	Santa Teresa del Tuy	10.23291	-66.66474	139	412",
	"16	Aguasay	9.42489	-63.73077	218	412",
	"16	Aragua	9.97026	-63.48727	240	412",
	"16	Barrancas	8.6989	-62.19656	16	412",
	"16	Caicara	9.81755	-63.61331	187	412",
	"16	Caripe	10.17335	-63.50048	854	412",
	"16	Caripito	10.11135	-63.09985	37	412",
	"16	Maturín	9.74569	-63.18323	71	412",
	"16	Punta de Mata	9.69131	-63.60921	246	412",
	"16	Quiriquire	9.9795	-63.21991	73	412",
	"16	San Antonio	10.11914	-63.72535	474	412",
	"16	Santa Bárbara	9.60745	-63.60938	204	412",
	"16	Temblador	9.00525	-62.64493	36	412",
	"16	Uracoa	8.99432	-62.35202	8	412",
	"17	Boca de Río	10.96757	-64.1805	3	412",
	"17	El Valle del Espíritu Santo	10.9832	-63.88292	61	412",
	"17	Juan Griego	11.08172	-63.96549	5	412",
	"17	La Asunción	11.03333	-63.86278	42	412",
	"17	La Plaza Paraguachi	11.10783	-63.85537	22	412",
	"17	Pampatar	11.00122	-63.79297	3	412",
	"17	Porlamar	10.95771	-63.86971	22	412",
	"17	Punta de Piedras	10.90123	-64.0969	2	412",
	"17	San Juan Bautista	11.01422	-63.94383	69	412",
	"17	San Pedro de Coche	10.78131	-63.99675	2	412",
	"17	Santa Ana	11.06828	-63.92239	34	412",
	"18	Acarigua	9.55451	-69.19564	189	412",
	"18	Agua Blanca	9.66205	-69.10677	180	412",
	"18	Araure	9.58144	-69.23851	240	412",
	"18	Biscucuy	9.36	-69.98302	521	412",
	"18	Boconoito	8.84659	-69.98032	190	412",
	"18	El Playón	9.10049	-69.04564	100	412",
	"18	Guanare	9.04183	-69.74206	164	412",
	"18	Guanarito	8.69625	-69.20832	93	412",
	"18	Ospino	9.29572	-69.45434	197	412",
	"18	Papelón	8.94109	-69.46021	109	412",
	"18	Paraíso de Chabasquén	9.43326	-69.94728	641	412",
	"18	Píritu	9.37083	-69.21028	156	412",
	"18	San Rafael de Onoto	9.67813	-68.97278	163	412",
	"18	Villa Bruzual	9.33186	-69.11968	135	412",
	"19	Araya	10.57998	-64.25548	18	412",
	"19	Arenas	10.27931	-63.93725	209	412",
	"19	Aricagua	10.23861	-63.89761	259	412",
	"19	Cariaco	10.49682	-63.55286	16	412",
	"19	Carúpano	10.66516	-63.25387	15	412",
	"19	Casanay	10.5042	-63.41729	37	412",
	"19	Cumaná	10.45397	-64.18256	4	412",
	"19	Cumanacoa	10.25056	-63.91938	229	412",
	"19	El Pilar	10.54782	-63.15424	80	412",
	"19	Güiria	10.57721	-62.29841	12	412",
	"19	Irapa	10.57006	-62.58204	6	412",
	"19	Marigüitar	10.44789	-63.90161	15	412",
	"19	Río Caribe	10.6977	-63.10871	14	412",
	"19	San Antonio del Golfo	10.44198	-63.78874	43	412",
	"19	San José de Aerocuar	10.59973	-63.32852	185	412",
	"19	San Lorenzo	10.22301	-63.92452	272	412",
	"19	Tunapuy	10.5748	-63.10751	41	412",
	"19	Yaguaraparo	10.56839	-62.82628	15	412",
	"20	Abejales	7.6233	-71.51031	184	412",
	"20	Capacho Nuevo	7.82472	-72.3084	1265	412",
	"20	Capacho Viejo	7.82893	-72.31942	1301	412",
	"20	Colón	8.03125	-72.26053	805	412",
	"20	Coloncito	8.32611	-72.08742	134	412",
	"20	Cordero	7.85689	-72.181	1145	412",
	"20	Delicias	7.56505	-72.44754	1549	412",
	"20	El Cobre	8.0349	-72.05718	1898	412",
	"20	La Fría	8.21523	-72.24888	119	412",
	"20	La Grita	8.13316	-71.9839	1456	412",
	"20	Las Mesas	8.17123	-72.15948	462	412",
	"20	La Tendida	8.50734	-71.83201	145	412",
	"20	Lobatera	7.92978	-72.24731	957	412",
	"20	Michelena	7.95655	-72.24299	1230	412",
	"20	Palmira	7.8373	-72.22802	1107	412",
	"20	Pregonero	8.01909	-71.76595	1254	412",
	"20	Queniquea	7.91659	-72.0138	1603	412",
	"20	Rubio	7.70131	-72.35569	833	412",
	"20	San Antonio del Táchira	7.81454	-72.4431	430	412",
	"20	San Cristóbal	7.76694	-72.225	899	412",
	"20	San Josecito	7.66106	-72.22009	609	412",
	"20	San José de Bolívar	7.91242	-71.97251	1429	412",
	"20	San Rafael del Piñal	7.52987	-71.95922	270	412",
	"20	San Simón	8.35018	-71.85114	1047	412",
	"20	Santa Ana	7.6422	-72.27694	802	412",
	"20	Santa Ana	8.11697	-72.02174	1632	412",
	"20	Seboruco	8.14514	-72.07332	880	412",
	"20	Táriba	7.8188	-72.22427	885	412",
	"20	Umuquena	8.26648	-72.06432	547	412",
	"20	Ureña	7.91857	-72.44708	324	412",
	"21	Betijoque	9.38121	-70.73283	546	412",
	"21	Boconó	9.25385	-70.25105	1421	412",
	"21	Campo Elías	9.39458	-70.05872	1033	412",
	"21	Carache	9.62857	-70.22864	1210	412",
	"21	Carvajal	9.3067	-70.59042	685	412",
	"21	Chejendé	9.6186	-70.35682	994	412",
	"21	El Dividive	9.4751	-70.73493	140	412",
	"21	El Paradero	9.77278	-70.61541	321	412",
	"21	Escuque	9.29687	-70.67189	1020	412",
	"21	La Quebrada	9.15522	-70.57702	1443	412",
	"21	Monte Carmelo	9.18821	-70.81229	936	412",
	"21	Motatán	9.39182	-70.59061	321	412",
	"21	Pampán	9.44519	-70.47556	468	412",
	"21	Pampanito	9.41037	-70.50116	357	412",
	"21	Sabana de Mendoza	9.43494	-70.77495	106	412",
	"21	Sabana Grande	9.4018	-70.79812	112	412",
	"21	Santa Apolonia	9.47135	-71.01213	4	412",
	"21	Santa Isabel	9.63163	-70.80837	29	412",
	"21	Trujillo	9.36583	-70.43694	795	412",
	"21	Valera	9.31778	-70.60361	524	412",
	"22	Aroa	10.43949	-68.89496	254	412",
	"22	Boraure	10.24752	-68.76966	208	412",
	"22	Chivacoa	10.15951	-68.89453	300	412",
	"22	Cocorote	10.31954	-68.78298	415	412",
	"22	Farriar	10.47016	-68.55885	41	412",
	"22	Guama	10.26638	-68.81986	348	412",
	"22	Independencia	10.33432	-68.75512	335	412",
	"22	Nirgua	10.15039	-68.56478	800	412",
	"22	Sabana de Parra	10.12111	-69.03639	416	412",
	"22	San Felipe	10.33991	-68.74247	287	412",
	"22	San Pablo	10.24929	-68.84427	349	412",
	"22	Urachiche	10.15847	-69.00782	479	412",
	"22	Yaritagua	10.08081	-69.1242	381	412",
	"22	Yumare	10.59703	-68.67328	63	412",
	"23	Bachaquero	9.96209	-71.12377	0	412",
	"23	Bobures	9.24173	-71.17506	3	412",
	"23	Cabimas	10.39907	-71.45206	5	412",
	"23	Caja Seca	9.14151	-71.06741	109	412",
	"23	Casigua El Cubo	8.74602	-72.51889	39	412",
	"23	Chiquinquirá	10.44333	-71.64722	1	412",
	"23	Ciudad Ojeda	10.20161	-71.3148	6	412",
	"23	Concepción	10.4119	-71.68919	2	412",
	"23	Concepción	10.8	-71.76667	61	412",
	"23	El Corozo	10.12061	-71.04422	78	412",
	"23	El Toro	10.95423	-71.64843	3	412",
	"23	Encontrados	9.05983	-72.2346	6	412",
	"23	La Concepción	10.61919	-71.83814	75	412",
	"23	Lagunillas	10.13008	-71.25946	-4	412",
	"23	La Plata	10.32025	-71.2721	48	412",
	"23	La Villa del Rosario	10.3258	-72.31343	83	412",
	"23	Los Puertos de Altagracia	10.71492	-71.52168	8	412",
	"23	Machiques	10.06077	-72.55212	99	412",
	"23	Maracaibo	10.66663	-71.61245	40	412",
	"23	Mene Grande	9.84639	-70.92655	55	412",
	"23	Pueblo Nuevo El Chivo	8.96249	-71.60754	8	412",
	"23	Punta Gorda	10.33407	-71.41352	6	412",
	"23	San Carlos del Zulia	9.00098	-71.92683	6	412",
	"23	San Francisco	10.55363	-71.70364	54	412",
	"23	San Rafael	10.96205	-71.73034	-2	412",
	"23	Santa Cruz de Mara	10.79269	-71.68505	13	412",
	"23	Santa Rita	10.53642	-71.51104	9	412",
	"23	San Timoteo	9.7901	-71.07084	0	412",
	"23	Sinamaica	11.08656	-71.85595	0	412",
	"23	Tía Juana	10.25927	-71.36343	-3	412",
	"24	Los Roques	11.94836	-66.67835	6	412",
	"25	Caracas	10.48801	-66.87919	887	412",
	"25	Caricuao	10.43337	-66.98313	976	412",
	"26	Caraballeda	10.61216	-66.85192	44	412",
	"26	Catia La Mar	10.60545	-67.03238	9	412",
	"26	El Junko	10.47249	-67.08361	1711	412",
	"26	La Guaira	10.60156	-66.93293	15	412",
	"26	La Sabana	10.61867	-66.38194	30	412",
	"26	Macuto	10.60508	-66.89745	12	412",
	"26	Maiquetía	10.5945	-66.95624	82	412",
	"26	Naiguatá	10.62026	-66.73833	38	412",
];
