const CITIES = [
	"01	Ceyranbatan	40.54194	49.66073	22	46",
	"01	Digah	40.49257	49.87477	39	46",
	"01	Gyuzdek	40.37444	49.68194	156	46",
	"01	Khirdalan	40.44808	49.75502	75	46",
	"01	Qobu	40.40472	49.71306	54	46",
	"01	Saray	40.53299	49.71681	42	46",
	"02	Agdzhabedy	40.05015	47.45937	15	46",
	"02	Avşar	39.97389	47.42389	45	46",
	"03	Ağdam	39.99096	46.92736	374	46",
	"04	Ağdaş	40.64699	47.4738	50	46",
	"05	Aghstafa	41.11889	45.45389	327	46",
	"05	Saloğlu	41.27524	45.35293	249	46",
	"05	Vurğun	41.09524	45.47111	356	46",
	"06	Aghsu	40.57028	48.40087	179	46",
	"07	Şirvan	39.93778	48.929	-15	46",
	"08	Astara	38.45598	48.87498	-22	46",
	"08	Kizhaba	38.53461	48.80546	24	46",
	"09	Amirdzhan	40.42639	49.98361	18	46",
	"09	Badamdar	40.34024	49.8045	161	46",
	"09	Bakıxanov	40.41894	49.96693	33	46",
	"09	Baku	40.37767	49.89201	-23	46",
	"09	Balakhani	40.46344	49.91893	57	46",
	"09	Bilajari	40.4444	49.80566	25	46",
	"09	Bilajer	40.56441	50.04002	18	46",
	"09	Binagadi	40.46602	49.82783	44	46",
	"09	Biny Selo	40.45076	50.08686	1	46",
	"09	Buzovna	40.51903	50.11438	-15	46",
	"09	Gyurgyan	40.39701	50.33667	-22	46",
	"09	Hövsan	40.37444	50.08528	-19	46",
	"09	Khojasan	40.41293	49.76904	30	46",
	"09	Korgöz	40.30446	49.6236	28	46",
	"09	Lokbatan	40.3256	49.73376	4	46",
	"09	Mardakan	40.49182	50.14292	-4	46",
	"09	Maştağa	40.52983	50.00616	19	46",
	"09	Nardaran	40.55611	50.00556	28	46",
	"09	Neft Daşları	40.25213	50.84003	-25	46",
	"09	Pirallahı	40.47013	50.32476	-19	46",
	"09	Puta	40.29667	49.66028	-8	46",
	"09	Qala	40.44256	50.16759	7	46",
	"09	Qaraçuxur	40.39667	49.97361	51	46",
	"09	Qobustan	40.08238	49.41205	-16	46",
	"09	Ramana	40.44222	49.98056	19	46",
	"09	Sabunçu	40.4425	49.94806	26	46",
	"09	Sanqaçal	40.16991	49.46394	-20	46",
	"09	Shongar	40.32157	49.59907	44	46",
	"09	Türkan	40.3646	50.22075	-17	46",
	"09	Yeni Suraxanı	40.43026	50.03598	12	46",
	"09	Zabrat	40.47746	49.94174	23	46",
	"09	Zyrya	40.36613	50.29198	-14	46",
	"10	Belokany	41.72626	46.40478	372	46",
	"10	Qabaqçöl	41.75259	46.27052	267	46",
	"11	Barda	40.37577	47.12619	77	46",
	"11	Samuxlu	40.50781	47.16971	33	46",
	"12	Beylagan	39.77556	47.61861	58	46",
	"12	Birinci Aşıqlı	39.81917	47.67944	26	46",
	"12	Dünyamalılar	39.77278	47.75889	27	46",
	"12	Orjonikidze	39.63571	47.71199	62	46",
	"12	Yuxarı Aran	39.73361	47.655	60	46",
	"13	Pushkino	39.45833	48.545	4	46",
	"14	Jebrail	39.39917	47.02835	607	46",
	"15	Geytepe	39.11998	48.59383	4	46",
	"15	Jalilabad	39.20963	48.49186	39	46",
	"16	Alunitdağ	40.52959	46.05225	1660	46",
	"16	Verkhniy Dashkesan	40.49357	46.07175	1592	46",
	"16	Yukhary-Dashkesan	40.52393	46.08186	1601	46",
	"17	Divichibazar	41.20117	48.98712	44	46",
	"18	Fizuli	39.60094	47.14529	419	46",
	"18	Horadiz	39.45015	47.33496	160	46",
	"19	Arıqdam	40.59313	45.799	1508	46",
	"19	Arıqıran	40.53971	45.61414	1434	46",
	"19	Böyük Qaramurad	40.57626	45.63727	1202	46",
	"19	Kyadabek	40.57055	45.81229	1460	46",
	"19	Novosaratovka	40.59811	45.60079	1240	46",
	"20	Ganja	40.68278	46.36056	417	46",
	"21	Goranboy	40.61028	46.78972	156	46",
	"21	Qazanbulaq	40.61871	46.64922	259	46",
	"21	Qızılhacılı	40.57723	46.85776	129	46",
	"22	Göyçay	40.65055	47.74219	122	46",
	"23	Hacıqabul	40.03874	48.94286	0	46",
	"23	Mughan	40.09902	48.81886	-15	46",
	"24	Imishli	39.87095	48.05995	1	46",
	"25	Basqal	40.7552	48.39104	1081	46",
	"25	İsmayıllı	40.78485	48.15141	579	46",
	"25	Lahıc	40.84618	48.38227	1215	46",
	"26	İstisu	39.94628	45.96062	2211	46",
	"26	Kerbakhiar	40.10984	46.04446	1555	46",
	"26	Vank	40.05275	46.54419	1031	46",
	"27	Kyurdarmir	40.34257	48.15649	7	46",
	"28	Laçın	39.59881	46.55045	889	46",
	"29	Haftoni	38.76325	48.76223	9	46",
	"29	Lankaran	38.75428	48.85062	-22	46",
	"31	Lerik	38.77388	48.41497	1094	46",
	"32	Boradigah	38.93013	48.7092	-15	46",
	"32	Masally	39.03532	48.6654	5	46",
	"33	Mingelchaur	40.76395	47.05953	26	46",
	"34	Naftalan	40.50821	46.8203	251	46",
	"35	Arafsa	39.29383	45.78811	1607	46",
	"35	Ashagy Aylis	38.93079	45.98959	932	46",
	"35	Cahri	39.34837	45.41557	1074	46",
	"35	Çalxanqala	39.44167	45.28333	1372	46",
	"35	Culfa	38.95397	45.62961	714	46",
	"35	Deste	38.88375	45.90963	696	46",
	"35	Heydarabad	39.72286	44.84846	818	46",
	"35	Nakhchivan	39.20889	45.41222	887	46",
	"35	Oğlanqala	39.58694	45.04611	853	46",
	"35	Ordubad	38.90961	46.02274	892	46",
	"35	Qıvraq	39.39939	45.11513	915	46",
	"35	Şahbuz	39.40722	45.57389	1196	46",
	"35	Sedarak	39.71427	44.88455	860	46",
	"35	Sharur City	39.55298	44.97993	810	46",
	"35	Sumbatan-diza	38.94804	45.82572	791	46",
	"35	Tazakend	39.15459	45.44282	826	46",
	"35	Yaycı	38.94052	45.73244	706	46",
	"36	Neftçala	39.3768	49.247	-24	46",
	"36	Severo-Vostotchnyi Bank	39.41117	49.24792	-25	46",
	"36	Sovetabad	39.33667	49.21414	-25	46",
	"36	Xıllı	39.43012	49.10166	-26	46",
	"37	Oğuz	41.07128	47.46528	652	46",
	"38	Qutqashen	40.98247	47.84909	795	46",
	"39	Çinarlı	41.46965	46.91582	795	46",
	"39	Qax	41.41826	46.92043	590	46",
	"39	Qaxbaş	41.43254	46.9646	758	46",
	"39	Qax İngiloy	41.42412	46.93859	656	46",
	"40	Qazax	41.09246	45.36561	378	46",
	"41	Qobustan	40.5336	48.92819	771	46",
	"42	Hacıhüseynli	41.45639	48.64889	258	46",
	"42	Quba	41.36108	48.51341	600	46",
	"43	Qubadlı	39.34441	46.58183	482	46",
	"44	Qusar	41.4275	48.4302	681	46",
	"44	Samur	41.63671	48.43028	307	46",
	"45	Əhmədbəyli	39.88074	48.39158	-11	46",
	"45	Saatlı	39.93214	48.36892	-7	46",
	"46	Qalaqayın	39.98365	48.4836	-13	46",
	"46	Sabirabad	40.00869	48.47701	-11	46",
	"47	Baş Göynük	41.32582	47.11357	858	46",
	"48	Sheki	41.19194	47.17056	549	46",
	"49	Qaraçala	39.81614	48.93792	-22	46",
	"49	Salyan	39.59621	48.98479	-17	46",
	"50	Shamakhi	40.63141	48.64137	687	46",
	"51	Dolyar	40.86278	46.03493	341	46",
	"51	Dzagam	40.9033	45.88564	357	46",
	"51	Qasım İsmayılov	40.81243	46.25938	236	46",
	"51	Shamkhor	40.82975	46.0178	462	46",
	"52	Qarayeri	40.78674	46.31365	258	46",
	"52	Qırmızı Samux	40.93972	46.37889	99	46",
	"52	Samux	40.76485	46.40868	251	46",
	"53	Gilgilçay	41.13932	49.09038	52	46",
	"53	Kyzyl-Burun	41.07811	49.11564	34	46",
	"54	Corat	40.57176	49.70509	-15	46",
	"54	Hacı Zeynalabdin	40.62333	49.55861	-17	46",
	"54	Sumqayıt	40.58972	49.66861	-11	46",
	"55	Şuşa	39.76006	46.74989	1339	46",
	"57	Martakert	40.21127	46.82135	450	46",
	"57	Terter	40.34201	46.93161	256	46",
	"58	Çatax	40.72622	45.55919	1417	46",
	"58	Çobansığnaq	40.75244	45.70645	1341	46",
	"58	Dondar Quşçu	40.9539	45.61942	483	46",
	"58	Qaraxanlı	41.04358	45.65527	362	46",
	"58	Tovuz	40.99249	45.62838	421	46",
	"58	Yanıqlı	40.8432	45.6803	637	46",
	"59	Ujar	40.51902	47.65423	18	46",
	"60	Xaçmaz	41.46426	48.80565	47	46",
	"60	Xudat	41.63052	48.68161	45	46",
	"61	Xankandi	39.8177	46.7528	850	46",
	"62	Göygöl	40.58584	46.3189	686	46",
	"63	Altıağac	40.85785	48.9354	1080	46",
	"63	Kilyazi	40.87392	49.34376	0	46",
	"63	Şuraabad	40.8199	49.46774	-22	46",
	"63	Xızı	40.90847	49.07481	720	46",
	"64	Askyaran	39.9391	46.83161	523	46",
	"64	Xocalı	39.91297	46.79028	582	46",
	"65	Hadrut	39.52003	47.0319	733	46",
	"65	Novyy Karanlug	39.79496	47.1117	391	46",
	"65	Qırmızı Bazar	39.67669	46.95123	646	46",
	"66	Yardımlı	38.90771	48.24052	726	46",
	"67	Aran	40.62528	46.97556	53	46",
	"67	Qaramanlı	40.48135	46.99339	103	46",
	"68	Yevlakh	40.61832	47.15014	17	46",
	"69	Mincivan	39.03023	46.72329	316	46",
	"69	Zangilan	39.08371	46.65988	413	46",
	"70	Aliabad	41.4829	46.63483	262	46",
	"70	Faldarlı	41.46868	46.51579	209	46",
	"70	Mamrux	41.54243	46.767	519	46",
	"70	Qandax	41.47546	46.54128	219	46",
	"70	Zaqatala	41.6316	46.64479	503	46",
	"71	Begimli	40.25234	47.82303	-4	46",
	"71	Zardob	40.2184	47.71214	-3	46",
];
