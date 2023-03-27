const CITIES = [
	"01	Gaigeturi	33.46444	126.31833	8	211",
	"01	Jeju City	33.50972	126.52194	19	211",
	"01	Seogwipo	33.25333	126.56181	69	211",
	"03	Beonam	35.53236	127.54372	253	211",
	"03	Changsu	35.64842	127.51523	411	211",
	"03	Chilbo	35.60319	126.99342	31	211",
	"03	Daesan	35.34168	126.60327	44	211",
	"03	Donggye	35.44168	127.24264	94	211",
	"03	Gangjin	35.53034	127.16357	136	211",
	"03	Gongeum	35.37825	126.51141	27	211",
	"03	Gunsan	35.97861	126.71139	14	211",
	"03	Gurim	35.4536	127.10232	202	211",
	"03	Gwanchon	35.67463	127.27065	223	211",
	"03	Haeri	35.46144	126.53914	19	211",
	"03	Hamyeol	36.07595	126.96405	7	211",
	"03	Iksan	35.94389	126.95444	16	211",
	"03	Imsil	35.61306	127.27944	233	211",
	"03	Ingye	35.41261	127.14135	115	211",
	"03	Jeongeup	35.60004	126.91699	53	211",
	"03	Jeonju	35.82194	127.14889	44	211",
	"03	Jinan-gun	35.79167	127.42528	295	211",
	"03	Kimje	35.80167	126.88889	18	211",
	"03	Koch'ang	35.43333	126.7	44	211",
	"03	Nangen	35.41	127.38583	103	211",
	"03	Puan	35.72806	126.73194	18	211",
	"03	Sangha	35.44487	126.49517	21	211",
	"03	Sannae	35.56782	127.03012	208	211",
	"03	Sanseo	35.58362	127.39679	153	211",
	"03	Seolcheon	36.009	127.7901	294	211",
	"03	Seongsu	35.6309	127.33344	186	211",
	"03	Simwon	35.52448	126.55107	12	211",
	"03	Ssangchi	35.50202	127.00283	230	211",
	"03	Wanju	35.84509	127.14752	56	211",
	"03	Yongan	36.11962	126.95283	21	211",
	"05	Annae	36.39435	127.66031	87	211",
	"05	Annam	36.3568	127.67282	86	211",
	"05	Cheongju-si	36.63722	127.48972	49	211",
	"05	Cheongsan	36.34655	127.79366	118	211",
	"05	Cheongseong	36.3272	127.75978	121	211",
	"05	Chinch'ŏn	36.85667	127.44333	69	211",
	"05	Chungju	36.97666	127.9287	85	211",
	"05	Chupungnyeong	36.21712	127.9919	219	211",
	"05	Dongi	36.2844	127.6199	107	211",
	"05	Gunbuk	36.33055	127.53366	96	211",
	"05	Gunseo	36.27887	127.52689	118	211",
	"05	Haksan	36.0976	127.6844	143	211",
	"05	Hoenam	36.44445	127.58033	93	211",
	"05	Hwanggan	36.2324	127.9083	163	211",
	"05	Iwon	36.24613	127.61964	113	211",
	"05	Koesan	36.81083	127.79472	116	211",
	"05	Okcheon	36.3012	127.568	97	211",
	"05	Samseung	36.397	127.73201	157	211",
	"05	Simcheon	36.23734	127.72248	109	211",
	"05	Yeongdong	36.175	127.77639	130	211",
	"05	Yonghwa	36.0213	127.7665	270	211",
	"05	Yongsan	36.2603	127.8285	151	211",
	"06	Bangsan	38.2088	127.95028	257	211",
	"06	Cheorwon	38.20917	127.2175	194	211",
	"06	Chuncheon	37.87472	127.73417	92	211",
	"06	Dongmyeon	38.20135	128.04327	293	211",
	"06	Dongnae	37.84747	127.76164	99	211",
	"06	Gangdong	37.72899	128.95419	28	211",
	"06	Gangneung	37.75266	128.87239	77	211",
	"06	Gujeong	37.71904	128.8799	45	211",
	"06	Gwanin	38.15921	127.24935	182	211",
	"06	Haean	38.28634	128.13774	434	211",
	"06	Hongch’ŏn	37.6918	127.8857	137	211",
	"06	Hwacheon	38.10705	127.70632	115	211",
	"06	Jumunjin	37.89139	128.82583	9	211",
	"06	Kosong	38.37881	128.4676	17	211",
	"06	Neietsu	37.18447	128.46821	208	211",
	"06	Pyeongchang	37.37028	128.39306	300	211",
	"06	Santyoku	37.44056	129.17083	23	211",
	"06	Seoseok	37.7119	128.18713	325	211",
	"06	Sindong	37.81735	127.71656	114	211",
	"06	Sokcho	38.20701	128.59181	20	211",
	"06	T’aebaek	37.1759	128.9889	691	211",
	"06	Tonghae	37.54389	129.10694	24	211",
	"06	Toseong	38.25679	128.55968	9	211",
	"06	Wŏnju	37.35139	127.94528	133	211",
	"06	Yanggu	38.10583	127.98944	192	211",
	"10	Busan	35.10168	129.03004	15	211",
	"10	Dongnae	35.20159	129.08477	11	211",
	"10	Gijang	35.24417	129.21389	21	211",
	"10	Ilgwang	35.264	129.23349	7	211",
	"10	Jangan	35.31296	129.24244	18	211",
	"11	Paripark	37.53497	126.87661	14	211",
	"11	Seoul	37.566	126.9784	38	211",
	"11	Yongsan-dong	37.5445	126.9837	85	211",
	"12	Bupyeong	37.50533	126.72202	15	211",
	"12	Ganghwa-gun	37.74722	126.48556	15	211",
	"12	Gyodong	37.78272	126.28117	16	211",
	"12	Hajeom	37.77419	126.41226	30	211",
	"12	Incheon	37.45646	126.70515	43	211",
	"12	Samsan	37.70306	126.32136	11	211",
	"12	Seogeom-ri	37.71871	126.23304	18	211",
	"12	Seonwon	37.71223	126.48439	27	211",
	"12	Yangsa	37.79872	126.408	22	211",
	"13	Ansan-si	37.32361	126.82194	15	211",
	"13	Anseong	37.01083	127.27028	37	211",
	"13	Anyang-si	37.3925	126.92694	52	211",
	"13	Beobwon	37.84902	126.87533	53	211",
	"13	Bucheon-si	37.49889	126.78306	14	211",
	"13	Cheongpyeong	37.7355	127.4174	44	211",
	"13	Gapyeong	37.83101	127.51059	67	211",
	"13	Goyang-si	37.65639	126.835	19	211",
	"13	Gunpo	37.3675	126.94694	42	211",
	"13	Guri-si	37.5986	127.1394	31	211",
	"13	Gwangjeok	37.82566	126.98349	99	211",
	"13	Gwangju	37.41	127.25722	48	211",
	"13	Gwangmyeong	37.47722	126.86639	30	211",
	"13	Gwangtan	37.78055	126.85004	35	211",
	"13	Hanam	37.54	127.20556	33	211",
	"13	Haseong	37.71953	126.63107	26	211",
	"13	Hwado	37.6525	127.3075	86	211",
	"13	Hwaseong-si	37.20682	126.8169	19	211",
	"13	Icheon-si	37.27917	127.4425	68	211",
	"13	Jangheung	37.71727	126.94122	92	211",
	"13	Jeongok	38.02596	127.07021	66	211",
	"13	Jinjeop	37.72722	127.18992	72	211",
	"13	Munsan	37.85944	126.785	21	211",
	"13	Namyangju	37.63667	127.21417	63	211",
	"13	Onam	37.69834	127.20579	78	211",
	"13	Osan	37.15222	127.07056	22	211",
	"13	Paju	37.83278	126.81694	33	211",
	"13	Pubal	37.29167	127.50778	55	211",
	"13	Seongnam-si	37.43861	127.13778	80	211",
	"13	Sinseo	38.18561	127.10819	95	211",
	"13	Songhae	37.7636	126.46577	20	211",
	"13	Su-dong	37.70353	127.3258	71	211",
	"13	Suwon	37.29111	127.00889	58	211",
	"13	Tanhyeon	37.8024	126.71598	29	211",
	"13	Tongjin	37.69191	126.59855	27	211",
	"13	Uijeongbu-si	37.7415	127.0474	50	211",
	"13	Wabu	37.58972	127.22028	38	211",
	"13	Wolgot	37.71646	126.55429	17	211",
	"13	Yangju	37.83311	127.06169	76	211",
	"13	Yangp'yŏng	37.48972	127.49056	38	211",
	"13	Yeoju	37.29583	127.63389	50	211",
	"13	Yeoncheon	38.10113	127.07727	60	211",
	"14	Andong	36.56636	128.72275	103	211",
	"14	Cheongha	36.19797	129.33911	47	211",
	"14	Cheongsong gun	36.43351	129.057	197	211",
	"14	Eisen	35.9675	128.93083	85	211",
	"14	Eisen	36.82167	128.63083	145	211",
	"14	Gampo	35.80538	129.5011	13	211",
	"14	Gimcheon	36.12176	128.11981	81	211",
	"14	Gumi	36.1136	128.336	63	211",
	"14	Guryongpo	35.98994	129.55377	7	211",
	"14	Gyeongju	35.84278	129.21167	45	211",
	"14	Gyeongsan-si	35.82333	128.73778	59	211",
	"14	Hayang	35.91333	128.82	57	211",
	"14	Heunghae	36.10945	129.34517	22	211",
	"14	Hwanam	36.44874	127.90601	208	211",
	"14	Jenzan	36.24083	128.2975	48	211",
	"14	Kunwi	36.23472	128.57278	95	211",
	"14	Mungyeong	36.59458	128.19946	78	211",
	"14	Mungyeong	36.73528	128.10833	169	211",
	"14	Ocheon	35.97046	129.41222	22	211",
	"14	Pohang	36.02917	129.36481	5	211",
	"14	Sangju	36.41528	128.16056	61	211",
	"14	Singwang	36.12911	129.2636	82	211",
	"14	Waegwan	35.99251	128.39785	33	211",
	"14	Yecheon	36.6574	128.45514	92	211",
	"14	Yeongdeok	36.41366	129.37	17	211",
	"14	Yeonil	35.99526	129.35162	4	211",
	"15	Daegu	35.87028	128.59111	45	211",
	"15	Hwawŏn	35.80167	128.50083	36	211",
	"15	Hyeonpung	35.69557	128.44608	29	211",
	"16	Apae	34.86689	126.31279	6	211",
	"16	Baeksu	35.28401	126.42038	34	211",
	"16	Bannam	34.90444	126.65175	30	211",
	"16	Beolgyo	34.84897	127.34052	8	211",
	"16	Beopseong	35.3627	126.4462	10	211",
	"16	Bonggang	35.0117	127.58128	55	211",
	"16	Bongnae	34.89322	127.13128	116	211",
	"16	Boseong	34.77148	127.07996	162	211",
	"16	Bulgap	35.20946	126.50768	32	211",
	"16	Byeollyang	34.87479	127.45159	18	211",
	"16	Changpyeong	35.23904	127.01792	73	211",
	"16	Cheongpung	34.87676	126.97029	94	211",
	"16	Daema	35.30183	126.57748	36	211",
	"16	Damyang	35.31889	126.98389	49	211",
	"16	Deokjin	34.81951	126.69688	10	211",
	"16	Dongbok	35.07	127.13028	144	211",
	"16	Donggang	34.78006	127.33384	18	211",
	"16	Dongmyeon	35.03069	127.03837	91	211",
	"16	Dopo	34.84601	126.64367	17	211",
	"16	Geumjeong	34.86348	126.74895	50	211",
	"16	Gunnam	35.24032	126.4528	12	211",
	"16	Gunseo	35.25851	126.47516	19	211",
	"16	Gwangyang	34.9414	127.69569	24	211",
	"16	Gyeombaek	34.82987	127.15181	125	211",
	"16	Haebo	35.18122	126.60102	36	211",
	"16	Haeje	35.11073	126.29458	16	211",
	"16	Haenam	34.57111	126.59889	39	211",
	"16	Haeryong	34.91406	127.53764	10	211",
	"16	Hancheolli	34.97411	127.00028	85	211",
	"16	Hongnong	35.39587	126.44531	36	211",
	"16	Hwasun	35.06125	126.98746	75	211",
	"16	Hwayang	34.70846	127.6134	11	211",
	"16	Illo	34.85258	126.48952	30	211",
	"16	Imja	35.08457	126.11105	8	211",
	"16	Iyang	34.88953	126.98778	78	211",
	"16	Jangheung	34.68164	126.90694	28	211",
	"16	Jangseong	35.29778	126.78444	70	211",
	"16	Jido	35.06132	126.20753	24	211",
	"16	Jinsang	35.02117	127.71976	23	211",
	"16	Jinwol	34.9791	127.75807	7	211",
	"16	Joseong	34.80915	127.24754	19	211",
	"16	Juam	35.07733	127.23496	71	211",
	"16	Kurye	35.20944	127.46444	46	211",
	"16	Kwangyang	34.97528	127.58917	16	211",
	"16	Miryeok	34.80134	127.08749	135	211",
	"16	Mokpo	34.81282	126.39181	48	211",
	"16	Muan	34.99014	126.47899	21	211",
	"16	Mundeok	34.92966	127.17236	146	211",
	"16	Myoryang	35.25755	126.54315	35	211",
	"16	Nagwol	35.20248	126.13757	10	211",
	"16	Naju	35.0292	126.7175	25	211",
	"16	Nammyeon	35.00782	127.09621	119	211",
	"16	Nasan	35.11447	126.60908	27	211",
	"16	Nodong	34.79802	127.07073	143	211",
	"16	Oeseo	34.9142	127.27727	211	211",
	"16	Okgok	34.9903	127.69875	19	211",
	"16	Ongnyong	35.01766	127.61925	37	211",
	"16	Palgeum	34.78566	126.14288	14	211",
	"16	Sangsa	34.93944	127.45523	21	211",
	"16	Seji	34.92007	126.7494	35	211",
	"16	Seungju	35.01532	127.3897	141	211",
	"16	Sijong	34.86886	126.60706	11	211",
	"16	Sinan	34.8262	126.10863	3	211",
	"16	Sinan	34.83394	126.35133	30	211",
	"16	Songgwang	34.97504	127.26377	140	211",
	"16	Sora	34.79346	127.63243	21	211",
	"16	Suncheon	34.9505	127.48784	19	211",
	"16	Yeomsan	35.21831	126.37194	11	211",
	"16	Yeongam	34.80059	126.69669	34	211",
	"16	Yeonggwang	35.27814	126.51181	44	211",
	"16	Yeosu	34.76062	127.66215	10	211",
	"16	Yuchi	34.80247	126.83899	85	211",
	"16	Yulchon	34.88231	127.57861	7	211",
	"16	Yureo	34.87102	127.18702	129	211",
	"17	Asan	36.78361	127.00417	27	211",
	"17	Biin	36.14029	126.603	25	211",
	"17	Boryeong	36.34931	126.59772	11	211",
	"17	Buyeo	36.27472	126.90906	19	211",
	"17	Cheonan	36.8065	127.1522	40	211",
	"17	Cheongnam	36.35339	126.95233	16	211",
	"17	Cheongyang	36.45156	126.80365	97	211",
	"17	Gongju	36.45556	127.12472	23	211",
	"17	Gunbuk	36.1678	127.5274	179	211",
	"17	Gyuam	36.27549	126.88418	28	211",
	"17	Hongseong	36.6009	126.665	31	211",
	"17	Jangpyeong	36.3414	126.893	21	211",
	"17	Kinzan	36.10306	127.48889	160	211",
	"17	Nonsan	36.20389	127.08472	16	211",
	"17	Sangwol	36.2948	127.1409	29	211",
	"17	Seonghwan	36.91556	127.13139	38	211",
	"17	Seosan	36.78167	126.45222	33	211",
	"17	Taesal-li	36.9714	126.4542	13	211",
	"17	Tangjin	36.89444	126.62972	20	211",
	"17	Yesan	36.67756	126.84272	23	211",
	"17	Yŏnmu	36.12944	127.1	35	211",
	"18	Gwangju	35.15472	126.91556	47	211",
	"18	Masan	35.12725	126.83149	18	211",
	"19	Daejeon	36.34913	127.38493	58	211",
	"19	Jinjam	36.30029	127.31719	77	211",
	"19	Sintansin	36.45361	127.43111	40	211",
	"19	Songgangdong	36.43387	127.37587	184	211",
	"19	Yuseong	36.35389	127.33667	52	211",
	"20	Baekjeon	35.55344	127.63557	299	211",
	"20	Byeonggok	35.53064	127.68155	230	211",
	"20	Changnyeong	35.54145	128.49506	66	211",
	"20	Changwon	35.22806	128.68111	27	211",
	"20	Chinju	35.19278	128.08472	33	211",
	"20	Daehap	35.61365	128.47165	43	211",
	"20	Geumseong	34.96449	127.79025	6	211",
	"20	Goseong	34.97631	128.32361	14	211",
	"20	Hadong	35.068	127.75147	5	211",
	"20	Jeongnyang	35.08337	127.77696	23	211",
	"20	Kimhae	35.23417	128.88111	13	211",
	"20	Kyosai	34.85028	128.58861	11	211",
	"20	Mijo	34.7128	128.04605	6	211",
	"20	Miryang	35.49333	128.74889	14	211",
	"20	Naesŏ	35.24972	128.52	62	211",
	"20	Nammyeon	34.77247	127.88668	36	211",
	"20	Oepo	34.94036	128.71665	14	211",
	"20	Sangju	34.72423	127.98521	16	211",
	"20	Seosang	35.68185	127.68774	416	211",
	"20	Sinhyeon	34.8825	128.62667	14	211",
	"20	Ungsang	35.40611	129.16861	101	211",
	"20	Yangsan	35.34199	129.03358	6	211",
	"21	Ulsan	35.53722	129.31667	10	211",
	"22	Sejong	36.59245	127.29223	49	211",
];
