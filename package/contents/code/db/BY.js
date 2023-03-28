const CITIES = [
	"01	Antopal’	52.2038	24.7863	150	80",
	"01	Asnyezhytsy	52.1891	26.1299	140	80",
	"01	Baranovichi	53.1327	26.0139	199	80",
	"01	Brest	52.09755	23.68775	142	80",
	"01	Byaroza	52.5314	24.9786	150	80",
	"01	Byelaazyorsk	52.4731	25.1784	148	80",
	"01	Charnawchytsy	52.21948	23.74043	141	80",
	"01	Damachava	51.75	23.6	150	80",
	"01	Davyd-Haradok	52.0566	27.2161	130	80",
	"01	Drahichyn	52.1874	25.1597	151	80",
	"01	Hantsavichy	52.758	26.43	160	80",
	"01	Haradzishcha	53.3247	26.0107	201	80",
	"01	Horad Kobryn	52.21611	24.36639	139	80",
	"01	Horad Luninyets	52.25028	26.79944	136	80",
	"01	Horad Pinsk	52.12139	26.07278	138	80",
	"01	Ivanava	52.1451	25.5365	148	80",
	"01	Ivatsevichy	52.709	25.3401	155	80",
	"01	Kamyanyets	52.40013	23.81	141	80",
	"01	Kamyanyuki	52.55757	23.80525	146	80",
	"01	Kazhan-Haradok	52.2073	27.0094	131	80",
	"01	Kobryn	52.2138	24.3564	140	80",
	"01	Kosava	52.7583	25.1554	164	80",
	"01	Lahishyn	52.339	25.9867	171	80",
	"01	Luninyets	52.2472	26.8047	139	80",
	"01	Lyakhavichy	53.0388	26.2656	181	80",
	"01	Malaryta	51.7905	24.074	157	80",
	"01	Mikashevichy	52.2173	27.476	128	80",
	"01	Motal’	52.3138	25.6072	140	80",
	"01	Nyakhachava	52.644	25.2027	148	80",
	"01	Pinsk	52.1229	26.0951	139	80",
	"01	Pruzhany	52.556	24.4573	161	80",
	"01	Ruzhany	52.86322	24.89357	149	80",
	"01	Skoki	52.15519	23.6329	133	80",
	"01	Stalovichy	53.2142	26.0377	192	80",
	"01	Stolin	51.89115	26.84597	139	80",
	"01	Tsyelyakhany	52.5175	25.8429	152	80",
	"01	Vysokaye	52.37091	23.37083	151	80",
	"01	Zhabinka	52.1984	24.0115	140	80",
	"01	Znamenka	51.88168	23.65545	147	80",
	"02	Aktsyabrski	52.644	28.8801	132	80",
	"02	Brahin	51.787	30.2677	113	80",
	"02	Buda-Kashalyova	52.7179	30.5701	147	80",
	"02	Chachersk	52.9164	30.9179	146	80",
	"02	Dobrush	52.42671	31.31219	125	80",
	"02	Dowsk	53.1571	30.4601	167	80",
	"02	Homyel'	52.4345	30.9754	138	80",
	"02	Horad Rechytsa	52.36389	30.39472	129	80",
	"02	Kalinkavichy	52.1323	29.3257	122	80",
	"02	Karanyowka	52.3506	31.1121	137	80",
	"02	Karma	53.1301	30.8016	155	80",
	"02	Kastsyukowka	52.5387	30.9173	138	80",
	"02	Khal’ch	52.5643	31.1364	135	80",
	"02	Khoyniki	51.8911	29.9552	128	80",
	"02	Loyew	51.9458	30.7953	132	80",
	"02	Lyel’chytsy	51.7862	28.3288	139	80",
	"02	Mazyr	52.0495	29.2456	152	80",
	"02	Narowlya	51.7961	29.5004	114	80",
	"02	Novaya Huta	52.1032	30.9837	133	80",
	"02	Parychy	52.8042	29.4176	135	80",
	"02	Peramoga	52.3973	31.071	124	80",
	"02	Pyetrykaw	52.1289	28.4921	137	80",
	"02	Rahachow	53.0934	30.0495	143	80",
	"02	Rechytsa	52.3617	30.3916	128	80",
	"02	Sasnovy Bor	52.5194	29.5988	136	80",
	"02	Svyetlahorsk	52.6329	29.7389	142	80",
	"02	Turaw	52.0683	27.735	125	80",
	"02	Vasilyevichy	52.2512	29.8288	137	80",
	"02	Vyetka	52.5591	31.1794	125	80",
	"02	Yel’sk	51.8141	29.1522	142	80",
	"02	Zhlobin	52.8926	30.024	139	80",
	"02	Zhytkavichy	52.2168	27.8561	137	80",
	"03	Ashmyany	54.421	25.936	175	80",
	"03	Astravyets	54.61378	25.95537	161	80",
	"03	Azyory	53.7216	24.1836	118	80",
	"03	Baruny	54.3171	26.1376	230	80",
	"03	Byarozawka	53.72406	25.49709	124	80",
	"03	Byelagruda	53.80128	25.16711	144	80",
	"03	Dyatlovo	53.4631	25.4068	163	80",
	"03	Hal’shany	54.2585	26.0144	202	80",
	"03	Hrodna	53.6884	23.8258	139	80",
	"03	Hyeranyony	54.1159	25.5773	183	80",
	"03	Indura	53.4605	23.8823	142	80",
	"03	Iwye	53.9299	25.7727	145	80",
	"03	Karelichy	53.5648	26.1406	149	80",
	"03	Korobchicy	53.61198	23.74841	128	80",
	"03	Krasnosel’skiy	53.26494	24.42398	127	80",
	"03	Kreva	54.3118	26.2916	224	80",
	"03	Lida	53.88333	25.29972	144	80",
	"03	Lyubcha	53.7522	26.0603	139	80",
	"03	Mir	53.4544	26.467	170	80",
	"03	Mosty	53.4122	24.5387	118	80",
	"03	Novogrudok	53.5942	25.8191	309	80",
	"03	Ostryna	53.7322	24.5305	138	80",
	"03	Ross’	53.28411	24.40721	132	80",
	"03	Sapotskin	53.8329	23.6598	148	80",
	"03	Shchorsy	53.6344	26.1855	139	80",
	"03	Shchuchyn	53.6014	24.7465	176	80",
	"03	Skidel’	53.5904	24.2478	113	80",
	"03	Slonim	53.0869	25.3163	149	80",
	"03	Smarhoń	54.4798	26.3957	153	80",
	"03	Soly	54.51301	26.19381	150	80",
	"03	Svislach	53.03474	24.09829	168	80",
	"03	Traby	54.1587	25.9075	168	80",
	"03	Turets	53.5263	26.3125	170	80",
	"03	Vishnyeva	54.7102	26.5228	158	80",
	"03	Volkovysk	53.1561	24.4513	146	80",
	"03	Voranava	54.1492	25.3112	172	80",
	"03	Vselyub	53.72136	25.79894	181	80",
	"03	Vyalikaya Byerastavitsa	53.196	24.0166	148	80",
	"03	Zalyessye	54.4192	26.548	148	80",
	"03	Zel’va	53.15064	24.81338	139	80",
	"03	Zhaludok	53.5974	24.9828	134	80",
	"03	Zhirovichi	53.0131	25.3443	149	80",
	"04	Minsk	53.9	27.56667	222	80",
	"05	Astrashytski Haradok	54.0651	27.695	223	80",
	"05	Atolina	53.7817	27.4346	228	80",
	"05	Azyartso	53.8397	27.3917	249	80",
	"05	Bal’shavik	54.0036	27.5669	226	80",
	"05	Barysaw	54.2279	28.505	172	80",
	"05	Bierazino	53.8391	28.9879	164	80",
	"05	Blon’	53.5269	28.1732	164	80",
	"05	Bobr	54.342	29.2736	176	80",
	"05	Bol’shoye Stiklevo	53.8693	27.7005	212	80",
	"05	Borovlyany	54.0022	27.6754	234	80",
	"05	Budsław	54.7985	27.4132	178	80",
	"05	Červień	53.7059	28.4313	167	80",
	"05	Charkasy	53.7662	27.3347	227	80",
	"05	Chyrvonaya Slabada	52.8522	27.1698	157	80",
	"05	Chyst’	54.2698	27.1067	187	80",
	"05	Druzhny	53.6238	27.8977	173	80",
	"05	Dukora	53.6786	27.94	174	80",
	"05	Dzyarzhynsk	53.6832	27.138	193	80",
	"05	Enyerhyetykaw	53.5871	27.0535	183	80",
	"05	Fanipol	53.74998	27.33338	220	80",
	"05	Gorodishche	53.9833	27.8384	218	80",
	"05	Haradzyeya	53.3121	26.538	180	80",
	"05	Hatava	53.7829	27.6407	193	80",
	"05	Horad Zhodzina	54.0985	28.3331	171	80",
	"05	Hotsk	52.5215	27.1385	140	80",
	"05	Iĺja	54.4167	27.2958	183	80",
	"05	Ivyanyets	53.8864	26.7432	197	80",
	"05	Kalodzishchy	53.944	27.7823	242	80",
	"05	Kapyl’	53.1516	27.0913	220	80",
	"05	Khatsyezhyna	53.9094	27.3069	257	80",
	"05	Kholopenichi	54.51746	28.95645	190	80",
	"05	Klyetsk	53.0635	26.6321	181	80",
	"05	Korolëv Stan	53.9865	27.7982	210	80",
	"05	Krasnaye	54.2438	27.0758	184	80",
	"05	Krupki	54.3178	29.1374	174	80",
	"05	Kryvichy	54.7132	27.2886	173	80",
	"05	Lahoysk	54.2064	27.8512	192	80",
	"05	Loshnitsa	54.2796	28.7649	176	80",
	"05	Luhavaya Slabada	53.7823	27.8434	181	80",
	"05	Lyasny	54.0072	27.6963	246	80",
	"05	Lyeskawka	54.0024	27.7108	250	80",
	"05	Lyuban’	52.7985	28.0048	138	80",
	"05	Machulishchy	53.7788	27.5948	215	80",
	"05	Maladziečna	54.3167	26.854	161	80",
	"05	Mar’’ina Horka	53.509	28.147	178	80",
	"05	Michanovichi	53.73937	27.69276	193	80",
	"05	Myadzyel	54.8789	26.9371	164	80",
	"05	Narach	54.5652	26.7314	156	80",
	"05	Narach	54.9102	26.708	170	80",
	"05	Nasilava	54.30441	26.78209	183	80",
	"05	Natal’yewsk	53.7275	28.4325	177	80",
	"05	Novosel’ye	53.9162	27.2009	303	80",
	"05	Novy Svyerzhan’	53.4542	26.7301	148	80",
	"05	Nyasvizh	53.2189	26.6779	182	80",
	"05	Nyehorelaye	53.6104	27.0733	181	80",
	"05	Ostrovy	53.7335	28.3857	176	80",
	"05	Pahost	53.8482	29.1491	162	80",
	"05	Paplavy	53.8066	28.8698	171	80",
	"05	Plyeshchanitsy	54.4235	27.8301	211	80",
	"05	Prawdzinski	53.5248	27.8303	177	80",
	"05	Pryvol’ny	53.7969	27.7967	194	80",
	"05	Puchavičy	53.5297	28.2467	160	80",
	"05	Pyatryshki	54.0686	27.2179	239	80",
	"05	Radaškovičy	54.1554	27.2412	196	80",
	"05	Rakaw	53.9674	27.0562	212	80",
	"05	Rudawka	53.2351	26.6494	181	80",
	"05	Rudzyensk	53.5983	27.8621	176	80",
	"05	Šack	53.4307	27.6953	178	80",
	"05	Salihorsk	52.7876	27.5415	157	80",
	"05	Samakhvalavichy	53.7396	27.5037	207	80",
	"05	Sarachy	52.7867	28.0186	140	80",
	"05	Schomyslitsa	53.8211	27.4522	242	80",
	"05	Slabada	54.0087	27.8866	205	80",
	"05	Slutsk	53.0274	27.5597	150	80",
	"05	Smaliavičy	54.0249	28.0894	175	80",
	"05	Smilavičy	53.7496	28.0115	180	80",
	"05	Snow	53.2201	26.401	187	80",
	"05	Stan’kava	53.6292	27.229	186	80",
	"05	Starobin	52.7267	27.4606	146	80",
	"05	Staryya Darohi	53.0402	28.267	160	80",
	"05	Stowbtsy	53.4785	26.7434	164	80",
	"05	Svir	54.8517	26.395	153	80",
	"05	Svislach	53.6404	27.9199	175	80",
	"05	Syenitsa	53.8313	27.5343	209	80",
	"05	Syomkava	54.0101	27.441	220	80",
	"05	Tarasovo	53.9253	27.3815	238	80",
	"05	Tsimkavichy	53.0672	26.9902	171	80",
	"05	Turets-Bayary	54.3785	26.6581	146	80",
	"05	Urechcha	52.9479	27.893	146	80",
	"05	Usiazh	54.07598	28.00698	190	80",
	"05	Uzda	53.4627	27.2137	177	80",
	"05	Valer’yanovo	53.9698	27.6685	233	80",
	"05	Valozhyn	54.0892	26.5266	203	80",
	"05	Valyevachy	53.7534	28.1555	178	80",
	"05	Vilyeyka	54.4914	26.9111	157	80",
	"05	Vishnyavyets	53.3474	26.6895	173	80",
	"05	Vyaliki Trastsyanets	53.851	27.7139	203	80",
	"05	Yubilyeyny	53.8191	27.5215	217	80",
	"05	Yukhnovka	53.9753	27.8586	200	80",
	"05	Zabalotstsye	54.0052	28.0272	193	80",
	"05	Zamostochye	53.8198	27.8685	190	80",
	"05	Zaslawye	54.0114	27.2695	226	80",
	"05	Zhdanovichy	53.9432	27.425	216	80",
	"05	Zyalyony Bor	54.0119	28.4843	173	80",
	"05	Zyembin	54.3579	28.2207	181	80",
	"05	Октябрьский	54.04059	28.19813	185	80",
	"06	Asipovichy	53.3011	28.6386	157	80",
	"06	Babruysk	53.1384	29.2214	159	80",
	"06	Buynichy	53.8536	30.2671	171	80",
	"06	Byalynichy	53.9994	29.7141	182	80",
	"06	Bykhaw	53.521	30.2454	155	80",
	"06	Chavusy	53.8098	30.9717	176	80",
	"06	Cherykaw	53.5689	31.3831	167	80",
	"06	Dashkawka	53.7352	30.2625	159	80",
	"06	Drybin	54.12063	31.09037	168	80",
	"06	Halowchyn	54.0601	29.9184	180	80",
	"06	Haradzishcha	54.1893	30.6231	168	80",
	"06	Harbavichy	53.8183	30.7001	169	80",
	"06	Hlusha	53.0868	28.8567	169	80",
	"06	Hlusk	52.903	28.6845	144	80",
	"06	Horad Krychaw	53.69889	31.71417	156	80",
	"06	Horki	54.2862	30.9863	182	80",
	"06	Kadino	53.88389	30.52028	179	80",
	"06	Kamyennyya Lavy	54.0898	30.2962	186	80",
	"06	Khodosy	53.92681	31.47882	202	80",
	"06	Khotsimsk	53.4086	32.578	161	80",
	"06	Kirawsk	53.2693	29.4752	162	80",
	"06	Kličaŭ	53.4923	29.3356	154	80",
	"06	Klimavichy	53.6079	31.9586	174	80",
	"06	Knyazhytsy	53.9747	30.1513	178	80",
	"06	Komsyenichy	54.1503	29.8794	185	80",
	"06	Kostyukovichi	53.35488	32.05128	181	80",
	"06	Krasnapollye	53.33578	31.40065	165	80",
	"06	Krasnyy Bereg	53.3291	30.1929	147	80",
	"06	Kruhlaye	54.2497	29.7968	195	80",
	"06	Krychaw	53.69571	31.71233	154	80",
	"06	Lotva	54.1013	30.2639	202	80",
	"06	Mahilyow	53.9168	30.3449	184	80",
	"06	Mastok	53.9794	30.4592	197	80",
	"06	Mscislau	54.0185	31.7217	203	80",
	"06	Myazhysyatki	53.7776	30.1765	170	80",
	"06	Myshkavichy	53.2172	29.512	157	80",
	"06	Novosëlki	53.813	30.3769	158	80",
	"06	Novoye Pashkovo	53.9567	30.2496	183	80",
	"06	Palykavichy Pyershyya	53.9854	30.36	156	80",
	"06	Posëlok Voskhod	53.7766	30.3497	159	80",
	"06	Ramanavichy	53.8653	30.5597	176	80",
	"06	Ryasno, Рясно, Расна	53.7115	30.6176	167	80",
	"06	Shklow	54.2131	30.2877	158	80",
	"06	Slawharad	53.4429	31.0014	158	80",
	"06	Tatarka	53.2533	28.8193	159	80",
	"06	Veyno	53.83333	30.38333	173	80",
	"06	Vishow	53.9805	29.9925	191	80",
	"06	Vyalikaya Mashchanitsa	53.9541	29.6255	174	80",
	"06	Yalizava	53.3994	29.0048	151	80",
	"06	Николаевка-2	53.95295	30.38278	196	80",
	"07	Asvieja	56.0147	28.11049	140	80",
	"07	Balbasava	54.4207	30.2909	202	80",
	"07	Baran’	54.4784	30.3159	162	80",
	"07	Braslaw	55.6413	27.0418	139	80",
	"07	Byahoml’	54.7316	28.0577	181	80",
	"07	Chashniki	54.8584	29.1608	136	80",
	"07	Dokshytsy	54.8918	27.7667	204	80",
	"07	Druja	55.7906	27.4505	110	80",
	"07	Dubrowna	54.5716	30.691	182	80",
	"07	Dzisna	55.5676	28.2076	113	80",
	"07	Gorodok	55.4624	29.98451	190	80",
	"07	Hlybokaye	55.1384	27.6905	159	80",
	"07	Horad Orsha	54.51528	30.40528	179	80",
	"07	Kokhanava	54.4611	30.0018	216	80",
	"07	Konstantinovo	54.6593	29.2684	176	80",
	"07	Kopys’	54.3221	30.2897	150	80",
	"07	Lyepyel’	54.8814	28.699	165	80",
	"07	Lyntupy	55.0516	26.3103	211	80",
	"07	Lyozna	55.0247	30.797	188	80",
	"07	Mosar	55.2232	27.4609	143	80",
	"07	Myezhava	54.6274	30.3082	202	80",
	"07	Myory	55.6222	27.6281	146	80",
	"07	Navapolatsk	55.5318	28.5987	131	80",
	"07	Novolukoml’	54.66192	29.15016	175	80",
	"07	Opsa	55.5359	26.8238	163	80",
	"07	Orsha	54.5081	30.4172	159	80",
	"07	Pastavy	55.11676	26.83263	140	80",
	"07	Polatsk	55.4879	28.7856	129	80",
	"07	Rasony	55.9058	28.8135	150	80",
	"07	Senno	54.81318	29.70651	163	80",
	"07	Sharkawshchyna	55.3689	27.4686	129	80",
	"07	Shumilina	55.2985	29.6121	146	80",
	"07	Smolyany	54.5969	30.071	205	80",
	"07	Surazh	55.4092	30.7246	149	80",
	"07	Talachyn	54.4087	29.6955	199	80",
	"07	Ushachy	55.179	28.6158	148	80",
	"07	Vidzy	55.3945	26.6305	140	80",
	"07	Vitebsk	55.1904	30.2049	150	80",
	"07	Vyerkhnyadzvinsk	55.7777	27.9389	108	80",
	"07	Yazna	55.4255	28.157	130	80",
];