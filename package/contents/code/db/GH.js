const CITIES = [
	"01	Accra	5.55602	-0.1969	33	164",
	"01	Adenta	5.71417	-0.15418	58	164",
	"01	Amanfrom	5.53532	-0.39827	74	164",
	"01	Ashaiman	5.69951	-0.03484	23	164",
	"01	Atsiaman	5.69775	-0.32824	45	164",
	"01	Awoshi	5.58385	-0.27787	20	164",
	"01	Dome	5.65003	-0.2361	35	164",
	"01	Gbawe	5.57692	-0.31038	31	164",
	"01	Lashibi	5.68476	-0.04011	24	164",
	"01	Mandela	5.55221	-0.33912	75	164",
	"01	Medina Estates	5.6658	-0.16307	86	164",
	"01	New Achimota	5.62657	-0.25807	59	164",
	"01	Nungua	5.60105	-0.07713	28	164",
	"01	Sakumona	5.62135	-0.05193	15	164",
	"01	Taifa	5.65825	-0.25223	74	164",
	"01	Tema	5.6698	-0.01657	27	164",
	"01	Tema New Town	5.65396	0.0264	20	164",
	"01	Teshi Old Town	5.58365	-0.10722	13	164",
	"02	Agogo	6.80004	-1.08193	418	164",
	"02	Ahwiaa	6.76051	-1.59402	309	164",
	"02	Bekwai	6.45195	-1.57866	219	164",
	"02	Effiduase	6.84684	-1.39612	328	164",
	"02	Ejura	7.38558	-1.35617	224	164",
	"02	Konongo	6.61667	-1.21667	230	164",
	"02	Kumasi	6.68848	-1.62443	270	164",
	"02	Mampong	7.06273	-1.4001	395	164",
	"02	Mamponteng	6.73333	-1.55	274	164",
	"02	New Tafo	6.71897	-1.61188	277	164",
	"02	Obuase	6.20228	-1.66796	215	164",
	"02	Sefwi	6.52306	-1.63596	220	164",
	"02	Tafo	6.73156	-1.6137	292	164",
	"04	Apam	5.28483	-0.73711	12	164",
	"04	Assin Foso	5.7	-1.65	107	164",
	"04	Buduburam	5.52314	-0.47718	62	164",
	"04	Cape Coast	5.10535	-1.2466	21	164",
	"04	Dunkwa	5.95996	-1.77792	125	164",
	"04	Elmina	5.0847	-1.35093	21	164",
	"04	Foso	5.70119	-1.28657	148	164",
	"04	Kasoa	5.53449	-0.41679	18	164",
	"04	Mankesim	5.2717	-1.0152	21	164",
	"04	Mumford	5.26176	-0.75897	33	164",
	"04	Saltpond	5.20913	-1.06058	14	164",
	"04	Swedru	5.53711	-0.69984	74	164",
	"04	Winneba	5.35113	-0.62313	25	164",
	"05	Aburi	5.84802	-0.17449	447	164",
	"05	Akim Oda	5.92665	-0.98577	132	164",
	"05	Akim Swedru	5.8938	-1.01636	140	164",
	"05	Akropong	5.97462	-0.08542	454	164",
	"05	Akwatia	6.04024	-0.80876	138	164",
	"05	Asamankese	5.86006	-0.6635	147	164",
	"05	Begoro	6.38706	-0.37738	460	164",
	"05	Kade	6.09392	-0.83599	144	164",
	"05	Kibi	6.16494	-0.55376	318	164",
	"05	Koforidua	6.09408	-0.25913	172	164",
	"05	Mpraeso	6.59321	-0.73462	477	164",
	"05	Nkawkaw	6.54584	-0.76264	254	164",
	"05	Nsawam	5.80893	-0.35026	61	164",
	"05	Odumase Krobo	6.53333	-0.81667	214	164",
	"05	Suhum	6.04089	-0.45004	182	164",
	"06	Bimbila	8.85488	0.05922	212	164",
	"06	Kpandae	8.46885	-0.01127	183	164",
	"06	Savelugu	9.62441	-0.8253	169	164",
	"06	Tamale	9.40079	-0.8393	196	164",
	"06	Yendi	9.44272	-0.00991	208	164",
	"08	Aflao	6.11982	1.19012	9	164",
	"08	Akatsi	6.1316	0.79853	55	164",
	"08	Anloga	5.79473	0.89728	6	164",
	"08	Dzodze	6.23669	0.99578	55	164",
	"08	Ho	6.60084	0.4713	171	164",
	"08	Hohoe	7.15181	0.47362	173	164",
	"08	Keta	5.91793	0.98789	0	164",
	"08	Kpandu	6.99536	0.29306	153	164",
	"09	Aboso	5.36073	-1.94856	92	164",
	"09	Esim	4.86641	-2.24181	8	164",
	"09	Prestea	5.43385	-2.14295	54	164",
	"09	Sekondi	4.93422	-1.71454	7	164",
	"09	Sekondi-Takoradi	4.92678	-1.75773	6	164",
	"09	Shama Junction	5.01806	-1.66437	29	164",
	"09	Takoradi	4.89816	-1.76029	10	164",
	"09	Tarkwa	5.30383	-1.98956	86	164",
	"09	Wassa-Akropong	5.78722	-2.08361	86	164",
	"10	Bawku	11.0616	-0.24169	252	164",
	"10	Bolgatanga	10.78556	-0.85139	191	164",
	"10	Navrongo	10.89557	-1.0921	198	164",
	"10	Zonno	10.78442	-0.78449	222	164",
	"11	Wa	10.06069	-2.50192	326	164",
	"12	Bechem	7.09034	-2.02498	296	164",
	"12	Duayaw-Nkwanta	7.17487	-2.09961	329	164",
	"12	Goaso	6.80355	-2.5172	201	164",
	"12	Mim	6.90412	-2.56114	231	164",
	"13	Berekum	7.4534	-2.58404	330	164",
	"13	Domaa-Ahenkro	7.27386	-2.87348	276	164",
	"13	Japekrom	7.5758	-2.78516	267	164",
	"13	Nsoatre	7.40353	-2.46635	330	164",
	"13	Sunyani	7.33991	-2.32676	298	164",
	"13	Wankyi	7.73855	-2.1036	307	164",
	"14	Atebubu	7.75537	-0.98085	136	164",
	"14	Kintampo	8.05627	-1.73058	343	164",
	"14	Nkoranza	7.57127	-1.7087	324	164",
	"14	Techiman	7.59054	-1.93947	419	164",
	"14	Yegyi	8.22542	-0.64889	103	164",
	"15	Nalerigu	10.52726	-0.36982	353	164",
	"16	Dambai	8.06616	0.17947	116	164",
	"16	Kete Krachi	7.79391	-0.0498	117	164",
	"17	Damongo	9.08296	-1.81884	219	164",
	"17	Salaga	8.55083	-0.51875	163	164",
	"18	Bibiani	6.45196	-2.31635	212	164",
	"18	Sefwi Wiawso	6.20583	-2.48944	193	164",
];
