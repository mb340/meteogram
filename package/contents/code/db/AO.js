const CITIES = [
	"01	Baía Farta	-12.60417	13.19667	18	7",
	"01	Balombo	-12.35426	14.77232	1203	7",
	"01	Benguela	-12.57626	13.40547	11	7",
	"01	Bocoio	-12.47017	14.13688	972	7",
	"01	Caimbambo	-13.02172	14.00283	744	7",
	"01	Camboio	-12.92651	14.09888	739	7",
	"01	Catumbela	-12.43002	13.54677	12	7",
	"01	Chongoroi	-13.57418	13.94062	822	7",
	"01	Cubal	-13.03865	14.2455	912	7",
	"01	Dombe Grande	-12.95167	13.1025	51	7",
	"01	Ganda	-13.01592	14.63502	1267	7",
	"01	Lobito	-12.3644	13.53601	4	7",
	"01	Praia Bebe	-12.40959	13.50349	7	7",
	"02	Andulo	-11.48676	16.69663	1686	7",
	"02	Calucinga	-11.32281	16.19588	1757	7",
	"02	Camacupa	-12.01667	17.48333	1473	7",
	"02	Catabola	-12.15	17.28333	1531	7",
	"02	Chinguar	-12.55708	16.33805	1819	7",
	"02	Chissamba	-12.16667	17.33333	1404	7",
	"02	Chitembo	-13.55	16.63333	1607	7",
	"02	Cuemba	-12.15	18.08333	1374	7",
	"02	Cuito	-12.38333	16.93333	1715	7",
	"02	Cunhinga	-12.23333	16.78333	1772	7",
	"02	Dala	-13.78333	16.71667	1583	7",
	"02	Nharêa	-11.47512	16.96496	1645	7",
	"03	Cabinda	-5.56717	12.19787	3	7",
	"03	Cacongo	-5.23333	12.13333	-9999	7",
	"04	Calai	-17.88896	19.7706	1069	7",
	"04	Cuchi	-14.64978	16.89929	1353	7",
	"04	Jamba	-17.5	22.66667	1005	7",
	"04	Mavinga	-15.79171	20.35763	1132	7",
	"04	Menongue	-14.6585	17.69099	1355	7",
	"05	Camabatela	-8.18812	15.37495	1237	7",
	"05	Cazombo	-8.73204	15.37124	997	7",
	"05	Dondo	-9.05	15.31667	1127	7",
	"05	Dondo	-9.68456	14.42788	59	7",
	"05	Golungo Alto	-9.13333	14.76667	666	7",
	"05	Lucala	-9.27268	15.25206	708	7",
	"05	N'dalatando	-9.29782	14.91162	795	7",
	"05	Nzagi	-8.38549	15.30126	906	7",
	"06	Calulo	-10.00055	14.89519	995	7",
	"06	Capunda	-11.13333	14.46667	1183	7",
	"06	Cela	-11.42173	15.12345	1308	7",
	"06	Conda	-11.10862	14.33621	1039	7",
	"06	Ebo	-11.05	14.71667	1359	7",
	"06	Gabela	-10.85147	14.37993	1045	7",
	"06	Mussende	-9.95	14.8	920	7",
	"06	Porto Amboim	-10.73251	13.76844	36	7",
	"06	Quibala	-10.73366	14.97995	1284	7",
	"06	Quilenda	-11.46667	14.13333	249	7",
	"06	Quissecula	-11.39223	15.09201	1344	7",
	"06	Santa Clara	-10.19156	15.43408	1030	7",
	"06	Sumbe	-11.20605	13.84371	10	7",
	"06	Uacu Cungo	-11.35669	15.11719	1304	7",
	"06	Ucu Seles	-11.41237	14.30663	1035	7",
	"07	Cahama	-16.28556	14.30962	1127	7",
	"07	Ondjiva	-17.06667	15.73333	1113	7",
	"07	Xangongo	-16.7444	14.97494	1109	7",
	"08	Alto Hama	-12.23333	15.55	1509	7",
	"08	Caála	-12.8525	15.56056	1742	7",
	"08	Catchiungo	-12.56598	16.22589	1818	7",
	"08	Chela	-12.30261	15.43358	1716	7",
	"08	Chinjenje	-12.93244	14.99238	1895	7",
	"08	Ecunna	-12.67889	15.50556	1742	7",
	"08	Huambo	-12.77611	15.73917	1716	7",
	"08	Londuimbali	-12.23712	15.31697	1567	7",
	"08	Longonjo	-12.90795	15.24845	1451	7",
	"08	Mungo	-11.83268	16.23613	1533	7",
	"08	Ucuma	-12.96121	15.05958	1906	7",
	"09	Caconda	-13.73564	15.0618	1653	7",
	"09	Calonamba	-13.77395	15.09111	1547	7",
	"09	Caluquembe	-13.86667	14.43333	1774	7",
	"09	Chibia	-15.18315	13.69909	1469	7",
	"09	Chicomba	-14.13333	14.91667	1406	7",
	"09	Chipindo	-13.81419	15.79041	1592	7",
	"09	Lubango	-14.91717	13.4925	1760	7",
	"09	Matala	-14.73272	15.03479	1238	7",
	"09	Quipungo	-14.81909	14.53504	1302	7",
	"12	Bailundo	-9.57499	15.99442	1101	7",
	"12	Buco	-9.55833	16.14639	1041	7",
	"12	Cacuso	-9.42102	15.74668	1068	7",
	"12	Calandula	-9.08981	15.95382	1141	7",
	"12	Cambundi	-10.89481	17.76402	1121	7",
	"12	Cambundi	-7.46856	17.03769	515	7",
	"12	Cambundi Catembo	-10.07531	17.55058	1221	7",
	"12	Cangandala	-9.78333	16.43333	1104	7",
	"12	Malanje	-9.54015	16.34096	1134	7",
	"13	Bibala	-14.7665	13.34912	909	7",
	"13	Mossamedes	-15.19611	12.15222	13	7",
	"13	Tômbua	-15.80394	11.84485	11	7",
	"14	Calandula	-13.46667	19.61667	1328	7",
	"14	Camanongue	-11.4361	20.16459	1264	7",
	"14	Cameia	-11.69055	20.83922	1131	7",
	"14	Cazombo	-11.89355	22.9024	1121	7",
	"14	Léua	-11.65753	20.44772	1241	7",
	"14	Luau	-10.70727	22.22466	1106	7",
	"14	Luena	-11.78333	19.91667	1337	7",
	"14	Lumbala	-14.10165	21.43531	1122	7",
	"14	Lumeji	-11.55768	20.78096	1148	7",
	"15	Banza Damba	-6.88831	15.01522	913	7",
	"15	Damba	-6.67868	15.13128	1114	7",
	"15	Maquela do Zombo	-6.05716	15.10971	904	7",
	"15	Negage	-7.75938	15.2722	1240	7",
	"15	Puri	-7.69468	15.65416	1136	7",
	"15	Sanza Pombo	-7.31473	16.0024	912	7",
	"15	Songo	-7.35207	14.84629	721	7",
	"15	Uíge	-7.60874	15.06131	825	7",
	"16	Ambrizette	-7.23116	12.8666	19	7",
	"16	Cuímba	-6.12085	14.62086	536	7",
	"16	Mbanza Kongo	-6.26667	14.23833	531	7",
	"16	Soyo	-6.1349	12.36894	10	7",
	"16	Tombôco	-6.80517	13.33017	396	7",
	"17	Cafunfo	-8.7672	17.99572	853	7",
	"17	Cassanguidi	-7.48367	21.30339	758	7",
	"17	Cuango-Luzamba	-9.14583	18.04453	863	7",
	"17	Dundo	-7.36643	20.81557	733	7",
	"17	Lucapa	-8.41915	20.74466	955	7",
	"18	Cacolo	-10.14503	19.26598	1356	7",
	"18	Cazaji	-11.06715	20.70148	1188	7",
	"18	Dala	-11.03333	20.2	1233	7",
	"18	Muconda	-10.59236	21.31805	1097	7",
	"18	Saurimo	-9.66078	20.39155	1071	7",
	"19	Ambriz	-7.86232	13.11935	22	7",
	"19	Barra do Dande	-8.47175	13.37011	10	7",
	"19	Caxito	-8.57848	13.66425	20	7",
	"19	Gama	-8.5675	13.47639	8	7",
	"19	Quibaxe	-8.50055	14.58589	867	7",
	"20	Luanda	-8.83682	13.23432	73	7",
];
