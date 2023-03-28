const CITIES = [
	"01	Andijon	40.78206	72.34424	494	409",
	"01	Asaka	40.64153	72.23868	501	409",
	"01	Baliqchi	40.90499	71.84737	415	409",
	"01	Buloqboshi	40.62907	72.50212	649	409",
	"01	Dardoq	40.81583	72.83166	680	409",
	"01	Izboskan	41.03766	72.33659	632	409",
	"01	Jalolquduq	40.68918	72.60931	678	409",
	"01	Kuyganyor	40.85444	72.30734	458	409",
	"01	Marhamat	40.48048	72.31388	627	409",
	"01	Marhamat	40.50236	72.32646	607	409",
	"01	Oltinko‘l	40.80104	72.17306	444	409",
	"01	Oqoltin	40.74649	71.70031	405	409",
	"01	Oxunboboyev	40.71984	72.64282	682	409",
	"01	Oyim	40.81955	72.74234	631	409",
	"01	Paxtaobod	40.92936	72.49687	514	409",
	"01	Poytug‘	40.8977	72.2449	460	409",
	"01	Qorasuv	40.72782	72.88577	729	409",
	"01	Qo‘rg‘ontepa	40.73192	72.76177	709	409",
	"01	Shahrixon	40.71331	72.05706	453	409",
	"01	Sultonobod	40.76461	72.97647	782	409",
	"01	Xo‘jaobod	40.66886	72.56002	669	409",
	"01	Xonobod	40.8026	72.97499	764	409",
	"02	Bukhara	39.77472	64.42861	229	408",
	"02	Galaosiyo Shahri	39.85721	64.44641	228	408",
	"02	Gazli	40.13111	63.45713	187	408",
	"02	G’ijduvon Shahri	40.10223	64.68226	260	408",
	"02	Jondor Shaharchasi	39.7417	64.17962	211	408",
	"02	Karakul’	39.53333	63.83333	199	408",
	"02	Kogon Shahri	39.72746	64.55466	223	408",
	"02	Olot Shahri	39.415	63.80333	197	408",
	"02	Qorako‘l Shahri	39.50699	63.84884	197	408",
	"02	Qorovulbozor	39.50056	64.79361	251	408",
	"02	Qorovulbozor Shahri	39.50308	64.81142	252	408",
	"02	Romitan Shahri	39.92944	64.37944	228	408",
	"02	Shofirkon Shahri	40.12	64.50139	245	408",
	"02	Vobkent Shahri	40.00033	64.50213	237	408",
	"02	Yangibozor Qishlog’i	40.0059	64.37356	227	408",
	"03	Bag‘dod	40.46306	71.21222	419	409",
	"03	Beshariq	40.43583	70.61028	393	409",
	"03	Dang‘ara	40.58389	70.91444	393	409",
	"03	Fergana	40.38421	71.78432	580	409",
	"03	Hamza	40.42762	71.50534	443	409",
	"03	Kirguli	40.43553	71.76721	547	409",
	"03	Langar	40.5205	71.66015	453	409",
	"03	Marg‘ilon	40.47237	71.72463	494	409",
	"03	Navbahor	40.48104	70.77093	400	409",
	"03	Oltiariq	40.39194	71.47417	463	409",
	"03	Qo‘qon	40.52861	70.9425	416	409",
	"03	Quva	40.52204	72.07292	496	409",
	"03	Quvasoy	40.29721	71.98026	815	203",
	"03	Ravon	39.97724	71.13467	1151	409",
	"03	Rishton	40.35667	71.28472	479	409",
	"03	Shohimardon	39.98322	71.80512	1464	203",
	"03	Sho‘rsuv	40.28431	70.79972	597	409",
	"03	Tinchlik	40.47591	71.55089	434	409",
	"03	Toshloq	40.47722	71.76778	491	409",
	"03	Uchko‘prik	40.54222	71.06083	414	409",
	"03	Vodil	40.17424	71.73013	927	409",
	"03	Yangi Marg‘ilon	40.42722	71.71889	534	409",
	"03	Yangiqo‘rg‘on	40.55389	71.14667	405	409",
	"03	Yaypan	40.37583	70.81556	446	409",
	"03	Yozyovon	40.66139	71.74361	429	409",
	"05	Bog’ot	41.35415	60.81787	107	408",
	"05	Druzhba	41.22222	61.30667	119	408",
	"05	Gurlan	41.84123	60.39268	92	408",
	"05	Hazorasp	41.31944	61.07417	111	408",
	"05	Qorovul	41.55384	60.58232	101	408",
	"05	Qo’shko’pir	41.53275	60.34698	100	408",
	"05	Shovot	41.65817	60.29451	95	408",
	"05	Urganch	41.55339	60.62057	101	408",
	"05	Xiva	41.38555	60.36408	98	408",
	"05	Xonqa	41.47783	60.78146	104	408",
	"05	Yangiariq	41.36583	60.60438	99	408",
	"05	Yangibozor	41.71157	60.53394	99	408",
	"06	Chortoq	41.06924	71.82372	520	409",
	"06	Chortoq Shahri	41.07703	71.81772	536	409",
	"06	Chust	41.00329	71.23791	662	409",
	"06	Haqqulobod	40.91667	72.11667	438	409",
	"06	Hazratishoh	41.39465	71.78903	999	409",
	"06	Kosonsoy	41.24944	71.54738	892	409",
	"06	Kosonsoy Shahri	41.26327	71.54239	912	409",
	"06	Namangan	40.9983	71.67257	442	409",
	"06	Pop	40.87361	71.10889	440	409",
	"06	Pop Shahri	40.87642	71.1022	450	409",
	"06	To‘rqao‘rg‘on	40.99984	71.51162	556	409",
	"06	Toshbuloq	40.91617	71.57819	405	409",
	"06	Tŭragŭrghon Shahri	41.00334	71.51056	566	409",
	"06	Uchqŭrghon Shahri	41.11371	72.07915	496	409",
	"06	Uychi	41.08073	71.92331	482	409",
	"06	Yangiqo‘rg‘on	41.19474	71.72385	750	409",
	"07	Beshrabot	40.19761	65.33527	336	408",
	"07	G‘ozg‘on	40.59078	65.49466	490	408",
	"07	Karmana Shahri	40.13782	65.37545	350	408",
	"07	Konimex	40.27593	65.14511	323	408",
	"07	Navoiy	40.08444	65.37917	392	408",
	"07	Nurota	40.56139	65.68861	493	408",
	"07	Nurota Shahri	40.56762	65.67947	497	408",
	"07	Qizilcha	40.7107	66.13671	790	408",
	"07	Qiziltepa	40.03306	64.85	265	408",
	"07	Qiziltepa Shahri	40.0254	64.82885	261	408",
	"07	Tomdibuloq	41.7508	64.61711	248	408",
	"07	Uchquduq Shahri	42.15001	63.55221	200	408",
	"07	Yangirabot	40.02539	65.96095	418	408",
	"08	Beshkent	38.82139	65.65306	355	408",
	"08	Beshkent Shahri	38.81107	65.64246	353	408",
	"08	Chiroqchi	39.03361	66.57222	524	408",
	"08	Chiroqchi Shahri	39.02727	66.58083	529	408",
	"08	G‘uzor	38.62083	66.24806	524	408",
	"08	G‘uzor Shahri	38.62596	66.24515	517	408",
	"08	Kitob	39.12158	66.88605	652	408",
	"08	Kitob Shahri	39.12251	66.8757	644	408",
	"08	Koson	39.0375	65.585	347	408",
	"08	Koson Shahri	39.04472	65.59082	344	408",
	"08	Muborak	39.25528	65.15278	290	408",
	"08	Muborak Shahri	39.25778	65.15674	289	408",
	"08	Mug‘lon Shahar	38.91878	65.41217	327	408",
	"08	Nishon Tumani	38.69395	65.67512	349	408",
	"08	Qamashi Shahri	38.81998	66.46441	520	408",
	"08	Qarshi	38.86056	65.78905	383	408",
	"08	Qorashina	38.34185	66.56342	939	408",
	"08	Shahrisabz	39.05778	66.83417	631	408",
	"08	Shahrisabz Shahri	39.05206	66.82083	622	408",
	"08	Yakkabog‘ Shahri	38.97664	66.68867	587	408",
	"08	Yangi Mirishkor	38.85143	65.27789	310	408",
	"08	Yangi-Nishon Shahri	38.64501	65.68952	353	408",
	"09	Beruniy	41.69111	60.7525	101	408",
	"09	Beruniy Shahri	41.69904	60.75501	99	408",
	"09	Bo‘ston Shahri	41.84607	60.94744	96	408",
	"09	Chimboy Shahri	42.92952	59.78199	65	408",
	"09	Kegeyli Shahar	42.77667	59.60778	68	408",
	"09	Manghit	42.11556	60.05972	85	408",
	"09	Mang‘it Shahri	42.12215	60.06276	82	408",
	"09	Mo‘ynoq Shahri	43.77877	59.03039	57	408",
	"09	Mŭynoq	43.76833	59.02139	50	408",
	"09	Novyy Turtkul’	41.55	61.01667	106	408",
	"09	Nukus	42.45306	59.61028	76	408",
	"09	Oltinko‘l	43.06874	58.90372	63	408",
	"09	Oqmang‘it	42.59889	59.53444	71	408",
	"09	Qanliko‘l	42.8395	59.00093	68	408",
	"09	Qo‘ng‘irot Shahri	43.05207	58.84596	62	408",
	"09	Qorao‘zak	43.02207	60.01701	61	408",
	"09	Qozonketkan	43.01907	59.36425	63	408",
	"09	Qŭnghirot	43.04333	58.83944	60	408",
	"09	Shumanay	42.64281	58.91345	68	408",
	"09	Shumanay Shahri	42.63433	58.9306	68	408",
	"09	Taxtako‘pir	43.01171	60.30111	61	408",
	"09	To‘rtko‘l Shahri	41.56055	61.0018	108	408",
	"09	Xo‘jayli Shahri	42.40881	59.44544	75	408",
	"10	Bulung’ur Shahri	39.76003	67.27441	760	408",
	"10	Charxin	39.69413	66.827	671	408",
	"10	Chelak	39.92002	66.86228	607	408",
	"10	Dahbed	39.7644	66.91626	642	408",
	"10	Ishtixon Shahri	39.96639	66.48611	516	408",
	"10	Jomboy Shahri	39.69889	67.09333	708	408",
	"10	Juma Shahri	39.71611	66.66417	626	408",
	"10	Kattaqo’rg’on Shahri	39.90546	66.26556	486	408",
	"10	Loyish Shaharchasi	39.87904	66.75055	585	408",
	"10	Nurobod Shahri	39.60861	66.28667	491	408",
	"10	Oqtosh	39.92139	65.92528	462	408",
	"10	Oqtosh Shahri	39.92675	65.92953	460	408",
	"10	Payariq Shahri	39.99249	66.85012	614	408",
	"10	Payshamba Shahri	40.01136	66.23113	471	408",
	"10	Qo’shrabod	40.25363	66.68849	783	408",
	"10	Samarkand	39.65417	66.95972	719	408",
	"10	Toyloq Qishlog’i	39.60139	67.09083	741	408",
	"10	Urgut Shahri	39.41902	67.26118	948	408",
	"10	Ziyodin Shaharchasi	40.03106	65.66619	418	408",
	"12	Boysun	38.20835	67.20664	1240	408",
	"12	Denov	38.26746	67.89886	525	408",
	"12	Sho‘rchi	37.99944	67.7875	450	408",
	"12	Tirmiz	37.22417	67.27833	304	408",
	"13	Bektemir	41.20972	69.33417	420	409",
	"13	Tashkent	41.26465	69.21627	424	409",
	"14	Amir Timur	41.01944	68.94083	319	409",
	"14	Angren	41.01667	70.14361	932	409",
	"14	Bekobod	40.22083	69.26972	303	409",
	"14	Bo‘ka	40.81108	69.19417	341	409",
	"14	Chinoz	40.93633	68.76128	275	409",
	"14	Chirchiq	41.46889	69.58222	602	409",
	"14	G‘azalkent	41.55806	69.77083	702	409",
	"14	Iskandar	41.55389	69.70083	660	409",
	"14	Kyzyldzhar	41.56667	70.01667	1315	409",
	"14	Ohangaron	40.90639	69.63833	567	409",
	"14	Olmaliq	40.84472	69.59833	569	409",
	"14	Oqqo‘rg‘on	40.8775	69.04583	306	409",
	"14	Parkent	41.29444	69.67639	752	409",
	"14	Piskent	40.89722	69.35056	416	409",
	"14	Qibray	41.38972	69.465	534	409",
	"14	Salor	41.37222	69.38167	516	409",
	"14	Sŭqoq	41.24861	69.79667	1192	409",
	"14	Tŭytepa	41.0321	69.36253	395	409",
	"14	Ŭrtaowul	41.18667	69.14528	386	409",
	"14	Yangiobod	41.11919	70.09406	1310	409",
	"14	Yangiyŭl	41.11202	69.0471	347	409",
	"14	Zafar	40.98333	68.9	307	409",
	"15	Dashtobod	40.12694	68.49444	400	409",
	"15	Do’stlik Shahri	40.52881	68.03153	273	408",
	"15	Gagarin Shahri	40.66473	68.16768	266	408",
	"15	G’allaorol Shahri	40.02696	67.58781	571	408",
	"15	G’oliblar Qishlog’i	40.49528	67.87594	266	408",
	"15	Jizzax	40.12341	67.82842	375	408",
	"15	Paxtakor Shahri	40.31181	67.95667	306	408",
	"15	Uchtepa Qishlog’i	40.20447	67.90396	342	408",
	"15	Usmat Shaharchasi	39.73982	67.6479	1098	408",
	"15	Yangiqishloq Shaharchasi	40.41517	67.17946	542	408",
	"15	Zafarobod Shaharchasi	40.38903	67.82169	277	408",
	"15	Zarbdor Shaharchasi	40.08083	68.16454	398	408",
	"15	Zomin Shaharchasi	39.96056	68.39583	645	408",
	"16	Guliston	40.48972	68.78417	273	409",
	"16	Sirdaryo	40.84361	68.66167	263	409",
	"16	Yangiyer	40.275	68.8225	314	409",
	"	Eskiarab	40.36972	71.41861	465	409",
];