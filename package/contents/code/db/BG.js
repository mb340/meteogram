const CITIES = [
	"38	Bansko	41.8383	23.48851	929	52",
	"38	Belitsa	41.95694	23.5725	966	52",
	"38	Blagoevgrad	42.01667	23.1	390	52",
	"38	Garmen	41.6	23.81667	589	52",
	"38	Gotse Delchev	41.56667	23.73333	535	52",
	"38	Hadzhidimovo	41.52222	23.86861	462	52",
	"38	Kolarovo	41.36385	23.10669	396	52",
	"38	Kresna	41.73333	23.15	316	52",
	"38	Petrich	41.39846	23.20702	185	52",
	"38	Razlog	41.8863	23.46714	829	52",
	"38	Rupite	41.44245	23.24168	98	52",
	"38	Sandanski	41.56667	23.28333	246	52",
	"38	Satovcha	41.61667	23.98333	994	52",
	"38	Simitli	41.88333	23.11667	280	52",
	"38	Stara Kresna	41.8	23.18333	561	52",
	"38	Strumyani	41.63333	23.2	130	52",
	"38	Yakoruda	42.02528	23.68417	1028	52",
	"39	Aheloy	42.64987	27.64838	25	52",
	"39	Ahtopol	42.09768	27.93961	24	52",
	"39	Aytos	42.7	27.25	89	52",
	"39	Bata	42.73802	27.49643	206	52",
	"39	Burgas	42.50606	27.46781	36	52",
	"39	Chernomorets	42.44408	27.63902	29	52",
	"39	Kameno	42.57084	27.29875	20	52",
	"39	Karnobat	42.65	26.98333	208	52",
	"39	Kiten	42.23424	27.7749	26	52",
	"39	Malko Tarnovo	41.97958	27.52477	346	52",
	"39	Nesebar	42.65921	27.73602	17	52",
	"39	Obzor	42.81998	27.88007	27	52",
	"39	Pomorie	42.56326	27.62986	6	52",
	"39	Primorsko	42.26791	27.75611	21	52",
	"39	Ravda	42.64185	27.67713	13	52",
	"39	Ruen	42.8	27.28333	205	52",
	"39	Sarafovo	42.56079	27.52195	30	52",
	"39	Sozopol	42.41801	27.6956	20	52",
	"39	Sredets	42.34747	27.17898	25	52",
	"39	Sungurlare	42.76667	26.78333	206	52",
	"39	Sveti Vlas	42.7136	27.75867	47	52",
	"39	Tsarevo	42.16955	27.84541	36	52",
	"40	Balchik	43.42166	28.15848	191	52",
	"40	Dobrich	43.56667	27.83333	214	52",
	"40	General Toshevo	43.70123	28.03787	228	52",
	"40	Kavarna	43.43601	28.33953	129	52",
	"40	Kranevo	43.34157	28.05759	33	52",
	"40	Krushari	43.81675	27.75552	198	52",
	"40	Shabla	43.53983	28.53429	30	52",
	"40	Spasovo	43.70168	28.30399	100	52",
	"40	Tervel	43.74789	27.40911	237	52",
	"41	Dryanovo	42.97897	25.4785	256	52",
	"41	Gabrovo	42.87472	25.33417	538	52",
	"41	Sevlievo	43.02583	25.11361	195	52",
	"41	Tryavna	42.86667	25.5	488	52",
	"42	Buhovo	42.76667	23.56667	702	52",
	"42	Sofia	42.69751	23.32415	562	52",
	"43	Dimitrovgrad	42.05	25.6	111	52",
	"43	Harmanli	41.93333	25.9	74	52",
	"43	Haskovo	41.93415	25.55557	195	52",
	"43	Ivaylovgrad	41.52672	26.1249	178	52",
	"43	Lyubimets	41.83333	26.08333	68	52",
	"43	Madzharovo	41.63461	25.86439	171	52",
	"43	Mineralni Bani	41.91667	25.35	342	52",
	"43	Simeonovgrad	42.03333	25.83333	104	52",
	"43	Stambolovo	41.76667	25.65	309	52",
	"43	Svilengrad	41.76667	26.2	58	52",
	"43	Topolovgrad	42.08333	26.33333	328	52",
	"44	Ardino	41.58333	25.13333	602	52",
	"44	Dzhebel	41.49566	25.30363	321	52",
	"44	Gabrovo	41.8	25.26667	654	52",
	"44	Kardzhali	41.65	25.36667	278	52",
	"44	Kirkovo	41.32715	25.36379	346	52",
	"44	Krumovgrad	41.47127	25.65485	224	52",
	"45	Boboshevo	42.15296	23.00146	376	52",
	"45	Bobov Dol	42.36256	23.00324	653	52",
	"45	Borovets	42.10566	23.02003	389	52",
	"45	Dupnitsa	42.26667	23.11667	512	52",
	"45	Kocherinovo	42.08439	23.0571	407	52",
	"45	Kyustendil	42.28389	22.69111	519	52",
	"45	Nevestino	42.25551	22.85175	448	52",
	"45	Porominovo	42.07641	23.08592	426	52",
	"45	Rila	42.13333	23.13333	621	52",
	"45	Sapareva Banya	42.28333	23.26667	855	52",
	"46	Apriltsi	42.84142	24.91759	511	52",
	"46	Letnitsa	43.31167	25.07333	72	52",
	"46	Lovech	43.13333	24.71667	179	52",
	"46	Lukovit	43.2	24.16667	136	52",
	"46	Teteven	42.91667	24.26667	419	52",
	"46	Troyan	42.89427	24.71589	389	52",
	"46	Ugarchin	43.1	24.41667	267	52",
	"46	Yablanitsa	43.03139	24.11278	487	52",
	"47	Berkovitsa	43.23581	23.12738	406	52",
	"47	Boychinovtsi	43.47222	23.33583	105	52",
	"47	Brusartsi	43.66075	23.06732	99	52",
	"47	Chiprovtsi	43.38417	22.88083	487	52",
	"47	Georgi Damyanovo	43.38611	23.03056	246	52",
	"47	Lom	43.82106	23.23677	41	52",
	"47	Medkovets	43.62403	23.16876	170	52",
	"47	Montana	43.4125	23.225	148	52",
	"47	Valchedram	43.69281	23.44518	80	52",
	"47	Varshets	43.19356	23.2868	394	52",
	"47	Yakimovo	43.63472	23.3535	106	52",
	"48	Batak	41.94225	24.21843	1036	52",
	"48	Belovo	42.21239	24.02081	347	52",
	"48	Bratsigovo	42.01667	24.36667	572	52",
	"48	Lesichovo	42.35626	24.1119	293	52",
	"48	Panagyurishte	42.49518	24.19021	518	52",
	"48	Pazardzhik	42.2	24.33333	213	52",
	"48	Peshtera	42.03372	24.29995	440	52",
	"48	Rakitovo	41.99012	24.0873	815	52",
	"48	Sarnitsa	41.73835	24.02435	1215	52",
	"48	Septemvri	42.21138	24.12946	244	52",
	"48	Strelcha	42.5	24.31667	511	52",
	"48	Velingrad	42.02754	23.99155	750	52",
	"49	Batanovtsi	42.59692	22.95634	665	52",
	"49	Breznik	42.74085	22.90723	747	52",
	"49	Pernik	42.6	23.03333	712	52",
	"49	Radomir	42.54565	22.96553	680	52",
	"49	Tran	42.83528	22.65167	697	52",
	"49	Zemen	42.47889	22.74917	600	52",
	"50	Belene	43.64594	25.12627	29	52",
	"50	Cherven Bryag	43.27884	24.08251	116	52",
	"50	Dolna Mitropolia	43.46667	24.53333	57	52",
	"50	Dolni Dabnik	43.4	24.43333	109	52",
	"50	Gulyantsi	43.64109	24.69368	37	52",
	"50	Iskar	43.45	24.26667	110	52",
	"50	Iskar	43.6708	24.45233	50	52",
	"50	Knezha	43.5	24.08333	116	52",
	"50	Koynare	43.35	24.13333	83	52",
	"50	Levski	43.36667	25.13333	73	52",
	"50	Nikopol	43.70528	24.89521	34	52",
	"50	Pleven	43.41667	24.61667	97	52",
	"50	Pordim	43.38333	24.85	182	52",
	"50	Slavyanovo	43.46667	24.86667	135	52",
	"51	Asenovgrad	42.01667	24.86667	226	52",
	"51	Brezovo	42.35	25.08333	249	52",
	"51	Hisarya	42.5	24.7	364	52",
	"51	Kalofer	42.61667	24.98333	731	52",
	"51	Kaloyanovo	42.35	24.73333	219	52",
	"51	Karlovo	42.63333	24.8	406	52",
	"51	Klisura	42.7	24.45	772	52",
	"51	Krichim	42.05	24.46667	228	52",
	"51	Laki	41.85	24.81667	944	52",
	"51	Parvomay	42.1	25.21667	134	52",
	"51	Perushtitsa	42.05	24.55	407	52",
	"51	Plovdiv	42.15	24.75	169	52",
	"51	Rakovski	42.27408	24.94083	176	52",
	"51	Sadovo	42.13178	24.93999	153	52",
	"51	Saedinenie	42.26667	24.55	203	52",
	"51	Stamboliyski	42.13333	24.53333	188	52",
	"51	Topolovo	41.9	25	471	52",
	"51	Zelenikovo	42.4	25.08333	305	52",
	"52	Gorichevo	43.85	26.45	136	52",
	"52	Isperih	43.71667	26.83333	279	52",
	"52	Kubrat	43.79658	26.50063	234	52",
	"52	Loznitsa	43.36667	26.6	265	52",
	"52	Medovene	43.76667	26.51667	210	52",
	"52	Razgrad	43.53333	26.51667	197	52",
	"52	Samuil	43.51667	26.75	432	52",
	"52	Tochilari	43.85	26.46667	147	52",
	"52	Tsar Kaloyan	43.61667	26.25	209	52",
	"52	Zavet	43.76036	26.68063	264	52",
	"53	Borovo	43.50086	25.80992	286	52",
	"53	Dve Mogili	43.59258	25.87486	238	52",
	"53	Ivanovo	43.68568	25.95565	180	52",
	"53	Ruse	43.84872	25.9534	39	52",
	"53	Senovo	43.65	26.36667	210	52",
	"53	Slivo Pole	43.94248	26.20464	27	52",
	"53	Tsenovo	43.53588	25.65764	46	52",
	"53	Vetovo	43.7	26.26667	194	52",
	"54	Gara Hitrino	43.43333	26.91667	332	52",
	"54	Kaolinovo	43.61667	27.11667	266	52",
	"54	Kaspichan	43.31667	27.16667	95	52",
	"54	Nikola-Kozlevo	43.56667	27.23333	310	52",
	"54	Novi Pazar	43.35	27.2	135	52",
	"54	Pliska	43.36667	27.11667	160	52",
	"54	Shumen	43.27064	26.92286	237	52",
	"54	Smyadovo	43.06667	27.01667	86	52",
	"54	Varbitsa	43	26.63333	279	52",
	"54	Veliki Preslav	43.16667	26.81667	146	52",
	"54	Venets	43.55	26.93333	349	52",
	"55	Alfatar	43.94525	27.28751	156	52",
	"55	Dulovo	43.81667	27.15	226	52",
	"55	Glavinitsa	43.91667	26.83333	108	52",
	"55	Kaynardzha	43.99278	27.50713	80	52",
	"55	Silistra	44.1171	27.26056	25	52",
	"55	Sitovo	44.0273	27.01982	116	52",
	"55	Tutrakan	44.04906	26.61206	56	52",
	"56	Kermen	42.5	26.25	169	52",
	"56	Kotel	42.88333	26.45	494	52",
	"56	Nova Zagora	42.48333	26.01667	130	52",
	"56	Sliven	42.68583	26.32917	271	52",
	"56	Tvarditsa	42.7	25.9	350	52",
	"57	Banite	41.61667	25.01667	728	52",
	"57	Borino	41.68408	24.293	1149	52",
	"57	Chepelare	41.73333	24.68333	1162	52",
	"57	Devin	41.74327	24.40003	723	52",
	"57	Dospat	41.64462	24.15857	1221	52",
	"57	Gyovren	41.66326	24.37557	1026	52",
	"57	Madan	41.49869	24.93973	682	52",
	"57	Nedelino	41.45602	25.08008	497	52",
	"57	Rudozem	41.48751	24.84945	693	52",
	"57	Smolyan	41.57439	24.71204	907	52",
	"57	Zlatograd	41.3795	25.09605	435	52",
	"58	Anton	42.75	24.28333	1174	52",
	"58	Botevgrad	42.9	23.78333	363	52",
	"58	Bov	43.0325	23.37806	818	52",
	"58	Bozhurishte	42.75	23.2	568	52",
	"58	Chavdar	42.65	24.05	591	52",
	"58	Chelopech	42.7	24.08333	716	52",
	"58	Dolna Banya	42.3	23.76667	672	52",
	"58	Dragoman	42.92191	22.93109	723	52",
	"58	Elin Pelin	42.66667	23.6	549	52",
	"58	Etropole	42.83333	24	535	52",
	"58	Godech	43.01682	23.04852	699	52",
	"58	Gorna Malina	42.68333	23.7	647	52",
	"58	Ihtiman	42.43333	23.81667	636	52",
	"58	Koprivshtitsa	42.63333	24.35	1098	52",
	"58	Kostinbrod	42.81667	23.21667	534	52",
	"58	Lakatnik	43.05	23.4	811	52",
	"58	Mirkovo	42.7	23.98333	725	52",
	"58	Pirdop	42.7	24.18333	675	52",
	"58	Pravets	42.88333	23.91667	519	52",
	"58	Samokov	42.337	23.5528	945	52",
	"58	Slivnitsa	42.85182	23.03792	591	52",
	"58	Svoge	42.96667	23.35	455	52",
	"58	Zlatitsa	42.71667	24.13333	692	52",
	"59	Asen	42.65	25.2	470	52",
	"59	Bratya Daskalovi	42.3	25.21667	227	52",
	"59	Chirpan	42.2	25.33333	195	52",
	"59	Elkhovo	42.57572	25.74801	354	52",
	"59	Gŭlŭbovo	42.13333	25.85	144	52",
	"59	Gurkovo	42.66667	25.8	375	52",
	"59	Kazanlak	42.61667	25.4	366	52",
	"59	Maglizh	42.6	25.55	353	52",
	"59	Nikolaevo	42.63333	25.8	277	52",
	"59	Opan	42.21667	25.7	171	52",
	"59	Pavel Banya	42.6	25.2	411	52",
	"59	Radnevo	42.3	25.93333	116	52",
	"59	Shipka	42.71667	25.33333	692	52",
	"59	Stara Zagora	42.43278	25.64194	205	52",
	"60	Antonovo	43.15	26.16667	481	52",
	"60	Omurtag	43.1	26.41667	559	52",
	"60	Opaka	43.45	26.16667	224	52",
	"60	Popovo	43.35	26.23333	190	52",
	"60	Targovishte	43.2512	26.57215	186	52",
	"61	Aksakovo	43.25615	27.82105	118	52",
	"61	Asparuhovo	43.18067	27.88823	38	52",
	"61	Avren	43.11667	27.66667	285	52",
	"61	Balgarevo	43.40296	28.41189	91	52",
	"61	Beloslav	43.1896	27.70429	16	52",
	"61	Bliznatsi	43.06795	27.86744	56	52",
	"61	Byala	42.87426	27.88865	74	52",
	"61	Dalgopol	43.05	27.35	34	52",
	"61	Devnya	43.22222	27.56944	70	52",
	"61	Dolni Chiflik	42.99296	27.71596	27	52",
	"61	Kiten	43.08333	27.31667	219	52",
	"61	Provadia	43.18333	27.43333	173	52",
	"61	Suvorovo	43.33058	27.59908	182	52",
	"61	Valchidol	43.4	27.55	265	52",
	"61	Varna	43.21667	27.91667	54	52",
	"61	Vetrino	43.31667	27.43333	211	52",
	"61	Zlatni Pyasatsi	43.285	28.0418	24	52",
	"62	Byala Cherkva	43.2	25.3	105	52",
	"62	Debelets	43.03333	25.61667	158	52",
	"62	Elena	42.93333	25.88333	308	52",
	"62	Gorna Oryahovitsa	43.12778	25.70167	146	52",
	"62	Kilifarevo	42.98333	25.63333	268	52",
	"62	Lyaskovets	43.11111	25.72833	174	52",
	"62	Parvomaytsi	43.15	25.65	94	52",
	"62	Pavlikeni	43.24278	25.32194	157	52",
	"62	Polski Trambesh	43.37233	25.63525	50	52",
	"62	Strazhitsa	43.23333	25.96667	107	52",
	"62	Suhindol	43.19167	25.18111	269	52",
	"62	Svishtov	43.61875	25.35033	74	52",
	"62	Veliko Tŭrnovo	43.08124	25.62904	207	52",
	"62	Zlataritsa	43.05	25.9	130	52",
	"63	Belogradchik	43.62722	22.68361	498	52",
	"63	Boynitsa	43.9565	22.53255	285	52",
	"63	Bregovo	44.15167	22.6425	54	52",
	"63	Chuprene	43.51806	22.66611	423	52",
	"63	Dimovo	43.74167	22.72694	128	52",
	"63	Dunavtsi	43.92111	22.82111	41	52",
	"63	Gramada	43.83738	22.65279	189	52",
	"63	Kula	43.88833	22.52139	281	52",
	"63	Makresh	43.76794	22.66406	176	52",
	"63	Novo Selo	44.16214	22.78376	49	52",
	"63	Ruzhintsi	43.62179	22.83286	188	52",
	"63	Vidin	43.99159	22.88236	41	52",
	"64	Borovan	43.43333	23.75	189	52",
	"64	Byala Slatina	43.46667	23.93333	125	52",
	"64	Hayredin	43.60193	23.66135	54	52",
	"64	Kozloduy	43.77864	23.72058	41	52",
	"64	Krivodol	43.37444	23.48444	158	52",
	"64	Mezdra	43.15	23.7	277	52",
	"64	Mizia	43.68623	23.85371	34	52",
	"64	Oryahovo	43.73618	23.96052	114	52",
	"64	Roman	43.15	23.91667	221	52",
	"64	Vratsa	43.21	23.5625	352	52",
	"65	Bolyarovo	42.14962	26.81116	190	52",
	"65	Elhovo	42.16667	26.56667	118	52",
	"65	Straldzha	42.6	26.68333	149	52",
	"65	Yambol	42.48333	26.5	132	52",
];
