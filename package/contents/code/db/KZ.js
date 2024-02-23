const CITIES = [
	"00	Aksuat	48.71667	83.7	534	214",
	"00	Karabas	46.53333	76.2	340	214",
	"00	Kokpekty	48.75	82.4	514	214",
	"00	Sarykamys	47.78333	78.71667	544	214",
	"00	Zhumysker	49.33333	49.4	-1	220",
	"01	Bakanas	44.80595	76.27464	387	214",
	"01	Burunday	43.35567	76.85477	689	214",
	"01	Chemolgan	43.37633	76.62456	687	214",
	"01	Chundzha	43.53813	79.46582	763	214",
	"01	Esik	43.3552	77.45245	1029	214",
	"01	Kegen	43.01451	79.22638	1862	214",
	"01	Konayev	43.86681	77.06304	497	214",
	"01	Narynkol	42.72636	80.17495	1817	214",
	"01	Otegen Batyra	43.41845	77.02187	636	214",
	"01	Talghar	43.30235	77.23811	980	214",
	"01	Turgen	43.40056	77.59333	971	214",
	"01	Ülken	45.20928	73.95089	344	214",
	"01	Uzunagach	43.22259	76.31871	828	214",
	"02	Almaty	43.25	76.91667	805	214",
	"02	Pervomayka	43.37361	76.94	670	214",
	"03	Akkol	51.99374	70.94704	381	214",
	"03	Akkol’	53.29617	69.59997	261	214",
	"03	Aksu	52.44422	71.95761	278	214",
	"03	Aqmol	51.06568	70.97777	347	214",
	"03	Arshaly	50.83112	72.17995	414	214",
	"03	Astrakhanka	51.53068	69.79685	302	214",
	"03	Atbasar	51.80854	68.35823	287	214",
	"03	Atbasar	51.8	68.33333	280	214",
	"03	Balkashino	52.51779	68.7516	371	214",
	"03	Bestobe	52.49795	73.09592	174	214",
	"03	Derzhavinsk	51.09718	66.31875	227	214",
	"03	Egindiköl	51.05227	69.47511	344	214",
	"03	Esil	51.95453	66.40772	221	214",
	"03	Kokshetau	53.28333	69.4	234	214",
	"03	Koshi	50.97075	71.35311	335	214",
	"03	Krasnogorskiy	52.2456	66.52081	202	214",
	"03	Makinsk	52.6329	70.41911	380	214",
	"03	Qorghalzhyn	50.58371	70.0189	331	214",
	"03	Shantobe	52.45376	68.17475	385	214",
	"03	Shchuchinsk	52.93592	70.18895	405	214",
	"03	Shortandy	51.69934	70.99129	367	214",
	"03	Stepnogorsk	52.35062	71.88161	311	214",
	"03	Stepnyak	52.83489	70.78861	366	214",
	"03	Tasty-Taldy	50.72817	66.62033	294	214",
	"03	Yereymentau	51.62364	73.10265	392	214",
	"03	Zavodskoy	52.47031	72.01514	264	214",
	"03	Zerenda	52.90599	69.15593	384	214",
	"03	Zhaksy	51.91058	67.31665	392	214",
	"03	Zhana Kiima	51.59611	67.58944	269	214",
	"03	Zholymbet	51.74259	71.70971	307	214",
	"04	Aktobe	50.27969	57.20718	210	217",
	"04	Algha	49.89863	57.32787	252	217",
	"04	Badamsha	50.56183	58.2772	419	217",
	"04	Bayganin	48.68975	55.87512	198	217",
	"04	Embi	48.82981	58.15042	233	217",
	"04	Kandyagash	49.46917	57.41865	294	217",
	"04	Khromtau	50.25161	58.43574	416	217",
	"04	Martuk	50.74746	56.50611	176	217",
	"04	Qobda	50.14928	55.66889	145	217",
	"04	Selo Temirbeka Zhurgenova	50.43326	60.5004	273	217",
	"04	Shalqar	47.83154	59.61926	169	217",
	"04	Shubarkuduk	49.14391	56.48196	191	217",
	"04	Shubarshi	48.58022	57.18289	183	217",
	"04	Temir	49.14284	57.12736	209	217",
	"04	Uil	49.0725	54.66304	74	217",
	"04	Yrghyz	48.61958	61.26067	90	217",
	"05	Astana	51.1801	71.44598	358	214",
	"06	Akkistau	47.22107	51.0063	-8	219",
	"06	Akkol’	48.77358	53.18177	16	219",
	"06	Atyrau	47.11667	51.88333	-25	219",
	"06	Balykshi	47.06667	51.86667	-24	219",
	"06	Baychunas	47.2404	52.9403	-21	219",
	"06	Biikzhal	46.7949	54.71762	12	219",
	"06	Dossor	47.53234	52.9709	-15	219",
	"06	Inderbor	48.55	51.78333	22	219",
	"06	Karaton	46.43685	53.48905	-22	219",
	"06	Makhambet	47.67061	51.58598	-20	219",
	"06	Maloye Ganyushkino	46.6	49.26667	-24	219",
	"06	Maqat	47.64967	53.34291	-21	219",
	"06	Miyaly	48.88548	53.79168	29	219",
	"06	Qulsary	46.95307	54.01978	-14	219",
	"06	Shalkar	48.03333	48.9	-14	219",
	"07	Aqsay	51.1681	52.99782	65	220",
	"07	Burlin	51.42781	52.71076	47	220",
	"07	Chapayev	50.18888	51.16978	28	220",
	"07	Karatobe	49.68914	53.51005	48	220",
	"07	Kaztalovka	49.76702	48.6893	18	220",
	"07	Krugloozërnoye	51.08167	51.29052	33	220",
	"07	Oral	51.23333	51.36667	35	220",
	"07	Peremetnoe	51.19801	50.85291	52	220",
	"07	Saykhin	48.81441	46.76946	9	220",
	"07	Saykhin	48.85611	46.83361	3	220",
	"07	Shyngyrlau	51.09959	54.08412	119	220",
	"07	Tasqala	51.11073	50.29454	69	220",
	"07	Terekti	51.2221	51.95731	73	220",
	"07	Zhangaqala	49.21532	50.29009	10	220",
	"07	Zhanibek	49.42278	46.84626	28	220",
	"07	Zhympity	50.25645	52.59707	17	220",
	"08	Baikonur	45.61667	63.31667	91	216",
	"08	Tyuratam	45.65005	63.31163	106	216",
	"09	Bautino	44.54479	50.24629	-22	218",
	"09	Beyneu	45.31667	55.2	6	218",
	"09	Fort-Shevchenko	44.50654	50.26388	-17	218",
	"09	Kuryk	43.18032	51.68116	-11	218",
	"09	Mangistau	43.69088	51.32237	-2	218",
	"09	Munayshy	43.49988	52.09745	133	218",
	"09	Say-Utes	44.32787	53.53216	228	218",
	"09	Shetpe	44.13922	52.15305	186	218",
	"09	Shevchenko	43.64806	51.17222	-9	218",
	"09	Taūshyq	44.34678	51.34932	70	218",
	"09	Umirzak	43.59762	51.24094	-26	218",
	"09	Zhanaozen	43.34116	52.86192	204	218",
	"09	Zhetybay	43.58928	52.10313	142	218",
	"10	Abay	41.34682	68.9504	346	214",
	"10	Aksu	42.42193	69.82709	614	214",
	"10	Arys	42.43015	68.8087	239	214",
	"10	Ashchysay	43.5537	68.89792	816	214",
	"10	Asyqata	40.8946	68.3643	265	214",
	"10	Atakent	40.84782	68.50643	263	214",
	"10	Bayzhansay	43.16708	69.91459	870	214",
	"10	Chernak	43.40025	68.0237	218	214",
	"10	Kantagi	43.52786	68.58287	470	214",
	"10	Kazygurt	41.7564	69.3839	585	214",
	"10	Kentau	43.51672	68.50463	426	214",
	"10	Kokterek	42.49442	70.25478	759	214",
	"10	Lenger	42.18152	69.88582	777	214",
	"10	Myrzakent	40.66338	68.5451	269	214",
	"10	Qogham	42.82774	68.28074	195	214",
	"10	Saryaghash	41.46042	69.16791	441	214",
	"10	Sastobe	42.5533	69.99835	559	214",
	"10	Sayram	42.3025	69.75758	667	214",
	"10	Shardara	41.25832	67.96991	255	214",
	"10	Shaul’der	42.79097	68.37172	198	214",
	"10	Shayan	43.03399	69.38048	381	214",
	"10	Sholakkorgan	43.76453	69.17856	472	214",
	"10	Temirlanovka	42.59998	69.25836	291	214",
	"10	Turar Ryskulov	42.5334	70.3496	770	214",
	"10	Turkestan	43.29733	68.25175	214	214",
	"10	Tyul’kubas	42.48578	70.29601	823	214",
	"10	Zhabagly	42.43781	70.47841	1122	214",
	"10	Zhetysay	40.77631	68.32774	269	214",
	"11	Akkuly	51.46967	77.77857	130	214",
	"11	Aksu	52.04023	76.92748	123	214",
	"11	Aqtoghay	53.00888	75.98495	106	214",
	"11	Bayanaul	50.79304	75.70123	474	214",
	"11	Ekibastuz	51.72371	75.32287	203	214",
	"11	Irtyshsk	53.33365	75.45775	91	214",
	"11	Kalkaman	51.95349	76.02723	122	214",
	"11	Koktobe	51.52983	77.47146	131	214",
	"11	Leninskiy	52.25346	76.78211	109	214",
	"11	Mayqayyng	51.45981	75.80232	260	214",
	"11	Pavlodar	52.28333	76.96667	133	214",
	"11	Sharbaqty	52.49087	78.15556	148	214",
	"11	Terengköl	53.06649	76.10489	97	214",
	"11	Uspenka	52.90727	77.41813	107	214",
	"11	Zhelezinka	53.5388	75.31326	92	214",
	"12510143	Aksuat	47.76124	82.80858	543	214",
	"12510143	Aqtoghay	46.95068	79.67621	366	214",
	"12510143	Auezov	49.71003	81.58018	402	214",
	"12510143	Ayagoz	47.96447	80.43437	665	214",
	"12510143	Besqaraghay	50.88671	79.48229	221	214",
	"12510143	Boko	49.05632	81.63721	590	214",
	"12510143	Borodulikha	50.71841	80.9295	316	214",
	"12510143	Kalbatau	49.33009	81.57275	414	214",
	"12510143	Karaaul	48.94509	79.25502	622	214",
	"12510143	Kokpekty	48.7553	82.38617	526	214",
	"12510143	Kurchatov	50.75617	78.54188	165	214",
	"12510143	Novaya Shūl’ba	50.53978	81.32882	298	214",
	"12510143	Semey	50.42675	80.26669	211	214",
	"12510143	Shar	49.5872	81.04883	339	214",
	"12510143	Suykbulak	49.70837	81.04854	363	214",
	"12510143	Zhezkent	50.93112	81.3615	283	214",
	"12510144	Balpyk Bi	44.90115	78.22933	576	214",
	"12510144	Druzhba	45.25332	82.48044	424	214",
	"12510144	Karabulak	44.90881	78.49044	760	214",
	"12510144	Lepsy	46.23426	78.94034	400	214",
	"12510144	Matay	45.8996	78.72039	413	214",
	"12510144	Mulaly	45.45055	78.31481	454	214",
	"12510144	Sarqant	45.41322	79.91713	770	214",
	"12510144	Saryozek	44.36178	77.97279	932	214",
	"12510144	Taldykorgan	45.01556	78.37389	596	214",
	"12510144	Tekeli	44.86136	78.77287	1037	214",
	"12510144	Tekeli	44.8678	78.72807	990	214",
	"12510144	Usharal	46.16926	80.94331	397	214",
	"12510144	Ushtobe	45.25258	77.98284	433	214",
	"12510144	Zhansugurov	45.39743	79.50345	631	214",
	"12510144	Zharkent	44.16619	80.00736	636	214",
	"12510145	Qarazhal	48.01085	70.80058	469	214",
	"12510145	Satpayev	47.90409	67.54112	427	214",
	"12510145	Ulytau	48.65504	67.00586	636	214",
	"12510145	Zhangaarqa	48.68659	71.64469	487	214",
	"12510145	Zhezqazghan	47.78746	67.71118	369	214",
	"12	Abay	49.63539	72.86523	500	214",
	"12	Aksu-Ayuly	48.76788	73.67272	729	214",
	"12	Aktas	49.77952	72.96128	558	214",
	"12	Aktau	48.03333	72.83333	765	214",
	"12	Aktau	50.23466	73.06662	503	214",
	"12	Aktogay	48.16667	75.3	753	214",
	"12	Aktogay	48.31636	74.98293	785	214",
	"12	Aqadyr	48.26014	72.85851	693	214",
	"12	Aqshataū	47.98917	74.0575	751	214",
	"12	Balqash	46.84546	74.98213	372	214",
	"12	Botaqara	50.05928	73.71524	523	214",
	"12	Dolinka	49.67685	72.67822	491	214",
	"12	Dzhambul	47.20618	71.39496	610	214",
	"12	Gülshat	46.62973	74.35586	375	214",
	"12	Karagandy	49.80187	73.10211	545	214",
	"12	Koktal	49.65	73.51667	552	214",
	"12	Kushoky	50.23091	73.40146	516	214",
	"12	Kyzylzhar	49.98197	72.60761	468	214",
	"12	Moyynty	47.21968	73.35437	578	214",
	"12	Novodolinskiy	49.7065	72.70807	484	214",
	"12	Nura	50.26159	71.54802	397	214",
	"12	Osakarovka	50.56315	72.57278	493	214",
	"12	Ozernyy	46.80714	75.036	342	214",
	"12	Prigorodnoye	49.69244	75.58438	678	214",
	"12	Priozersk	46.03106	73.70247	358	214",
	"12	Qarqaraly	49.41244	75.47228	849	214",
	"12	Saran	49.80245	72.83186	476	214",
	"12	Saryshaghan	46.11805	73.61336	357	214",
	"12	Sayaq	47	77.26667	593	214",
	"12	Shakhan	49.81958	72.65407	478	214",
	"12	Shakhtinsk	49.70713	72.59321	504	214",
	"12	Shubarköl	48.88222	68.80722	442	214",
	"12	Temirtau	50.05197	72.95497	514	214",
	"12	Tokarevka	50.11573	73.16034	492	214",
	"12	Verkhniye Kayrakty	48.68333	73.28333	803	214",
	"12	Zharyk	48.85692	72.83598	655	214",
	"13	Amangeldi	50.18271	65.18966	138	216",
	"13	Arkalyk	50.25031	66.90384	332	216",
	"13	Auliyekol'	52.3585	64.13429	138	216",
	"13	Ayat	52.83554	62.52078	168	216",
	"13	Borovskoy	53.7927	64.18268	175	216",
	"13	Denisovka	52.44772	61.74942	228	216",
	"13	Fyodorov	53.63809	62.69653	196	216",
	"13	Karasu	52.65995	65.48421	206	216",
	"13	Kostanay	53.21435	63.62463	167	216",
	"13	Lisakovsk	52.54488	62.49893	198	216",
	"13	Obaghan	53.07952	64.29521	190	216",
	"13	Oktyabr'	52.11106	65.67578	248	216",
	"13	Qamysty	51.96382	61.78641	262	216",
	"13	Qarabalyq	53.75019	62.0584	190	216",
	"13	Qaramengdi	51.65708	64.22535	219	216",
	"13	Qashar	53.36799	62.86839	197	216",
	"13	Qusmuryn	52.45144	64.61682	109	216",
	"13	Rudnyy	52.97244	63.11055	158	216",
	"13	Sarykol'	53.31891	65.53923	223	216",
	"13	Tobol	52.69366	62.5914	207	216",
	"13	Tobyl	53.20666	63.70038	138	216",
	"13	Torghay	49.63072	63.49035	102	216",
	"13	Troyebratskiy	54.44306	66.07982	161	216",
	"13	Uzunkol'	54.03782	65.3354	174	216",
	"13	Yul’yevka	52.11775	64.27539	141	216",
	"13	Zhitikara	52.19019	61.19894	271	216",
	"14	Aral	46.80174	61.66312	61	215",
	"14	Belköl	44.81384	65.58778	125	215",
	"14	Kazalinsk	45.76257	62.10334	57	215",
	"14	Kyzylorda	44.85278	65.50917	128	215",
	"14	Novokazalinsk	45.84806	62.15254	69	215",
	"14	Saksaul’skiy	47.08152	61.15239	77	215",
	"14	Shalqīya	44.00947	67.41062	235	215",
	"14	Shiyeli	44.17057	66.73376	152	215",
	"14	Tasbuget	44.77018	65.55461	128	215",
	"14	Terenozek	45.05048	64.98258	123	215",
	"14	Zhalagash	45.07958	64.68175	116	215",
	"14	Zhangaqorghan	43.90652	67.24637	166	215",
	"14	Zhosaly	45.48778	64.07806	100	215",
	"1537272	Shymkent	42.3	69.6	513	214",
	"15	Altay	49.73626	84.25416	460	214",
	"15	Altayskiy	50.24593	82.36252	380	214",
	"15	Asubulak	49.54026	82.99471	609	214",
	"15	Belogorskiy	49.47887	83.14138	1023	214",
	"15	Belousovka	50.13287	82.52481	365	214",
	"15	Glubokoye	50.13887	82.31114	277	214",
	"15	Kurchum	48.56603	83.66146	427	214",
	"15	Maleyevsk	49.81441	84.29102	433	214",
	"15	Marqaköl	48.42648	85.73474	618	214",
	"15	Novaya Bukhtarma	49.62873	83.52102	406	214",
	"15	Ognyovka	49.68368	83.01687	369	214",
	"15	Pervorossiyskoye	49.71739	83.8486	431	214",
	"15	Qasym Qaysenov	49.87386	82.49485	334	214",
	"15	Ridder	50.34524	83.51562	725	214",
	"15	Samarskoye	49.02247	83.36634	529	214",
	"15	Shemonaikha	50.62899	81.91092	300	214",
	"15	Tughyl	47.72497	84.20585	403	214",
	"15	Ul’ba	50.26581	83.37804	631	214",
	"15	Ulken Naryn	49.21245	84.50758	403	214",
	"15	Urzhar	47.09302	81.62939	479	214",
	"15	Ust-Kamenogorsk	49.97143	82.60586	287	214",
	"15	Ūst’-Talovka	50.55058	81.84847	275	214",
	"15	Zaysan	47.46657	84.87144	635	214",
	"15	Zhalghyztobe	49.21094	81.21596	453	214",
	"16	Arykbalyk	52.95625	68.20185	394	214",
	"16	Birlestik	53.58414	68.35382	234	214",
	"16	Bishkul	54.77763	69.09951	103	214",
	"16	Bulayevo	54.90596	70.44155	130	214",
	"16	Būrabay	53.08382	70.31379	321	214",
	"16	Kishkenekol’	53.63589	72.34079	135	214",
	"16	Leningradskoye	53.53319	71.54252	127	214",
	"16	Mamlyutka	54.93896	68.53889	131	214",
	"16	Novoishimskiy	53.19806	66.76944	184	214",
	"16	Novoishimskoye	53.2035	66.81431	174	214",
	"16	Petropavl	54.86667	69.15	142	214",
	"16	Presnovka	54.6693	67.14912	143	214",
	"16	Saumalkol’	53.2927	68.105	297	214",
	"16	Sergeyevka	53.88139	67.40882	149	214",
	"16	Smirnovo	54.5148	69.42732	135	214",
	"16	Taiynsha	53.84796	69.76773	155	214",
	"16	Talshik	53.63736	71.87404	75	214",
	"16	Tayynsha	53.84665	69.75987	158	214",
	"16	Timiryazevo	53.74947	66.48852	170	214",
	"16	Volodarskoye	52.66119	66.59684	189	214",
	"16	Vozvyshenka	54.4354	70.94224	124	214",
	"16	Yavlenka	54.34525	68.4574	132	214",
	"17	Akbakay	45.1294	72.67169	480	214",
	"17	Asa	43.03735	71.14737	511	214",
	"17	Bauyrzhan Momyshuly	42.61419	70.76975	1075	214",
	"17	Chiganak	44.83056	70.00194	217	214",
	"17	Granitogorsk	42.744	73.46848	1059	214",
	"17	Karatau	43.17959	70.4592	525	214",
	"17	Khantau	44.22627	73.7941	546	214",
	"17	Korday	43.03882	74.71287	624	214",
	"17	Kulan	42.91018	72.71571	727	214",
	"17	Lugovoy	42.94197	72.76098	687	214",
	"17	Merke	42.87183	73.19648	687	214",
	"17	Moyynkum	44.28314	72.94369	338	214",
	"17	Mynaral	45.44344	73.65453	341	214",
	"17	Oytal	42.90573	73.26972	675	214",
	"17	Sarykemer	43.00929	71.5101	538	214",
	"17	Shu	43.60507	73.76221	461	214",
	"17	Taraz	42.9	71.36667	623	214",
	"17	Zhangatas	43.56274	69.73209	501	214",
];
